
import 'package:equatable/equatable.dart';

/// Модель с информацией о студии аниме
///
/// [id] номер студии
/// [name] название
/// [nameFiltered]
/// [isReal]
/// [imageUrl] ссылка на логотип студии
class StudioModel extends Equatable {
  final int? id;
  final String? name;
  final String? nameFiltered;
  final bool? isReal;
  final String? imageUrl;

  const StudioModel(
      {required this.id,
      required this.name,
      required this.nameFiltered,
      required this.isReal,
      required this.imageUrl});

  @override
  List<Object?> get props => [id, name, nameFiltered, isReal, imageUrl];
}
