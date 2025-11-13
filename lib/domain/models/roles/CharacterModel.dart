
import 'package:equatable/equatable.dart';
import '../common/ImageModel.dart';

/// Модель с информацией о персонаже
///
/// [id] номер персонажа
/// [name] имя персонажа
/// [nameRu] имя персонажа на русском
/// [image] ссылки на картинки с персонажем
/// [url] ссылка на персонажа
class CharacterModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
  final String? url;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.image,
    required this.url});

  @override
  List<Object?> get props => [
    id,
    name,
    nameRu,
    image,
    url
  ];
}