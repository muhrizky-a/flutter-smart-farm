abstract class StreamableEventService {
  void connect();
  void disconnect();
  Stream getStream();
  bool isConnectedToServer();
  String getRawData(dynamic data);
  Stream subscribe(String topic);
  void publish(String topic, String rawValue);
}
