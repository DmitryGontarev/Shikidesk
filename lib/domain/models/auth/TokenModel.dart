
import 'package:equatable/equatable.dart';

/// Модель токена domain слоя
///
/// [accessToken] ключ доступа для взаимодействия с сервером
/// [refreshToken] ключ для обновления доступа
class TokenModel extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const TokenModel({required this.accessToken, required this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
