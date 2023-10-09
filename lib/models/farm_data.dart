class FarmData {
  FarmData({
    required this.status,
    required this.soilHumidity,
    required this.temperature,
    required this.airHumidity,
    required this.sprinklerEnabled,
    required this.lampEnabled,
  });

  final String status;
  final int soilHumidity;
  final int temperature;
  final int airHumidity;
  final bool sprinklerEnabled;
  final bool lampEnabled;

  factory FarmData.fromJson(Map<String, dynamic> json) {
   

    return FarmData(
      status: json['status'],
      soilHumidity: json['soilHumidity'],
      temperature: json['temperature'],
      airHumidity: json['airHumidity'],
      sprinklerEnabled: json['sprinklerEnabled'],
      lampEnabled: json['lampEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['soilHumidity'] = soilHumidity;
    data['temperature'] = temperature;
    data['airHumidity'] = airHumidity;
    data['sprinklerEnabled'] = sprinklerEnabled;
    data['lampEnabled'] = lampEnabled;

    return data;
  }
}
