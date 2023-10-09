import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/core/error/failures.dart';
import 'package:untitled/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:untitled/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:untitled/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/platform/network_info.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';


class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failures, NumberTrivia?>>? getConcreteNumberTrivia(int number) async{
    return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failures, NumberTrivia?>>? getRandomNumberTrivia() async{
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failures, NumberTrivia?>> _getTrivia(Future<NumberTriviaModel>? Function() getConcreteOrRemote) async{
    if(await networkInfo.isConnected??false){
      try{
        final remoteTrivia = await getConcreteOrRemote();
        localDataSource.cacheNumberNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException{
        return const Left(ServerFailure(Failures));
      }
    }else{
      try{
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      }on CacheException{
        return const Left(CacheFailure(Failures));
      }
    }
  }
}
