class EarningsModel {
    final String earningsId;
    final String client;
    final String price;
    final String address;
    final String cleaningType;
    final String status;
    final DateTime updated;

    EarningsModel({
        required this.earningsId,
        required this.client,
        required this.price,
        required this.address,
        required this.cleaningType,
        required this.status,
        required this.updated,
    });

    factory EarningsModel.fromJson(Map<String, dynamic> json) => EarningsModel(
        earningsId: json["earningsId"],
        client: json["client"],
        price: json["price"],
        address: json["address"],
        cleaningType: json["cleaningType"],
        status: json["status"],
        updated: DateTime.parse(json["updated"]),
    );

    Map<String, dynamic> toJson() => {
        "earningsId": earningsId,
        "client": client,
        "price": price,
        "address": address,
        "cleaningType": cleaningType,
        "status": status,
        "updated": updated.toIso8601String(),
    };
}