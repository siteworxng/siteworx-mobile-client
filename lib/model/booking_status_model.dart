class BookingStatusResponse {
  int? id;
  String? value;
  String? label;
  int? status;
  int? sequence;
  String? createdAt;
  String? updatedAt;

  BookingStatusResponse({this.id, this.value, this.label, this.status, this.sequence, this.createdAt, this.updatedAt});

  BookingStatusResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
    label = json['label'];
    status = json['status'];
    sequence = json['sequence'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    data['label'] = this.label;
    data['status'] = this.status;
    data['sequence'] = this.sequence;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
