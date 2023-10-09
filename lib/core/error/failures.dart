

import 'package:equatable/equatable.dart';

class Failures extends Equatable{
  final List properties = const <dynamic>[];

  const Failures(properties) ;

  @override
  List<Object?> get props => [properties];

}


//General Failure
class ServerFailure extends Failures{
  const ServerFailure(super.properties);
}

class CacheFailure extends Failures{
  const CacheFailure(super.properties);
}