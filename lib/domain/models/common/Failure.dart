
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerException implements Exception {
  final int? code;
  final String? body;

  ServerException({
    required this.code,
    this.body
});

}

class ServerFailure extends Failure {
  final int? code;
  final String? body;

  ServerFailure({
    required this.code,
    this.body
});
}