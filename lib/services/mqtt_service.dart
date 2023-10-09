import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  late final MqttServerClient client;
  final String server;
  final int port;
  final String topic;

  void _onConnected() {
    debugPrint('MQTT_LOGS:: Connected');
    subscribeMessage();
  }

  void _onDisconnected() {
    debugPrint('MQTT_LOGS:: Disconnected');
  }

  void _onSubscribed(String topic) {
    debugPrint('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void _onSubscribeFail(String topic) {
    debugPrint('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void _onUnsubscribed(String? topic) {
    debugPrint('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void _pong() {
    debugPrint('MQTT_LOGS:: Ping response client callback invoked');
  }

  void connect() async {
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      debugPrint('client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      debugPrint('socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('client connected');
    } else {
      debugPrint(
          'client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }
  }

  MQTTService(this.server, this.port, this.topic) {
    client = MqttServerClient.withPort(server, "", port);
    client.logging(on: true);
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onUnsubscribed = _onUnsubscribed;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFail;
    client.pongCallback = _pong;
    client.keepAlivePeriod = 60;
    client.logging(on: true);
    client.setProtocolV311();

    final connMess = MqttConnectMessage()
        .withClientIdentifier('dart_client')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    connect();
  }

  MqttConnectionState getConnectionStatus() {
    return client.connectionStatus!.state;
  }

  Stream subscribeMessage() {
    client.subscribe(topic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      debugPrint(server);
      debugPrint('Received message: topic is ${c[0].topic}, payload is $pt');
    });

    return client.updates!;
  }

  void publishMessage(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }

    client.published!.listen((MqttPublishMessage message) {
      debugPrint(
        'Published topic: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}',
      );
    });
  }
}
