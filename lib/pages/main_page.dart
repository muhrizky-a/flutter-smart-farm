import 'dart:convert';

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
  late FarmData farmData;

  @override
  void initState() {
    super.initState();
    farmData = FarmData();
  }

  Map<String, dynamic> getStreamedData(dynamic data) {
    String rawData = context.read<FarmDataCubit>().getRawData(data);
    return jsonDecode(rawData);
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
                  stream: context.read<FarmDataCubit>().subscribe("farmStatus"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      try {
                        String rawData = context
                            .read<FarmDataCubit>()
                            .getRawData(snapshot.data!);

                        Map<String, dynamic> data = jsonDecode(rawData);
                        farmData.status = data["farmStatus"];
                      } catch (e) {
                        debugPrint(e.toString());
                      }
                    }

                    return Text(
                      farmData.status,
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
            stream: context.read<FarmDataCubit>().subscribe("soilHumidity"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  Map<String, dynamic> data = getStreamedData(snapshot.data!);
                  farmData.soilHumidity = data["soilHumidity"];
                } catch (e) {
                  debugPrint(e.toString());
                }
              }

              return SensorStatusCard(
                title: "Kelembaban Tanah",
                value: farmData.soilHumidity.toString(),
                imageUrl: "assets/soil-moisture.png",
                backgroundColor: greenMainColor,
              );
            },
          ),
          StreamBuilder(
            stream: context.read<FarmDataCubit>().subscribe("airTemperature"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  Map<String, dynamic> data = getStreamedData(snapshot.data!);
                  farmData.temperature = data["airTemperature"];
                } catch (e) {
                  debugPrint(e.toString());
                }
              }

              return SensorStatusCard(
                title: "Suhu Udara",
                value: "${farmData.temperature}°C",
                imageUrl: "assets/temperature.png",
                backgroundColor: greenMainColor,
              );
            },
          ),
          StreamBuilder(
            stream: context.read<FarmDataCubit>().subscribe("airHumidity"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  Map<String, dynamic> data = getStreamedData(snapshot.data!);
                  farmData.airHumidity = data["airHumidity"];
                } catch (e) {
                  debugPrint(e.toString());
                }
              }

              return SensorStatusCard(
                title: "Kelembaban Udara",
                value: "${farmData.airHumidity} RH",
                imageUrl: "assets/humidity.png",
                backgroundColor: greenMainColor,
              );
            },
          ),
          StreamBuilder(
            stream: context.read<FarmDataCubit>().subscribe("soilPh"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                try {
                  Map<String, dynamic> data = getStreamedData(snapshot.data!);
                  farmData.soilPh = data["soilPh"];
                } catch (e) {
                  debugPrint(e.toString());
                }
              }

              return SensorStatusCard(
                title: "pH Tanah",
                value: "${farmData.soilPh} pH",
                imageUrl: "assets/soil-ph.png",
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
          stream: context.read<FarmDataCubit>().subscribe("sprinklerEnabled"),
          builder: (context, snapshot) {
            String topic = "sprinklerEnabled";
            if (snapshot.hasData) {
              try {
                Map<String, dynamic> data = getStreamedData(snapshot.data!);
                farmData.sprinklerEnabled = data[topic];
              } catch (e) {
                debugPrint(e.toString());
              }
            }

            bool isSprinklerEnabled() {
              if (farmData.sprinklerEnabled) return true;
              return false;
            }

            return SensorControlCard(
              title: "Sprinkle Air",
              value: isSprinklerEnabled() ? "ON" : "OFF",
              backgroundColor:
                  isSprinklerEnabled() ? greenMainColor : Colors.redAccent,
              onTap: () {
                context.read<FarmDataCubit>().publish(
                      topic,
                      farmData.toJson(
                        key: topic,
                        value: !farmData.sprinklerEnabled,
                      ),
                    );
              },
            );
          },
        ),
        StreamBuilder(
          stream: context.read<FarmDataCubit>().subscribe("lampEnabled"),
          builder: (context, snapshot) {
            String topic = "lampEnabled";

            if (snapshot.hasData) {
              try {
                Map<String, dynamic> data = getStreamedData(snapshot.data!);
                farmData.lampEnabled = data[topic];
              } catch (e) {
                debugPrint(e.toString());
              }
            }

            bool isLampEnabled() {
              if (farmData.lampEnabled) return true;

              return false;
            }

            return SensorControlCard(
              title: "Lampu",
              value: isLampEnabled() ? "ON" : "OFF",
              backgroundColor:
                  isLampEnabled() ? greenMainColor : Colors.redAccent,
              onTap: () {
                context.read<FarmDataCubit>().publish(
                      topic,
                      farmData.toJson(
                        key: topic,
                        value: !farmData.lampEnabled,
                      ),
                    );
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
        title: const Text("Smart Farm"),
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
      body: BlocBuilder<FarmDataCubit, bool>(builder: (_, stream) {
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
      }),
    );
  }
}
