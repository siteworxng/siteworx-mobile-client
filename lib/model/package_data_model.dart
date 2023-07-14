import 'package:client/model/service_data_model.dart';

class BookingPackage {
  int? id;
  String? name;
  String? description;
  num? price;
  String? startDate;
  String? endDate;
  List<ServiceData>? serviceList;
  var isFeatured;
  int? categoryId;
  List<Attachments>? attchments;
  List<String>? imageAttachments;
  int? status;
  String? packageType;

  BookingPackage({
    this.id,
    this.name,
    this.description,
    this.price,
    this.startDate,
    this.endDate,
    this.serviceList,
    this.isFeatured,
    this.categoryId,
    this.attchments,
    this.imageAttachments,
    this.status,
    this.packageType,
  });

  BookingPackage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    if (json['services'] != null) {
      serviceList = [];
      json['services'].forEach((v) {
        serviceList!.add(ServiceData.fromJson(v));
      });
    }
    attchments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
    imageAttachments = json['attchments'] != null ? List<String>.from(json['attchments']) : null;
    categoryId = json['category_id'];
    isFeatured = json['is_featured'];
    packageType = json['package_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['package_type'] = this.packageType;
    if (this.serviceList != null) {
      data['services'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = this.categoryId;
    data['is_featured'] = this.isFeatured;
    if (this.attchments != null) {
      data['attchments_array'] = this.attchments!.map((v) => v.toJson()).toList();
    }
    if (this.imageAttachments != null) {
      data['attchments'] = this.imageAttachments;
    }
    return data;
  }
}

class Attachments {
  int? id;
  String? url;

  Attachments({this.id, this.url});

  factory Attachments.fromJson(Map<String, dynamic> json) {
    return Attachments(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }
}
