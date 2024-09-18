import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dipmachine/services/websocket_service.dart';
import 'package:dipmachine/presentation/providers/network_data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebsocketDataProvider extends ChangeNotifier{

  WebsocketService websocketService = WebsocketService();
  Map<String, dynamic> newData = {};

  NetworkDataProvider networkDataProvider;

  WebsocketDataProvider({required this.networkDataProvider}) {
   if(networkDataProvider.connected == true && websocketService.channel == null){

     try{
     websocketService.start().then((_){
       listenToWebScocket();
     });
     } 
     on WebSocketChannelException catch (e){
       developer.log('WebsocketDataProvider: unable to establish the channel from the constructor now we will make ${websocketService.attempts} attempts to reconnect $e');
       if(websocketService.attempts<5){
         websocketService.retry().then((_){
          listenToWebScocket();
         }); 
       }
       else{
         var dis = '''{"state":"disconnect"}''';
         newData = jsonDecode(dis);
         notifyListeners();
       }
     }

   } 
  }
  
  
  void onNewNetworkState(NetworkDataProvider networkDataProvider) {
    developer.log('WebsocketDataProvider: onNewNetworkState called');
    if (networkDataProvider.connected == false) {
      developer.log('WebsocketDataProvider: network state changed to false attempting to close channel');
      websocketService.closeSocket();
    }

    if (networkDataProvider.connected == true &&
        websocketService.channel == null) {
      developer.log(
          'WebsocketDataProvider:new network state,making an attempt at creating websocketchannel and a stream will be created');
      websocketService.start().then((_) {
        listenToWebScocket();
      }).onError((e, s) {
        if (e is WebSocketChannelException) {
          developer.log('$e');
          developer.log(
              'WebsocketDataProvider: unable to establish the channel from the onNewNetworkState method, now we will make 5 attempts to reconnect $e');
          if (websocketService.attempts < 5) {
            websocketService.retry().then((_) {
              developer.log(
                  'WebSocketDataProvider: now we will listen to the socket stream');
              listenToWebScocket();
            }).onError((e, s) {
              developer.log(
                  'WebsocketDataProvider: ran out of number of possible attempts now putting machine to disconnect state');
              var dis = '''{"state":"disconnect"}''';
              newData = jsonDecode(dis);
              notifyListeners();
            });
          }
        }
      });
    }
  }
  
  void listenToWebScocket() {
    if (websocketService.channel != null &&
        networkDataProvider.connected == true) {
      try {
        websocketService.stream.listen((message) {
          newData = jsonDecode(message);
          developer.log('WebsocketDataProvider: we have got $newData');
          developer.log('notifying listeners');
          notifyListeners();
        }).onDone(() {
          websocketService.established = false;
          developer.log('WebSocketDataProvider: while listening, stream was closed by server, changing state to disconnect');
          var dis = '''{"state":"disconnect"}''';
          newData = jsonDecode(dis);
          notifyListeners();
        });
      } on WebSocketChannelException catch (e) {
        developer.log('WebSocketDataProvider: Exception while listening: $e');
      }
    }
  }  

  void sendDataToWebscocket(dynamic data){
    developer.log('WebSocketDataProvider: sending $data');
    websocketService.putMessage(data);
  }

 @override
  void dispose() {
    developer.log('WebsocketDataProvider was disposed by framework? asking channel to be closed');
    websocketService.closeSocket();
    developer.log('super.dispose will be now called');
    //TODO:just like this try to cancel stream subscription of the channel
    super.dispose();
  } 

}
