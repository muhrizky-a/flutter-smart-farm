import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/server_connection_cubit.dart';
import '../main.dart';

class RestartUtils {
  static void restart(BuildContext context) {
    // Remove any route in the stack
    Navigator.of(context).popUntil((route) => false);

    context.read<ServerConnectionCubit>().reset();

// Add the first route. Note MyApp() would be your first widget to the app.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp(initService: true)),
    );
  }
}
