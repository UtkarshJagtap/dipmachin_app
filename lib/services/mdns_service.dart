// this code doesn't work on android
import 'package:multicast_dns/multicast_dns.dart';
import 'dart:developer' as developer;

class MdnsService {

  final String hostname = 'dipmachine._http._tcp.local';
  String result = '';


  Future<void> getIPv4() async {

    try{

  //  final MDnsClient client = MDnsClient(rawDatagramSocketFactory:
  //        (dynamic host, int port,{bool? reuseAddress, bool? reusePort, int? ttl}) {
  //           return RawDatagramSocket.bind(host, port, reuseAddress: true, reusePort: false, ttl: ttl!);
  //        });

    var client = MDnsClient();
    await client.start();

    client.lookup<IPAddressResourceRecord>(ResourceRecordQuery.addressIPv4(hostname))
        .listen(
          (record){
           result = record.address.address;
           developer.log('we got the ip: $result');
          }
        ).onDone((){
          developer.log('stream closed');
        });

    await Future.delayed( const Duration(seconds: 7));
    client.stop();
    developer.log('stopped');


    } catch(e){
      developer.log('$e');
    }
  }

}
