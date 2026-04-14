class BookingRequestModel {
  final String cleaningType;
  final String customerName;
  final String price;
  final String address;
  final String status;
  final DateTime updated;

  BookingRequestModel({
    required this.cleaningType,
    required this.customerName,
    required this.price,
    required this.address,
    required this.status,
    required this.updated,
  });

  factory BookingRequestModel.fromJson(Map<String, dynamic> json) =>
      BookingRequestModel(
        cleaningType: json["cleaningType"],
        customerName: json["customerName"],
        price: json["price"],
        address: json["address"],
        status: json["status"],
        updated: DateTime.parse(json["updated"]),
      );

  Map<String, dynamic> toJson() => {
        "cleaningType": cleaningType,
        "customerName": customerName,
        "price": price,
        "address": address,
        "status": status,
        "updated": updated.toIso8601String(),
      };
}
