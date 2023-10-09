// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_trivia_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NumberTriviaModel _$NumberTriviaModelFromJson(Map<String, dynamic> json) =>
    NumberTriviaModel(
      number: (json['number'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$NumberTriviaModelToJson(NumberTriviaModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'text': instance.text,
    };
