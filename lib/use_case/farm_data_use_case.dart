import 'dart:convert';
import '../services/base/streamable_event_service.dart';

class FarmDataUseCase {
  FarmDataUseCase(this.service);

  StreamableEventService service;

  bool isConnectedToServer() => service.isConnectedToServer();

  void subscribe(String topic, void Function(String) onSubscribe) =>
      service.subscribe(topic, onSubscribe);

  void publish(String topic, Map<String, dynamic> data) {
    service.publish(topic, jsonEncode(data));
  }

  void disconnect() => service.disconnect();
}
