

import 'package:dartz/dartz.dart';
import 'package:untitled/core/error/failures.dart';
import 'package:untitled/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository{
  Future<Either<Failures, NumberTrivia?>>? getConcreteNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia?>>? getRandomNumberTrivia();
}

