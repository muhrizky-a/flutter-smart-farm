abstract class StreamableEventService {
  void connect();
  void disconnect();
  bool isConnectedToServer();
  void subscribe(String topic, void Function(String) onSubscribe);
  void publish(String topic, String rawValue);
}
