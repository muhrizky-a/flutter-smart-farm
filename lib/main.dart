import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_farm/services/farm_data_service.dart';
import '../pages/main_page.dart';
import 'cubit/farm_data_cubit.dart';
import 'pages/init_page.dart';
import 'utils/server_utils.dart';

late FarmDataService service;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _init();
  // String serverURL = await ServerUtils.getServerURL();
  // int port = await ServerUtils.getPort();
  // String topic = await ServerUtils.getTopic();

  // service = FarmDataService(serverURL, port, topic)..disconnect();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

void _init() async {
  String serverURL = await ServerUtils.getServerURL();
  int port = await ServerUtils.getPort();
  String topic = await ServerUtils.getTopic();

  service = FarmDataService(serverURL, port, topic);
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FarmDataCubit(service)),
      ],
      child: MaterialApp(
        title: 'SmartFarm',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Color(0xFFEEEEEE)),
          ).apply(),
        ),
        initialRoute: '/init',
        routes: {
          '/main': (context) => const MainPage(),
          '/init': (context) => const InitPage(),
        },
      ),
    );
  }
}
