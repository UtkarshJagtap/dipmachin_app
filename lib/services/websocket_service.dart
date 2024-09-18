
import 'dart:developer' as developer;
import 'package:web_socket_channel/web_socket_channel.dart';
//import 'package:web_socket_channel/status.dart'as status;

class WebsocketService {
  bool established = false;
  WebSocketChannel? channel;
  int attempts = 0;

  Future<void>  start() async {
    try {
     //channel = WebSocketChannel.connect(Uri.parse('ws://DipMachine.local/ws'));
    channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.2:8000/ws'));
      await channel!.ready.then((_){
        developer.log('WebSocketService: connected to socket');
        established = true;
        attempts =0;
      });
    } on WebSocketChannelException catch (e) {
      established = false;
      developer.log('WebSocketService: WebsocketService service has thrown $e');
      rethrow;
    }

  }

  Future<void> retry() async {
    WebSocketChannelException ex = WebSocketChannelException();
    while(attempts<5 && established != true){
      developer.log('WebsocketService: we are attempting to reconnect attempt no: $attempts');
      await Future.delayed(const Duration(seconds: 3));
      await start().onError((e, s){
        if(e is WebSocketChannelException) {
          attempts++;
          ex = e;
        }
      }, test: (e){ return e != null;});
    }
    if(established == false) throw ex;
    developer.log("established is $established now we are outside ");

  }

  Stream get stream {
    
    if (established == true && channel != null) {
      return channel!.stream;
    } else {
      throw WebSocketChannelException('WebsocketService: WebSocketChannel is not established');
    }
   }


  void putMessage(dynamic message) {
    try {
      if (established == true && channel != null) {
        channel!.sink.add(message);
      } else {
        throw WebSocketChannelException(
            'WebSocketChannel is not established, probably you are not on the same network');
      }
    } on WebSocketChannelException catch (e) {
      developer.log('$e');
    }
  }

  void closeSocket(){
    developer.log('WebSocketService: attempting to close socket');
    if (channel != null) {
      channel!.sink.close();
      developer.log('WebSocketService: channel closed');
      channel = null;
      attempts = 0;
    } else if (channel == null){
      developer.log('WebSocketService: there was nothing to close that is channel was null');
    }
  }
 
  

}
