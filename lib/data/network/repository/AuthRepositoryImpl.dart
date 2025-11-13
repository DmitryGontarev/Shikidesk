import 'package:dartz/dartz.dart';
import 'package:shikidesk/data/converters/UserEntityToDomain.dart';
import 'package:shikidesk/data/network/api/AuthApi.dart';
import 'package:shikidesk/domain/models/auth/TokenModel.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/repository/AuthRepository.dart';

////////////////////////////////////////////////////////////////////////////////
/// Реализация репозитория [AuthRepository]
/// [api] для авторизации или обновления токена
////////////////////////////////////////////////////////////////////////////////
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  const AuthRepositoryImpl({required this.api});

  static const String authCodeKey = "authorization_code";
  static const String refreshTokenKey = "refresh_token";

  @override
  Future<Either<Failure, TokenModel>> signIn({required String authCode}) async {
    try {
      final response =
          await api.getAccessToken(grantType: authCodeKey, code: authCode);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, body: e.body));
    }
  }

  @override
  Future<Either<Failure, TokenModel>> refreshToken(
      {required String refreshToken}) async {
    try {
      final response = await api.getAccessToken(
          grantType: refreshTokenKey, refreshToken: refreshToken);
      return Right(response.toDomainModel());
    } on ServerException catch (e) {
      return Left(ServerFailure(code: e.code, body: e.body));
    }
  }
}
