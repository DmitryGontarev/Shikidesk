import 'package:equatable/equatable.dart';
import 'package:shikidesk/domain/models/common/ImageModel.dart';

/// Модель с информацией о человеке, принимавшем участиве в создании аниме
///
/// [id] номер
/// [name] имя
/// [nameRu] имя на русском
/// [image] ссылки на фото
/// [url] ссылка
class PersonModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameRu;
  final ImageModel? image;
  final String? url;

  const PersonModel(
      {required this.id,
      required this.name,
      required this.nameRu,
      required this.image,
      required this.url});

  @override
  List<Object?> get props => [id, name, nameRu, image, url];
}
