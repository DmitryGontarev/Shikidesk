
import 'package:shikidesk/domain/models/common/AiredStatus.dart';
import 'package:shikidesk/domain/models/myanimelist/AiringStatus.dart';

/// Конвертация [AiringStatus] в [AiredStatus]
extension AiringStatusToAiredStatus on AiringStatus? {
  AiredStatus toAiredStatus() {
    switch (this) {
      case (AiringStatus.notYetAired): return AiredStatus.anons;
      case (AiringStatus.currentlyAiring): return AiredStatus.ongoing;
      case (AiringStatus.finishedAiring): return AiredStatus.released;
      default: return AiredStatus.unknown;
    }
  }
}