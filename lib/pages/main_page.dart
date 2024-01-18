import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_farm/pages/settings_page.dart';
import 'package:flutter_smart_farm/widgets/sensor_status_card.dart';
import '../constant.dart';
import '../cubit/farm_data_cubit.dart';
import '../cubit/server_connection_cubit.dart';
import '../widgets/sensor_control_card.dart';
import '../widgets/server_connection_status_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  void _subscribeData() {
    context.read<FarmStatusCubit>().subscribe();
    context.read<FarmSoilHumidityCubit>().subscribe();
    context.read<FarmTemperatureCubit>().subscribe();
    context.read<FarmAirHumidityCubit>().subscribe();
    context.read<FarmSoilPHCubit>().subscribe();
    context.read<FarmSprinklerCubit>().subscribe();
    context.read<FarmLampCubit>().subscribe();
  }

  Widget banner() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        image: const DecorationImage(
          image: AssetImage("assets/farm.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(padding),
        height: 200,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.5),
            ],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Stack(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Kualitas Lahan Pertanian",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent,
                      Colors.greenAccent.withOpacity(0.5),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: BlocBuilder<FarmStatusCubit, String>(
                  builder: (context, status) {
                    return Text(
                      status,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget monitoring() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        BlocBuilder<FarmSoilHumidityCubit, int>(
          builder: (context, soilHumidity) {
            return SensorStatusCard(
              title: "Kelembaban Tanah",
              value: "$soilHumidity%",
              imageUrl: "assets/soil-moisture.png",
              backgroundColor: greenMainColor,
            );
          },
        ),
        BlocBuilder<FarmTemperatureCubit, int>(
          builder: (context, temperature) {
            return SensorStatusCard(
              title: "Suhu Udara",
              value: "$temperature°C",
              imageUrl: "assets/temperature.png",
              backgroundColor: greenMainColor,
            );
          },
        ),
        BlocBuilder<FarmAirHumidityCubit, int>(
          builder: (context, airHumidity) {
            return SensorStatusCard(
              title: "Kelembaban Udara",
              value: "$airHumidity RH",
              imageUrl: "assets/humidity.png",
              backgroundColor: greenMainColor,
            );
          },
        ),
        BlocBuilder<FarmSoilPHCubit, double>(
          builder: (context, soilPh) {
            return SensorStatusCard(
              title: "pH Tanah",
              value: "$soilPh pH",
              imageUrl: "assets/soil-ph.png",
              backgroundColor: greenMainColor,
            );
          },
        ),
      ],
    );
  }

  Widget control() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        BlocBuilder<FarmSprinklerCubit, bool>(
          builder: (context, isSprinklerEnabled) {
            return SensorControlCard(
              title: "Sprinkle Air",
              value: isSprinklerEnabled ? "ON" : "OFF",
              backgroundColor:
                  isSprinklerEnabled ? greenMainColor : Colors.redAccent,
              onTap: () {
                context.read<FarmSprinklerCubit>().publish(!isSprinklerEnabled);
              },
            );
          },
        ),
        BlocBuilder<FarmLampCubit, bool>(
          builder: (context, isLampEnabled) {
            return SensorControlCard(
              title: "Lampu",
              value: isLampEnabled ? "ON" : "OFF",
              backgroundColor:
                  isLampEnabled ? greenMainColor : Colors.redAccent,
              onTap: () {
                context.read<FarmLampCubit>().publish(!isLampEnabled);
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenMainColor,
        title: const Text("SmartFarm MQTT"),
        actions: [
          IconButton(
            tooltip: "Tentang",
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      // Set state to rebuild screen
      body: BlocConsumer<ServerConnectionCubit, bool>(
        listener: (_, isConnected) {
          if (isConnected) {
            _subscribeData();
          }
        },
        builder: (_, __) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const ServerConnectionStatusCard(),
                // const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(padding * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      banner(),
                      const SizedBox(height: 16),
                      const Text(
                        "Monitoring",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      monitoring(),
                      const SizedBox(height: 16),
                      const Text(
                        "Kontrol",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      control(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
