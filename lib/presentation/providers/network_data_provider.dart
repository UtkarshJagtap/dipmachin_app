import 'dart:async';

import 'package:dipmachine/services/network_service.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;

class NetworkDataProvider extends ChangeNotifier{

  NetworkDataService networkDataService = NetworkDataService();
  StreamSubscription<List<ConnectivityResult>>? stream;
  bool? connected ;

  NetworkDataProvider(){
    developer.log('NetworkDataProvider is being created');

    listenStream();

    developer.log('NetworkData Provider created');
  }

  void listenStream() async {
    
    // List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    // if(result.contains(ConnectivityResult.wifi)){

    //   connected = true;
    
    //   developer.log('NetworkDataProvider: has created initial state as (true) connected to wifi $result');

    //   notifyListeners();

    // }else{

    //   connected = false;

    //   developer.log('NetworkDataProvider: has created initial state as (false) not connected to wifi');

    //   notifyListeners();
    // }

    stream = networkDataService.stream.listen((result) {

      developer.log('NetworkDataProvider: networkDataService stream has provided new Connectivity activity');

      developer.log('NetworkDataProvider: current ConnectivityResult $result');

      if(result.contains(ConnectivityResult.wifi)){


          connected = true;

          developer.log('NetworkDataProvider: has updated its state as (true) connected to wifi');
          
          developer.log('NetworkDataProvider: new wifi connection detected, will ask websocket to connect');

          notifyListeners();

      }else{
        //potential break point
        developer.log('NetworkDataProvider: current ConnectivityResult $result');

        connected = false;
        
        developer.log('NetworkDataProvider: updated state as (false) ');

        notifyListeners();
      }
    });

  }

  @override
  void dispose(){
    developer.log('NetworkDataProvider: dispose is called for NetworkDataProvider from framework? there will be an attempt at cancelling the StreamSubscription');
    if(stream != null){
      stream!.cancel();
      developer.log('NetworkDataProvider: stream listening for Connectivity changes is now closed');
    }
    developer.log('super.dispose will be called now : NetworkDataProvider ');
    super.dispose();
  }
}
