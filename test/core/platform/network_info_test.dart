

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/core/platform/network_info.dart';
import 'network_info_test.mocks.dart';

class MockConnectivity extends Mock implements Connectivity{}

@GenerateMocks([MockConnectivity])
void main(){
  late NetworkInfo netWorkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() async {
    mockConnectivity = MockMockConnectivity();
    netWorkInfo = NetworkInfoImpl(mockConnectivity);
  });
  
  group('is Connected', () {
    test('Should forward the call to Connectivity', ()async{
      //arrange
      when(mockConnectivity.checkConnectivity()).thenAnswer((_) => Future.value(ConnectivityResult.mobile));

      //act
      final result = await netWorkInfo.isConnected;

      //assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, true);
    });
  });
}