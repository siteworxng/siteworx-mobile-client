class StateListResponse {
  int? countryId;
  int? id;
  String? name;

  StateListResponse({this.countryId, this.id, this.name});

  factory StateListResponse.fromJson(Map<String, dynamic> json) {
    return StateListResponse(
      countryId: json['country_id'],
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
