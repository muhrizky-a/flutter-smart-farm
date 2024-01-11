import 'dart:convert';
import '../services/base/streamable_event_service.dart';

class FarmDataUseCase {
  FarmDataUseCase(this.service);

  StreamableEventService service;

  Stream getStream() => service.getStream();
  String getRawData(dynamic data) => service.getRawData(data);

  bool isConnectedToServer() => service.isConnectedToServer();

  Stream subscribe(String topic) => service.subscribe(topic);

  void publish(String topic, Map<String, dynamic> data) {
    service.publish(topic, jsonEncode(data));
  }

  void disconnect() => service.disconnect();
}
