// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import '../use_case/farm_data_use_case.dart';

class FarmDataCubit extends Cubit<bool> {
  FarmDataCubit(this.usecase) : super(false);
  final FarmDataUseCase usecase;

  void reset() => usecase.disconnect();

  Stream getStream() => usecase.getStream();
  String getRawData(dynamic data) => usecase.getRawData(data);

  dynamic getConnectionStatus() {
    // Set state to rebuild screen
    emit(!state);
    return usecase.getConnectionStatus();
  }

  Stream subscribe(String topic) => usecase.subscribe(topic);

  void publish(String topic, Map<String, dynamic> data) =>
      usecase.publish(topic, data);
}
