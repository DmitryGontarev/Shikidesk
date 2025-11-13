import 'package:shikidesk/data/converters/AnimeEntityToDomain.dart';
import 'package:shikidesk/data/entity/calendar/CalendarEntity.dart';
import 'package:shikidesk/domain/models/calendar/CalendarModel.dart';

/// конвертация [CalendarEntity] в модель domain слоя
///
extension CalendarEntityToDomainModel on CalendarEntity? {
  CalendarModel toDomainModel() {
    return CalendarModel(
        nextEpisode: this?.nextEpisode,
        nextEpisodeDate: this?.nextEpisodeDate,
        duration: this?.duration,
        anime: this?.anime?.toDomainModel()
    );
  }
}