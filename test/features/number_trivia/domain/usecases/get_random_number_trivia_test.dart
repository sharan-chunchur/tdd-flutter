
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:untitled/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:untitled/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:untitled/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia from repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia)
    );

    //act
    final result = await usecase(NoParams());

    //asset
    expect(result, const Right(tNumberTrivia));

    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
  });
}
