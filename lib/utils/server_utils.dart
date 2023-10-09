import 'package:shared_preferences/shared_preferences.dart';

class ServerUtils {
  static const String _defaultServerURL = "broker.hivemq.com";
  static const int _defaultPort = 1883;
  static const String _defaultTopic = "farm-data";

  static Future<String> getServerURL() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? server = sharedPreferences.getString("server");
    return server ?? _defaultServerURL;
  }

  static Future<int> getPort() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? port = sharedPreferences.getInt("port");
    return port ?? _defaultPort;
  }

  static Future<String> getTopic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? topic = sharedPreferences.getString("topic");
    return topic ?? _defaultTopic;
  }

  static Future<void> setServerURL(String server) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("server", server);
  }

  static Future<void> setPort(int port) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt("port", port);
  }

  static Future<void> setTopic(String topic) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("topic", topic);
  }

  static Future<void> resetSettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("server", _defaultServerURL);
    await sharedPreferences.setInt("port", _defaultPort);
    await sharedPreferences.setString("topic", _defaultTopic);
  }
}
