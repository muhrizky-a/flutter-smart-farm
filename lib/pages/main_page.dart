import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smart_farm/pages/settings_page.dart';
import 'package:flutter_smart_farm/widgets/sensor_status_card.dart';
import '../constant.dart';
import '../cubit/farm_data_cubit.dart';
import '../models/farm_data.dart';
import '../widgets/sensor_control_card.dart';
import '../widgets/server_connection_status_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FarmData? farmData;

  @override
  void initState() {
    super.initState();
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
                child: StreamBuilder(
                  stream: context.read<FarmDataCubit>().getClient().updates,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      farmData = context
                          .read<FarmDataCubit>()
                          .getFarmDataFromStream(snapshot.data!);
                    }

                    return Text(
                      farmData?.status ?? "-",
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
          StreamBuilder(
            stream: context.read<FarmDataCubit>().getClient().updates,
            builder: (context, snapshot) {
              return SensorStatusCard(
                title: "Kelembaban Tanah",
                value: farmData?.soilHumidity.toString() ?? "-",
                imageUrl: "assets/soil-moisture.png",
                backgroundColor: greenMainColor,
              );
            },
          ),
          StreamBuilder(
            stream: context.read<FarmDataCubit>().getClient().updates,
            builder: (context, snapshot) {
              return SensorStatusCard(
                title: "Suhu Udara",
                value: farmData != null ? "${farmData?.temperature}°C" : "-",
                imageUrl: "assets/temperature.png",
                backgroundColor: greenMainColor,
              );
            },
          ),
          StreamBuilder(
            stream: context.read<FarmDataCubit>().getClient().updates,
            builder: (context, snapshot) {
              return SensorStatusCard(
                title: "Kelembaban Udara",
                value: farmData != null ? "${farmData?.airHumidity} RH" : "-",
                imageUrl: "assets/humidity.png",
                backgroundColor: greenMainColor,
              );
            },
          ),
        ]);
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
        StreamBuilder(
          stream: context.read<FarmDataCubit>().getClient().updates,
          builder: (context, snapshot) {
            bool isSprinklerEnabled() {
              if (farmData != null) {
                if (farmData!.sprinklerEnabled) return true;
              }
              return false;
            }

            return SensorControlCard(
              title: "Sprinkle Air",
              value: isSprinklerEnabled() ? "ON" : "OFF",
              backgroundColor:
                  isSprinklerEnabled() ? greenMainColor : Colors.redAccent,
              onTap: () {
                FarmData? farmData =
                    context.read<FarmDataCubit>().getFarmData();
                if (farmData != null) {
                  FarmData newFarmData = FarmData.fromJson({
                    "status": farmData.status,
                    "soilHumidity": farmData.soilHumidity,
                    "temperature": farmData.temperature,
                    "airHumidity": farmData.airHumidity,
                    "sprinklerEnabled": !farmData.sprinklerEnabled,
                    "lampEnabled": farmData.lampEnabled,
                  });

                  context.read<FarmDataCubit>().publish(newFarmData);
                }
              },
            );
          },
        ),
        StreamBuilder(
          stream: context.read<FarmDataCubit>().getClient().updates,
          builder: (context, snapshot) {
            bool isLampEnabled() {
              if (farmData != null) {
                if (farmData!.lampEnabled) return true;
              }
              return false;
            }

            return SensorControlCard(
              title: "Lampu",
              value: isLampEnabled() ? "ON" : "OFF",
              backgroundColor:
                  isLampEnabled() ? greenMainColor : Colors.redAccent,
              onTap: () {
                FarmData? farmData =
                    context.read<FarmDataCubit>().getFarmData();
                if (farmData != null) {
                  FarmData newFarmData = FarmData.fromJson({
                    "status": farmData.status,
                    "soilHumidity": farmData.soilHumidity,
                    "temperature": farmData.temperature,
                    "airHumidity": farmData.airHumidity,
                    "sprinklerEnabled": farmData.sprinklerEnabled,
                    "lampEnabled": !farmData.lampEnabled,
                  });

                  context.read<FarmDataCubit>().publish(newFarmData);
                }
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<FarmDataCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenMainColor,
        title: const Text("Smart Farm"),
        actions: [
          IconButton(
            tooltip: "Tentang",
            icon: const Icon(Icons.settings),
            // icon: const Icon(Icons.info),
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
      body: SingleChildScrollView(
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
      ),
    );
  }
}
