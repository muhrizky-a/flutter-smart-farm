// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import '../use_case/farm_data_use_case.dart';

class ServerConnectionCubit extends Cubit<bool> {
  ServerConnectionCubit(this.usecase) : super(false);
  final FarmDataUseCase usecase;

  void reset() => usecase.disconnect();

  bool isConnectedToServer() {
    // Set state to rebuild screen
    if (state != usecase.isConnectedToServer()) {
      emit(usecase.isConnectedToServer());
    }

    return usecase.isConnectedToServer();
  }
}
