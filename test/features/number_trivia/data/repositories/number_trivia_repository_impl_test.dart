

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/core/error/exceptions.dart';
import 'package:untitled/core/error/failures.dart';
import 'package:untitled/core/platform/network_info.dart';
import 'package:untitled/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:untitled/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:untitled/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:untitled/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:untitled/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{}
class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{}
class MockNetworkInfo extends Mock implements NetworkInfo{}


void main(){

  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });



  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(number: tNumber, text: 'Test Trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async{
        return true;
      });
      //act
      repositoryImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });
    
    group("when device is Online", () {

      //setup
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_)async{
          return true;
        });
      });

      test('given internet connection, when data source call is successful for concrete number then return remote data', () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        expect(result, equals(Right(tNumberTrivia)));
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberNumberTrivia(tNumberTriviaModel));
      });

      test('given internet connection, when data source call is successful then cache remote data locally', () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberNumberTrivia(tNumberTriviaModel));
      });

      test('given internet connection, when data source call is unsuccessful for concrete number then return cached data', () async{
        //arrange
        when(mockRemoteDataSource.getConcreteNumberTrivia(1)).thenThrow(ServerException('Serverside Error'));

        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        expect(result, const Left(ServerFailure(Failures)));
        verifyZeroInteractions(mockLocalDataSource);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      });

    });


    group("when device is Offline", () {

      //setup
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_)async{
          return false;
        });
      });

      test('Should return last locally cached data when the cached data is present', () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((realInvocation) async=> tNumberTriviaModel);

        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('Should return cache failure when no cached data is present', () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException('no cached data'));

        //act
        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, const Left(CacheFailure(Failures)));
      });
    });

  });

  group("getRandomNumberTrivia", () {

    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Trivia');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if device is online', () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_)async{
        return true;
      });
      //act
      repositoryImpl.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group("When device is Online", () {
      //setup
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_)async{
          return true;
        });
      });

      test('given internet connection, when data source call is successful for random number then return remote data', () async{
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        //act
        final result = await repositoryImpl.getRandomNumberTrivia();

        //assert
        expect(result, Right(tNumberTrivia));
        verify(mockRemoteDataSource.getRandomNumberTrivia());
      });

      test('given internet connection, when data source call is successful then cache remote data locally', () async{
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repositoryImpl.getRandomNumberTrivia();

        //assert
        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verify(mockLocalDataSource.cacheNumberNumberTrivia(tNumberTriviaModel));
      });

      test('given internet connection, when data source call is unsuccessful for random number then return cached data', () async{
        //arrange
        when(mockRemoteDataSource.getRandomNumberTrivia()).thenThrow(ServerException('Serverside Error'));

        //act
        final result = await repositoryImpl.getRandomNumberTrivia();

        //assert
        expect(result, const Left(ServerFailure(Failures)));
        verifyZeroInteractions(mockLocalDataSource);
        verify(mockRemoteDataSource.getRandomNumberTrivia());
      });

    });
    
    
    group("When device is Offline", () {

      //setup
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_)async{
          return false;
        });
      });

      test('Should return last locally cached data when the cached data is present', () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenAnswer((realInvocation) async=> tNumberTriviaModel);

        //act
        final result = await repositoryImpl.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Right(tNumberTrivia));
      });

      test('Should return cache failure when no cached data is present', () async{
        //arrange
        when(mockLocalDataSource.getLastNumberTrivia()).thenThrow(CacheException('no cached data'));

        //act
        final result = await repositoryImpl.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, const Left(CacheFailure(Failures)));
      });

    });

  });

}