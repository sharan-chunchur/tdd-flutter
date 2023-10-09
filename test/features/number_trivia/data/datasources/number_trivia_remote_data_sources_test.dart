import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:untitled/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_sources_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late MockClient mockHttpClient;
  late NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;

  setUp(() {
    mockHttpClient = MockClient();
    numberTriviaRemoteDataSource =
        NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpHttpClientSuccess200(){
    when(mockHttpClient.get(any, headers: {
      'Content-Type' : 'application/json',
    }))
        .thenAnswer((realInvocation) async {
      return http.Response(fixtures("trivia.json"), 200);
    });
  }

  void setUpHttpClientFailure404(){
    when(mockHttpClient.get(any, headers: {
      'Content-Type' : 'application/json',
    }))
        .thenAnswer((realInvocation) async {
      return http.Response("something went wrong", 404);
    });
  }

  group("getConcreteNumberTrivia", () {
    
    final tNumber = 1;
    final tnumberTriviaModel = const NumberTriviaModel(number: 1, text: "Test Text");
    
    test(
        'should perform a Get req on URL with number being endpoint and with application/json header',
            () async {
          //arrange
         setUpHttpClientSuccess200();
          //act
          numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
          //assert
              verify(mockHttpClient.get(Uri.parse("http://numbersapi.com/$tNumber"), headers: {
                'Content-Type' : 'application/json',
              }));
        });
    
    test("should return NumberTrivia when response code is 200(Success)", () async{

      //arrange
      setUpHttpClientSuccess200();
      //act
      final result = await numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tnumberTriviaModel);

    });

    test("should throw server exception when response code is 404", () async{

      //arrange
      setUpHttpClientFailure404();
      //act
      final call = numberTriviaRemoteDataSource.getConcreteNumberTrivia;
      //assert
      expect(()=> call(tNumber), throwsA(const TypeMatcher<ServerException>()));

    });

  });
}
