// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../use_case/farm_data_use_case.dart';

void subscribeData(
  FarmDataUseCase usecase,
  String topic,
  void Function(Map<String, dynamic>) onSuccessSubscribe,
) {
  usecase.subscribe(
    topic,
    (receivedData) {
      try {
        Map<String, dynamic> decodedData = receivedData is Map<String, dynamic>
            ? receivedData
            : jsonDecode(receivedData);

        if (decodedData.containsKey(topic)) {
          onSuccessSubscribe(decodedData);
        }
      } catch (e) {
        debugPrint("Cubit Error: ${e.toString()}");
      }
    },
  );
}

class FarmStatusCubit extends Cubit<String> {
  FarmStatusCubit(this.usecase) : super("");
  final FarmDataUseCase usecase;
  final String topic = "farmStatus";

  void subscribe() {
    subscribeData(usecase, topic, (data) {
      emit(data[topic]);
    });
  }
}

class FarmSoilHumidityCubit extends Cubit<int> {
  FarmSoilHumidityCubit(this.usecase) : super(0);
  final FarmDataUseCase usecase;
  final String topic = "soilHumidity";

  void subscribe() {
    subscribeData(usecase, topic, (data) {
      emit(data[topic]);
    });
  }
}

class FarmTemperatureCubit extends Cubit<int> {
  FarmTemperatureCubit(this.usecase) : super(0);
  final FarmDataUseCase usecase;
  final String topic = "airTemperature";

  void subscribe() {
    subscribeData(usecase, topic, (data) {
      emit(data[topic]);
    });
  }
}

class FarmAirHumidityCubit extends Cubit<int> {
  FarmAirHumidityCubit(this.usecase) : super(0);
  final FarmDataUseCase usecase;
  final String topic = "airHumidity";

  void subscribe() {
    subscribeData(usecase, topic, (data) {
      emit(data[topic]);
    });
  }
}

class FarmSoilPHCubit extends Cubit<double> {
  FarmSoilPHCubit(this.usecase) : super(0.0);
  final FarmDataUseCase usecase;
  final String topic = "soilPh";

  void subscribe() {
    subscribeData(usecase, topic, (data) {
      emit(data[topic]);
    });
  }
}

class FarmSprinklerCubit extends Cubit<bool> {
  FarmSprinklerCubit(this.usecase) : super(false);
  final FarmDataUseCase usecase;
  final String topic = "sprinklerEnabled";

  void subscribe() {
    subscribeData(usecase, topic, (data) {
      emit(data[topic]);
    });
  }

  void publish(bool value) => usecase.publish(topic, {topic: value});
}

class FarmLampCubit extends Cubit<bool> {
  FarmLampCubit(this.usecase) : super(false);
  final FarmDataUseCase usecase;
  final String topic = "lampEnabled";

  void subscribe() {
    subscribeData(usecase, topic, (data) {
      emit(data[topic]);
    });
  }

  void publish(bool value) => usecase.publish(topic, {topic: value});
}
