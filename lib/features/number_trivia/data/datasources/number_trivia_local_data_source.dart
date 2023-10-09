

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource{
  ///Gets the Cache [NumberTriviaModel] which was gotten the last time
  ///the user had an internet connection.
  Future<NumberTriviaModel>? getLastNumberTrivia();

  /// Throws [CacheException] if no cache data is present.
  Future<void>? cacheNumberNumberTrivia(NumberTriviaModel? triviaToCache);

}

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource{
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel>? getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString('CACHED_NUMBER_TRIVIA');
    if(jsonString !=null ){
      return Future.value(NumberTriviaModel.fromJson(jsonDecode(jsonString)));
    }else{
      throw CacheException("");
    }
  }

  @override
  Future<void>? cacheNumberNumberTrivia(NumberTriviaModel? triviaToCache) {
    return sharedPreferences.setString("CACHED_NUMBER_TRIVIA", jsonEncode(triviaToCache!.toJson()));
  }

}