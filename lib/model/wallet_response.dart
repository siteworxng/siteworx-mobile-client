class WalletResponse {
  num? balance;

  WalletResponse({this.balance});

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    return data;
  }
}
