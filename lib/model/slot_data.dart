class SlotData {
  String? day;
  List<String>? slot;

  SlotData({this.day, this.slot});

  factory SlotData.fromJson(Map<String, dynamic> json) {
    return SlotData(
      day: json['day'],
      slot: json['slot'] != null ? new List<String>.from(json['slot']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    if (this.slot != null) {
      data['slot'] = this.slot!.toSet().toList();
    }
    return data;
  }

  Map<String, dynamic> toJsonRequest() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    if (this.slot != null) {
      data['time'] = this.slot!.toSet().toList();
    }
    return data;
  }
}
