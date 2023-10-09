
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/core/error/failures.dart';
import 'package:untitled/core/usecase/usecase.dart';
import 'package:untitled/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams>{
  final NumberTriviaRepository repository;
  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failures, NumberTrivia?>>? call(params) async{
    return await repository.getRandomNumberTrivia()!;
  }

}

class NoParams extends Equatable{
  @override
  List<Object?> get props => [];
}