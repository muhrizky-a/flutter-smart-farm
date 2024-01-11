import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../constant.dart';
import '../cubit/farm_data_cubit.dart';

class ServerConnectionStatusCard extends StatefulWidget {
  const ServerConnectionStatusCard({super.key});

  @override
  State<ServerConnectionStatusCard> createState() =>
      _ServerConnectionStatusCardState();
}

class _ServerConnectionStatusCardState
    extends State<ServerConnectionStatusCard> {
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    isConnected = context.read<FarmDataCubit>().isConnectedToServer();

    return Container(
      width: double.infinity,
      color: isConnected ? greenMainColor : Colors.redAccent,
      padding: const EdgeInsets.symmetric(
        horizontal: padding * 2,
        vertical: 0,
      ),
      child: Row(
        children: [
          const Text(
            "MQTT Status:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(isConnected ? "Connected" : "Disconnected"),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isConnected =
                    context.read<FarmDataCubit>().isConnectedToServer();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: whiteMainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius * 2),
                side: const BorderSide(
                  width: 1,
                  color: greenMainColor,
                ),
              ),
              padding: const EdgeInsets.all(padding / 2),
            ),
            child: const Text(
              "Refresh",
              style: TextStyle(color: greenMainColor),
            ),
          ),
        ],
      ),
    );
  }
}
