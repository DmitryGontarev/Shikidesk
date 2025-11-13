import 'package:equatable/equatable.dart';

/// Модель со ссылками на ресурс произведения
///
/// [id] id ссылки
/// [name] название ресурса (например myanimelist, wikipedia)
/// [url] ссылка на ресурс
class LinkModel extends Equatable {
  final int? id;
  final String? name;
  final String? url;

  const LinkModel({required this.id, required this.name, required this.url});

  @override
  List<Object?> get props => [id, name, url];
}
