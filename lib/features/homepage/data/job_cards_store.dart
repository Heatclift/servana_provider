import 'package:flutter/foundation.dart';

import '../../../core/api/servana_api.dart';
import '../../../core/api/servana_api_exception.dart';
import '../../../core/api/session_profile.dart';
import 'models/bookingrequest_model.dart';

/// Shared in-memory cache of the logged-in worker's assigned bookings.
///
/// Backed by `GET /api/workers/:workerId/job-cards`. Consumed by home, jobs,
/// calendar, and earnings so they all stay in sync from a single fetch.
class JobCardsStore extends ChangeNotifier {
  JobCardsStore(this._api, this._profile);

  final ServanaApi _api;
  final SessionProfile _profile;

  bool _loading = false;
  String? _error;
  List<BookingRequestModel> _jobs = const [];
  bool _everLoaded = false;
  int _reqCounter = 0;

  bool get loading => _loading;
  String? get error => _error;
  List<BookingRequestModel> get jobs => _jobs;
  bool get everLoaded => _everLoaded;

  // Defensive extraction + dedupe + stale-response guard below are deliberate
  // speculative generality, not a band-aid around a specific endpoint bug.
  // `GET /api/workers/:uid/job-cards` returns a bare List today, but the
  // wider API mixes response envelopes ({status, data}, {success, bookings},
  // nested `data.bookings`, ...). Keeping these defensive helps us absorb
  // server-shape tweaks without a matching client release. If you're tempted
  // to strip any of this "because the endpoint returns a clean list now,"
  // don't — read the response the server actually sends for your environment
  // first and keep the fallbacks for the others.
  Future<void> load({bool force = false}) async {
    if (_loading) return;
    if (_everLoaded && !force && _error == null) return;

    final workerId = _profile.id;
    if (workerId == null || workerId.isEmpty) {
      _loading = false;
      _error = 'Signed-in session has no worker id. Please log in again.';
      _jobs = const [];
      _everLoaded = true;
      notifyListeners();
      return;
    }

    final reqId = ++_reqCounter;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.getWorkerJobCards(workerId);
      if (reqId != _reqCounter) return; // stale response — a clear()/refresh() superseded us
      final items = _extractJobCards(res.data);
      // Dedupe defensively — if the server ever returns duplicate rows per
      // booking (e.g. from a join without DISTINCT), keep the most advanced
      // state per bookingId.
      final parsed = items
          .whereType<Map>()
          .map((m) =>
              BookingRequestModel.fromJobCard(Map<String, dynamic>.from(m)))
          .where((b) => b.bookingId.isNotEmpty);

      final byId = <String, BookingRequestModel>{};
      for (final b in parsed) {
        final existing = byId[b.bookingId];
        if (existing == null || _statusRank(b) > _statusRank(existing)) {
          byId[b.bookingId] = b;
        }
      }
      _jobs = byId.values.toList();
      _error = null;
    } on ServanaApiException catch (e) {
      if (reqId != _reqCounter) return;
      _error = e.message;
    } catch (_) {
      if (reqId != _reqCounter) return;
      _error = 'Could not load your assigned jobs.';
    } finally {
      if (reqId == _reqCounter) {
        _loading = false;
        _everLoaded = true;
        notifyListeners();
      }
    }
  }

  Future<void> refresh() => load(force: true);

  /// Optimistic patch of a single booking after a successful mutation.
  ///
  /// Caller is responsible for then scheduling a [refresh] to reconcile with
  /// the server's canonical state.
  void patchBooking(
    String bookingId, {
    String? status,
    String? paymentStatus,
    String? paymentMethodUsed,
  }) {
    var touched = false;
    _jobs = _jobs.map((b) {
      if (b.bookingId != bookingId) return b;
      touched = true;
      return b.copyWith(
        status: status,
        paymentStatus: paymentStatus,
        paymentMethodUsed: paymentMethodUsed,
      );
    }).toList();
    if (touched) notifyListeners();
  }

  void clear() {
    _reqCounter++; // invalidate any in-flight load
    _loading = false;
    _jobs = const [];
    _error = null;
    _everLoaded = false;
    notifyListeners();
  }

  /// Ranks statuses so dedupe keeps the most advanced copy of a duplicated
  /// booking row. Terminal states (CANCELLED / COMPLETED) rank highest so a
  /// duplicated row carrying a terminal status always wins over an active
  /// one — otherwise we'd render a Start button on a cancelled booking.
  int _statusRank(BookingRequestModel b) {
    final s = (b.status ?? '').toUpperCase();
    const order = [
      'CANCELLED',
      'CANCELED',
      'COMPLETED',
      'DONE',
      'FINISHED',
      'IN_PROGRESS',
      'STARTED',
      'ONGOING',
      'ACCEPTED',
      'APPROVED',
      'CONFIRMED_BY_WORKER',
      'ASSIGNED',
      'CONFIRMED',
      'SCHEDULED',
      'PENDING',
    ];
    final i = order.indexOf(s);
    return i < 0 ? -1 : (order.length - i);
  }

  List<dynamic> _extractJobCards(dynamic body) {
    if (body is List) return body;
    if (body is Map) {
      // Top-level list under various keys (e.g. /api/bookings/all returns
      // `{success:true, bookings:[...]}`).
      for (final k in const [
        'jobCards',
        'jobs',
        'bookings',
        'items',
        'results',
      ]) {
        final v = body[k];
        if (v is List) return v;
      }
      final data = body['data'];
      if (data is List) return data;
      if (data is Map) {
        for (final k in const [
          'jobCards',
          'jobs',
          'bookings',
          'items',
          'results',
        ]) {
          final v = data[k];
          if (v is List) return v;
        }
      }
    }
    return const [];
  }
}
