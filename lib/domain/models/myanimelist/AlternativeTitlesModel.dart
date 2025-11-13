
import 'package:equatable/equatable.dart';

/// Сущность с альтернативными названиями
///
/// [synonyms] список синонимов
/// [en] название на английском
/// [ja] название на японском
class AlternativeTitlesModel extends Equatable {
  final List<String>? synonyms;
  final String? en;
  final String? ja;

  const AlternativeTitlesModel(
      {required this.synonyms, required this.en, required this.ja});

  @override
  List<Object?> get props => [
    synonyms,
    en,
    ja
  ];
}