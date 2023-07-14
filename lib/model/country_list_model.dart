class CountryListResponse {
  String? code;
  String? currencyCode;
  String? currencyName;
  var dialCode;
  int? id;
  String? name;
  String? symbol;

  CountryListResponse({this.code, this.currencyCode, this.currencyName, this.dialCode, this.id, this.name, this.symbol});

  factory CountryListResponse.fromJson(Map<String, dynamic> json) {
    return CountryListResponse(
      code: json['code'],
      currencyCode: json['currency_code'],
      currencyName: json['currency_name'],
      dialCode: json['dial_code'],
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['currency_code'] = this.currencyCode;
    data['currency_name'] = this.currencyName;
    data['dial_code'] = this.dialCode;
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    return data;
  }
}
