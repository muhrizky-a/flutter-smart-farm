import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import '../models/farm_data.dart';
import 'mqtt_service.dart';

class FarmDataService extends MQTTService {
  FarmDataService(super.server, super.port, super.topic);

  FarmData? getFarmDataFromStream(
      List<MqttReceivedMessage<MqttMessage?>>? data) {
    FarmData? farmData;

    final recMess = data![0].payload as MqttPublishMessage;
    final String rawData =
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    Map<String, dynamic> decodedFarmData = jsonDecode(rawData);

    farmData = FarmData.fromJson({
      "status": decodedFarmData["status"],
      "soilHumidity": decodedFarmData["soilHumidity"],
      "temperature": decodedFarmData["temperature"],
      "airHumidity": decodedFarmData["airHumidity"],
      "sprinklerEnabled": decodedFarmData["sprinklerEnabled"],
      "lampEnabled": decodedFarmData["lampEnabled"],
    });

    return farmData;
  }

  void publish(FarmData farmData) {
    super.publishMessage(jsonEncode(farmData.toJson()));
  }

  void disconnect() {
    super.client.disconnect();
  }
}
