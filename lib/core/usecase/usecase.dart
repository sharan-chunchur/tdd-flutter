

import 'package:dartz/dartz.dart';
import 'package:untitled/core/error/failures.dart';

abstract class UseCase<Type, Params>{
  Future<Either<Failures, Type?>>? call(Params params);
}