class CityListResponse {
  int? id;
  String? name;
  int? stateId;

  CityListResponse({this.id, this.name, this.stateId});

  factory CityListResponse.fromJson(Map<String, dynamic> json) {
    return CityListResponse(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    return data;
  }
}
