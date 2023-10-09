// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../models/farm_data.dart';
import '../services/farm_data_service.dart';

class FarmDataCubit extends Cubit<Stream<dynamic>> {
  FarmDataCubit(this._service) : super(const Stream.empty());

  final FarmDataService _service;
  FarmData? farmData;

  MqttServerClient getClient() => _service.client;

  void resetService() => _service.client.disconnect();

  MqttConnectionState getConnectionStatus() {
    return _service.getConnectionStatus();
  }

  FarmData? getFarmDataFromStream(
      List<MqttReceivedMessage<MqttMessage?>>? data) {
    try {
      FarmData? farmData = _service.getFarmDataFromStream(data);
      this.farmData = farmData;

      return farmData;
    } catch (e) {
      return null;
    }
  }

  FarmData? getFarmData() => farmData;

  void publish(FarmData farmData) => _service.publish(farmData);
}

// abstract class CubitState {}

// class CubitInitial extends CubitState {}

// class CubitLoading extends CubitState {}

// class CubitSuccess extends CubitState {
//   final FarmData data;
//   CubitSuccess(this.data);
// }

// class CubitFailed extends CubitState {
//   final String error;
//   CubitFailed(this.error);
// }
