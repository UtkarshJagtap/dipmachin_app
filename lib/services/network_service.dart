import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkDataService {

 final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get stream => _connectivity.onConnectivityChanged; 
}
