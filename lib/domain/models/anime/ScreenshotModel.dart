import 'package:equatable/equatable.dart';

/// Модель с ссылками на скриншоты из аниме
///
/// [original] оригинальный размер
/// [preview] размер для превью
class ScreenshotModel extends Equatable {
  final String? original;
  final String? preview;

  const ScreenshotModel({required this.original, required this.preview});

  @override
  List<Object?> get props => [original, preview];
}
