class RemoteConfigDataModel {
  bool? isForceUpdate;
  bool? inMaintenanceMode;
  List<String>? changeLogs;
  VersionInfo? android;
  VersionInfo? iOS;

  RemoteConfigDataModel({
    this.isForceUpdate,
    this.inMaintenanceMode,
    this.changeLogs,
    this.android,
    this.iOS,
  });

  RemoteConfigDataModel.fromJson(dynamic json) {
    isForceUpdate = json['isForceUpdate'] ?? false;
    inMaintenanceMode = json['inMaintenanceMode'] ?? false;
    changeLogs = json['changeLogs'] != null ? json['changeLogs'].cast<String>() : [];
    android = json['android'] != null ? VersionInfo.fromJson(json['android']) : VersionInfo();
    iOS = json['iOS'] != null ? VersionInfo.fromJson(json['iOS']) : VersionInfo();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isForceUpdate'] = isForceUpdate;
    map['inMaintenanceMode'] = inMaintenanceMode;
    map['changeLogs'] = changeLogs;
    if (android != null) {
      map['android'] = android?.toJson();
    }
    if (iOS != null) {
      map['iOS'] = iOS?.toJson();
    }
    return map;
  }
}

class VersionInfo {
  String? versionName;
  String? versionCode;

  VersionInfo({this.versionName, this.versionCode});

  VersionInfo.fromJson(dynamic json) {
    versionName = json['versionName'];
    versionCode = json['versionCode'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['versionName'] = versionName;
    map['versionCode'] = versionCode;
    return map;
  }
}
