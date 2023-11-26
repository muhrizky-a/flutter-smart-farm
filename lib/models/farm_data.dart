class FarmData {
  FarmData({
    this.status = '',
    this.soilHumidity = 0,
    this.temperature = 0,
    this.airHumidity = 0,
    this.soilPh = 0,
    this.sprinklerEnabled = false,
    this.lampEnabled = false,
  });

  String status;
  int soilHumidity;
  int temperature;
  int airHumidity;
  int soilPh;
  bool sprinklerEnabled;
  bool lampEnabled;

  Map<String, dynamic> toJson({required String key, required dynamic value}) {
    final data = <String, dynamic>{};

    data[key] = value;
    print(data);
    print(data[key]);
    print("");
    return data;
  }
}
