/// Booking that the logged-in worker is assigned to.
///
/// Hydrated from the response of `GET /api/workers/:workerId/job-cards`.
/// The job-cards response schema is not documented in the root postman
/// collection, so [BookingRequestModel.fromJobCard] reads fields tolerantly
/// and all optional fields may be `null`. When a real sample diverges,
/// adjust only that factory — consumers use typed getters.
class BookingRequestModel {
  final String bookingId;
  final String? status;
  final String? paymentStatus;
  final String? paymentMethodUsed;

  final String? serviceType;
  final String? level2;
  final String? level3;
  final List<String> addons;

  final String? customerId;
  final String? customerName;
  final String? customerPhone;

  final String? addressText;
  final double? addressLat;
  final double? addressLng;

  final DateTime? scheduledAt;
  final DateTime? slotStart;
  final DateTime? slotEnd;
  final String? branchId;
  final String? branchName;

  final num? totalAmount;
  final num? basePrice;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final Map<String, dynamic> raw;

  const BookingRequestModel({
    required this.bookingId,
    this.status,
    this.paymentStatus,
    this.paymentMethodUsed,
    this.serviceType,
    this.level2,
    this.level3,
    this.addons = const [],
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.addressText,
    this.addressLat,
    this.addressLng,
    this.scheduledAt,
    this.slotStart,
    this.slotEnd,
    this.branchId,
    this.branchName,
    this.totalAmount,
    this.basePrice,
    this.createdAt,
    this.updatedAt,
    this.raw = const {},
  });

  factory BookingRequestModel.fromJobCard(Map<String, dynamic> json) {
    final booking = _pickMap(json, ['booking']) ?? json;

    final customer = _pickMap(booking, ['customer', 'user', 'client']) ?? {};
    final address = _pickMap(booking, ['address', 'deliveryAddress']) ?? {};
    final branch = _pickMap(booking, ['branch']) ?? {};
    final slot = _pickMap(booking, ['slot', 'timeSlot']) ?? {};
    final service = _pickMap(booking, ['service', 'mainService']) ?? {};

    final id = _pickString(booking, ['id', '_id', 'bookingId']) ??
        _pickString(json, ['id', '_id', 'bookingId']) ??
        '';

    // Worker-lifecycle status (`booking_workers.status` joined in) is the
    // primary driver of action-button visibility. Fall back to the booking's
    // global status only if the join isn't populated.
    final workerStatus = _pickString(booking, ['workerStatus']);
    final bookingStatus = _pickString(booking, ['status', 'bookingStatus']);

    return BookingRequestModel(
      bookingId: id,
      status: workerStatus ?? bookingStatus,
      paymentStatus: _pickString(booking, ['paymentStatus']),
      paymentMethodUsed: _pickString(
        booking,
        ['paymentMethodUsed', 'paymentMethod'],
      ),
      serviceType: _pickString(booking, ['serviceType', 'type']) ??
          _pickString(service, ['type', 'category']),
      level2: _pickString(booking, ['level_2', 'level2', 'category']) ??
          _pickString(service, ['level_2', 'level2', 'category']),
      level3: _pickString(booking, ['level_3', 'level3', 'serviceName']) ??
          _pickString(service, ['level_3', 'level3', 'name']),
      addons: _extractAddons(booking),
      customerId: _pickString(customer, ['id', '_id', 'uid']) ??
          _pickString(booking, ['customerId', 'userId']),
      customerName: _pickString(customer, ['name', 'fullName']) ??
          _composeName(
            _pickString(customer, ['firstName']),
            _pickString(customer, ['lastName']),
          ) ??
          _pickString(booking, ['customerName']),
      customerPhone: _pickString(
            customer,
            ['phoneNumber', 'phone', 'mobile'],
          ) ??
          _pickString(booking, ['customerPhone']),
      addressText: _pickString(
            address,
            ['formattedAddress', 'fullAddress', 'address', 'text'],
          ) ??
          _joinNonEmpty([
            _pickString(booking, ['address']),
            _pickString(booking, ['postTown']),
            _pickString(booking, ['zipCode']),
            _pickString(booking, ['country']),
          ]),
      addressLat: _pickDouble(address, ['lat', 'latitude']) ??
          _pickDouble(booking, ['lat', 'latitude']),
      addressLng: _pickDouble(address, ['lng', 'longitude']) ??
          _pickDouble(booking, ['lng', 'longitude']),
      scheduledAt:
          _pickDate(booking, ['scheduledAt', 'scheduledDate', 'schedule']),
      slotStart: _pickDate(slot, ['start', 'startTime', 'from']) ??
          _pickDate(booking, ['slotStart', 'startTime']),
      slotEnd: _pickDate(slot, ['end', 'endTime', 'to']) ??
          _pickDate(booking, ['slotEnd', 'endTime']),
      branchId: _pickString(branch, ['id', '_id']) ??
          _pickString(booking, ['branchId']),
      branchName: _pickString(branch, ['name']) ??
          _pickString(booking, ['branchName']),
      totalAmount: _pickNum(
            booking,
            ['totalAmount', 'total', 'amount', 'finalPrice'],
          ) ??
          _pickNum(
            _pickMap(booking, ['pricingBreakdown']) ?? {},
            ['final', 'total'],
          ),
      basePrice: _pickNum(
            booking,
            ['basePrice', 'price', 'quotedPrice'],
          ) ??
          _pickNum(_pickMap(booking, ['pricingBreakdown']) ?? {}, ['base']),
      createdAt: _pickDate(booking, ['createdAt']),
      updatedAt: _pickDate(
        booking,
        ['updatedAt', 'completedAt', 'startedAt', 'assignedAt'],
      ),
      raw: Map<String, dynamic>.from(booking),
    );
  }

  static String? _joinNonEmpty(List<String?> parts) {
    final kept = parts.where((p) => p != null && p.isNotEmpty).join(', ');
    return kept.isEmpty ? null : kept;
  }

  BookingRequestModel copyWith({
    String? status,
    String? paymentStatus,
    String? paymentMethodUsed,
  }) {
    return BookingRequestModel(
      bookingId: bookingId,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethodUsed: paymentMethodUsed ?? this.paymentMethodUsed,
      serviceType: serviceType,
      level2: level2,
      level3: level3,
      addons: addons,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      addressText: addressText,
      addressLat: addressLat,
      addressLng: addressLng,
      scheduledAt: scheduledAt,
      slotStart: slotStart,
      slotEnd: slotEnd,
      branchId: branchId,
      branchName: branchName,
      totalAmount: totalAmount,
      basePrice: basePrice,
      createdAt: createdAt,
      updatedAt: updatedAt,
      raw: raw,
    );
  }

  /// Back-compat: existing tiles still reference `cleaningType`.
  String get cleaningType =>
      level3 ?? level2 ?? serviceType ?? 'Servana Booking';

  /// Back-compat: existing tiles still reference `price`.
  String get price {
    final amount = totalAmount ?? basePrice;
    return amount == null ? '0.00' : amount.toStringAsFixed(2);
  }

  /// Back-compat: existing tiles still reference `address`.
  String get address => addressText ?? '';

  /// Back-compat: existing tiles still reference `updated`.
  DateTime get updated =>
      updatedAt ?? slotStart ?? scheduledAt ?? createdAt ?? DateTime.now();

  // --- helpers -------------------------------------------------------------

  static Map<String, dynamic>? _pickMap(Map<String, dynamic> src, List<String> keys) {
    for (final k in keys) {
      final v = src[k];
      if (v is Map) return Map<String, dynamic>.from(v);
    }
    return null;
  }

  static String? _pickString(Map<String, dynamic> src, List<String> keys) {
    for (final k in keys) {
      final v = src[k];
      if (v == null) continue;
      final s = v.toString();
      if (s.isNotEmpty) return s;
    }
    return null;
  }

  static double? _pickDouble(Map<String, dynamic> src, List<String> keys) {
    for (final k in keys) {
      final v = src[k];
      if (v is num) return v.toDouble();
      if (v is String) {
        final p = double.tryParse(v);
        if (p != null) return p;
      }
    }
    return null;
  }

  static num? _pickNum(Map<String, dynamic> src, List<String> keys) {
    for (final k in keys) {
      final v = src[k];
      if (v is num) return v;
      if (v is String) {
        final p = num.tryParse(v);
        if (p != null) return p;
      }
    }
    return null;
  }

  static DateTime? _pickDate(Map<String, dynamic> src, List<String> keys) {
    for (final k in keys) {
      final v = src[k];
      if (v == null) continue;
      if (v is DateTime) return v;
      final parsed = DateTime.tryParse(v.toString());
      if (parsed != null) return parsed;
    }
    return null;
  }

  static String? _composeName(String? first, String? last) {
    final joined = '${first ?? ''} ${last ?? ''}'.trim();
    return joined.isEmpty ? null : joined;
  }

  /// Flattens the addon list from whichever shape the API uses:
  /// - `booking.addons: [{name}, ...]`
  /// - `booking.selectedOptions: [{optionType: 'ADD_ON', name}, ...]`
  /// - `booking.options: [{addons: [...]}]` nested
  static List<String> _extractAddons(Map<String, dynamic> src) {
    final out = <String>[];

    void pushName(dynamic entry) {
      if (entry is Map) {
        final n = entry['name'] ?? entry['label'] ?? entry['title'];
        if (n is String && n.isNotEmpty) out.add(n);
      } else if (entry is String && entry.isNotEmpty) {
        out.add(entry);
      }
    }

    final addons = src['addons'];
    if (addons is List) {
      for (final a in addons) {
        pushName(a);
      }
    }

    // Some backends bury addons under pricingBreakdown.addons as [{name,...}].
    final breakdown = src['pricingBreakdown'];
    if (breakdown is Map) {
      final bkAddons = breakdown['addons'];
      if (bkAddons is List) {
        for (final a in bkAddons) {
          pushName(a);
        }
      }
    }

    final selected = src['selectedOptions'] ?? src['options'];
    if (selected is List) {
      for (final opt in selected) {
        if (opt is Map) {
          final type = opt['optionType']?.toString().toUpperCase();
          if (type == 'ADD_ON' || type == 'ADDON') {
            pushName(opt);
          }
          final nested = opt['addons'];
          if (nested is List) {
            for (final a in nested) {
              pushName(a);
            }
          }
        }
      }
    }

    return out;
  }
}
