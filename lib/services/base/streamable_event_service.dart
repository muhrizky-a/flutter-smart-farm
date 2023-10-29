abstract class StreamableEventService {
  void connect();
  void disconnect();
  Stream getStream();
  dynamic getConnectionStatus();
  String getRawData(dynamic data);
  Stream subscribe(String topic);
  void publish(String topic, String rawValue);
}
