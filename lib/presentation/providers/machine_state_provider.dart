
import 'package:dipmachine/domain/machine_state.dart';
import 'package:dipmachine/presentation/providers/network_data_provider.dart';
import 'package:dipmachine/presentation/providers/websocket_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
class MachineStateProvider extends ChangeNotifier implements MachineState{
  @override
  MachineStates state;

  WebsocketDataProvider websocketDataProvider;
  NetworkDataProvider networkDataProvider;

  MachineStateProvider({required this.websocketDataProvider, required this.networkDataProvider})
    : state= MachineStates.values.byName('initial')
  {
    if(networkDataProvider.connected == false){
        state= MachineStates.values.byName('disconnect');
    }
    developer.log('MachineState is created');
  }

  void setNewState(String newState) {
    if (state.name != newState.toLowerCase()) {
      state = MachineStates.values.byName(newState.toLowerCase());
      developer.log('state changed to $newState');
      notifyListeners();
    }
  }


  void onSomethingChanged(NetworkDataProvider networkDataProvider,
      WebsocketDataProvider websocketDataProvider){

    this.networkDataProvider = networkDataProvider;
    this.websocketDataProvider = websocketDataProvider;

    if (this.networkDataProvider.connected == false) {
      state = MachineStates.values.byName('disconnect');
      developer.log('machine state changed by networkDataProvider');
      notifyListeners();
    } else if (this.websocketDataProvider.newData.isNotEmpty) {
      developer.log('we got ${this.websocketDataProvider.newData['state']}');
      setNewState(this.websocketDataProvider.newData['state']);
    }

  }

}
