class ExtraChargesModel {
  num? id;
  num? bookingId;
  String? title;
  num? price;
  num? qty;
  dynamic createdAt;
  dynamic updatedAt;

  num get total => price! * qty!;

  ExtraChargesModel({
    this.id,
    this.bookingId,
    this.title,
    this.price,
    this.qty,
    this.createdAt,
    this.updatedAt,
  });

  ExtraChargesModel.fromJson(dynamic json) {
    id = json['id'];
    bookingId = json['booking_id'];
    title = json['title'];
    price = json['price'];
    qty = json['qty'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['booking_id'] = bookingId;
    map['title'] = title;
    map['price'] = price;
    map['qty'] = qty;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}
