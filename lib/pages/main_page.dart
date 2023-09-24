import 'package:flutter/material.dart';
import 'package:flutter_smart_farm/widgets/sensor_status_card.dart';

import '../constant.dart';
import '../widgets/sensor_control_card.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

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
                child: const Text(
                  "BAIK",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
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
      children: const [
        SensorStatusCard(
          title: "Kelembaban Tanah",
          value: "550",
          imageUrl: "assets/soil-moisture.png",
          backgroundColor: greenMainColor,
        ),
        SensorStatusCard(
          title: "Suhu Udara",
          value: "27°C",
          imageUrl: "assets/temperature.png",
          backgroundColor: greenMainColor,
        ),
        SensorStatusCard(
          title: "Kelembaban Udara",
          value: "65 RH",
          imageUrl: "assets/humidity.png",
          backgroundColor: greenMainColor,
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
        SensorControlCard(
          title: "Sprinkle Air",
          value: "OFF",
          backgroundColor: Colors.redAccent,
          onTap: () {
            debugPrint("test");
          },
        ),
        SensorControlCard(
          title: "Lampu",
          value: "ON",
          backgroundColor: greenMainColor,
          onTap: () {},
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
            icon: const Icon(Icons.info),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(padding * 2),
        child: SingleChildScrollView(
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
      ),
    );
  }
}
