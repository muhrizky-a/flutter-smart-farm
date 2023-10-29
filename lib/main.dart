import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/main_page.dart';
import 'cubit/farm_data_cubit.dart';
import 'pages/init_page.dart';
import 'services/base/streamable_event_service.dart';
import 'services/mqtt_service.dart';
import 'use_case/farm_data_use_case.dart';
import 'utils/server_utils.dart';

Future<void> _init() async {
  String serverURL = await ServerUtils.getServerURL();
  int port = await ServerUtils.getPort();

  service = MQTTService(serverURL, port);
  useCase = FarmDataUseCase(service);
}

late StreamableEventService service;
late FarmDataUseCase useCase;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.initService = false});
  final bool initService;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (widget.initService) {
      _init();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FarmDataCubit(useCase)),
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
