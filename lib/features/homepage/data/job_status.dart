import 'models/bookingrequest_model.dart';

/// Canonical status buckets for provider-side job-cards.
///
/// The server's raw status strings aren't fully documented yet; these buckets
/// read tolerantly so a status we haven't seen before doesn't silently vanish
/// from every tab. New statuses fall through to [isPending] by default.
abstract final class JobStatus {
  static const ongoing = {'IN_PROGRESS', 'STARTED', 'ONGOING'};
  static const completed = {'COMPLETED', 'DONE', 'FINISHED'};
  static const cancelled = {'CANCELLED', 'CANCELED', 'DECLINED', 'REJECTED'};
  static const toConfirm = {'PENDING', 'AWAITING', 'NEW'};
  static const upcoming = {'CONFIRMED', 'ASSIGNED', 'SCHEDULED'};
  static const accepted = {'ACCEPTED', 'APPROVED', 'CONFIRMED_BY_WORKER'};

  static String norm(BookingRequestModel b) =>
      (b.status ?? '').trim().toUpperCase();

  static bool isOngoing(BookingRequestModel b) => ongoing.contains(norm(b));
  static bool isCompleted(BookingRequestModel b) => completed.contains(norm(b));
  static bool isCancelled(BookingRequestModel b) => cancelled.contains(norm(b));
  static bool isToConfirm(BookingRequestModel b) => toConfirm.contains(norm(b));
  static bool isUpcoming(BookingRequestModel b) => upcoming.contains(norm(b));
  static bool isAccepted(BookingRequestModel b) => accepted.contains(norm(b));

  /// Home-screen "Pending Requests" = anything awaiting action that isn't
  /// already in-progress / completed / cancelled.
  static bool isPending(BookingRequestModel b) {
    final s = norm(b);
    return !ongoing.contains(s) &&
        !completed.contains(s) &&
        !cancelled.contains(s);
  }

  // --- Action visibility ---------------------------------------------------

  /// Worker hasn't taken the job yet — show Accept.
  static bool canAccept(BookingRequestModel b) {
    final s = norm(b);
    return toConfirm.contains(s) || upcoming.contains(s);
  }

  /// Worker has accepted but not yet started — show Start.
  static bool canStart(BookingRequestModel b) => isAccepted(b);

  /// Job is running — show Complete.
  static bool canComplete(BookingRequestModel b) => isOngoing(b);

  /// Cash booking where money hasn't been marked collected yet — show the
  /// cash-confirmation step before calling `completeJob`.
  static bool canCollectCash(BookingRequestModel b) {
    final method = (b.paymentMethodUsed ?? '').toUpperCase();
    final payStatus = (b.paymentStatus ?? '').toUpperCase();
    return method == 'CASH' && payStatus != 'PAID';
  }
}
