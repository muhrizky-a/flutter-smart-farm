import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;
import 'base/streamable_event_service.dart';

class WebsocketService extends StreamableEventService {
  late final WebSocketChannel channel;
  final String server;
  final int port;
  String topic = "";

  WebsocketService(this.server, this.port);

  @override
  Future<void> connect() async {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse('ws://$server:$port/$topic'),
      );
      await channel.ready;
    } catch (e) {
      debugPrint("ws error: $e");
      disconnect();
    }
  }

  @override
  void disconnect() {
    channel.sink.close();
  }

  @override
  bool isConnectedToServer() {
    return channel.protocol != null;
  }

  @override
  void publish(String topic, String rawValue) {
    channel.sink.add(rawValue);
  }

  Future<void> _setTopic(String topic) async {
    if (this.topic != topic) {
      this.topic = topic;

      await connect();
    }
  }

  @override
  Future<void> subscribe(String topic, Function(String) onSubscribe) async {
    await _setTopic(topic);

    channel.stream.listen((message) {
      String data = message.toString();
      onSubscribe(data);
    }, onError: (e) {
      debugPrint("ws subscription error: $e");
    });
  }
}
