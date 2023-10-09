

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo{
  Future<bool>? get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{

  final Connectivity connectivity;
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool>? get isConnected async {
    final status = await connectivity.checkConnectivity();
    if( status== ConnectivityResult.mobile ||  status== ConnectivityResult.wifi ||  status== ConnectivityResult.ethernet)
    return true;

    return false;
  }
}