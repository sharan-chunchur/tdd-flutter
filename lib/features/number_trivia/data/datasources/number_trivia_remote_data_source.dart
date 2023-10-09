import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// calls the http://numberapi.com/{number} endpoint.
  ///
  /// Throws  [ServerException] for all error codes.
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int number);

  /// calls the hhtp://numberapi.com/random endpoint.
  ///
  /// Throws  [ServerException] for all error codes.
  Future<NumberTriviaModel>? getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel>? getConcreteNumberTrivia(int number) async {
   try{
     final res = await client.get(Uri.parse("http://numbersapi.com/$number"), headers: {
       'Content-Type': 'application/json',
     });
     if (res.statusCode == 200) {
       return NumberTriviaModel.fromJson(jsonDecode(res.body));
     }else{
       throw ServerException("");
     }
   }on ServerException{
     throw ServerException("");
   }catch(e){

     rethrow;
   }
  }

  @override
  Future<NumberTriviaModel>? getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
