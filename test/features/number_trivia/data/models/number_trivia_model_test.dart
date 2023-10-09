import 'dart:convert';
import 'dart:math';


import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:untitled/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:untitled/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:untitled/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}


void main() {

  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be subclass of NumberTrivia', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  
  group('fromJson', () {
    test('Should work for integer', () {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixtures('trivia.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
    test('Should work for double', () {
      //arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixtures('trivia_double.json'));

      //act
      final result = NumberTriviaModel.fromJson(jsonMap);

      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should work for integer', () {

      //act
      final result = tNumberTriviaModel.toJson();

      //assert
      expect(result, {  "text": "Test Text",
        "number": 1});
    });
    test('Should work for double', () {

      //act
      final result = tNumberTriviaModel.toJson();

      //assert
      expect(result, {  "text": "Test Text",
        "number": 1});
    });
  });


}
