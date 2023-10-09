import 'dart:convert';
import 'dart:math';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:untitled/features/number_trivia/data/models/number_trivia_model.dart';
// import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_local_data_sources_test.mocks.dart';

// @GenerateMocks([MockSharedPreference])
@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main(){
  late MockSharedPreferences mockSharedPreference;
  late NumberTriviaLocalDataSource dataSourceImpl;
  
  setUp((){
    mockSharedPreference = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreference);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(jsonDecode(fixtures('trivia_cached.json')));
    test('should return NumberTrivia from sharedPref when there is cache', () async{
      //arrange
      // when(()=>mockSharedPreference.getString(any())).thenReturn(fixtures('trivia_cached.json'));
      when(mockSharedPreference.getString(any)).thenReturn(fixtures('trivia_cached.json'));

      //act
      final result = await dataSourceImpl.getLastNumberTrivia();

      //assert
      // verify(()=>mockSharedPreference.getString('CACHED_NUMBER_TRIVIA')).called(1);
      verify(mockSharedPreference.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, isA<NumberTriviaModel>());
    });

    test('should throw cahche exception when there is not value in cache', () async{
      //arrange
      //when(()=>mockSharedPreference.getString("CACHED_NUMBER_TRIVIA")).thenReturn(null);
      when(mockSharedPreference.getString(any)).thenReturn(null);

      //act
      final call = dataSourceImpl.getLastNumberTrivia;

      //assert
      //verify(mockSharedPreference.getString('CACHED_NUMBER_TRIVIA'));
      expect(()=> call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("getCacheNumberTrivia", () {
    const tNumberTrivia = NumberTriviaModel(number: 1, text: "test");
    test("should call SharedPreference to cache data", ()async{
      //arrange
      final expectedJsonString = json.encode(tNumberTrivia.toJson());
      //when(()=>mockSharedPreference.setString("CACHED_NUMBER_TRIVIA", expectedJsonString)).thenAnswer((_) => Future.value(true));
      when(mockSharedPreference.setString(any, any)).thenAnswer((_) => Future.value(true));
      //act
      dataSourceImpl.cacheNumberNumberTrivia(tNumberTrivia);
      //assert
      //verify(()=>mockSharedPreference.setString('CACHED_NUMBER_TRIVIA', expectedJsonString)).called(1);
       verify(mockSharedPreference.setString("CACHED_NUMBER_TRIVIA", expectedJsonString));

    });

  });

}