
import 'package:json_annotation/json_annotation.dart';
import 'package:untitled/features/number_trivia/domain/entities/number_trivia.dart';


part 'number_trivia_model.g.dart';

@JsonSerializable()
class NumberTriviaModel extends NumberTrivia{
  const NumberTriviaModel({required int number, required String text}) : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic>? map) => _$NumberTriviaModelFromJson(map!);

  Map<String, dynamic> toJson() => _$NumberTriviaModelToJson(this);
}