import 'dart:developer' as developer;
import 'package:flutter_nsd/flutter_nsd.dart';

class AltMdnsService {

  String ipv4 = '';
  int port = 8000; 

  final client = FlutterNsd();

 AltMdnsService(){
  client.stream.listen ((service) async {
    developer.log('AltMdnsService: we got something service name: ${service.name}, host: ${service.hostname}, port: ${service.port}');
      if(service.name == 'dipmachine'){
        developer.log('AltMdnsService: dipmachine was found');
        ipv4 = service.hostname!;
        port = service.port!;
        //await client.stopDiscovery();
      }

    }).onError((error) async {
      if(error is NsdError){
        if(error.errorCode == NsdErrorCode.startDiscoveryFailed){
           await client.stopDiscovery();
          developer.log('AltMdnsService: startDiscoveryFailed, now discoveryStopped');
        }
        else if(error.errorCode == NsdErrorCode.discoveryStopped){
          developer.log('AltMdnsService: discoveryStopped');
        }
      }
    });
  }

  Future<void> findDipMachineService() async {
    ipv4 ='';
    await client.discoverServices('_http._tcp.');
  }
}
