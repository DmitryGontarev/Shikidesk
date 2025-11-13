import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/interactors/CharacterInteractor.dart';
import 'package:shikidesk/domain/interactors/PeopleInteractor.dart';
import 'package:shikidesk/domain/models/manga/MangaType.dart';
import 'package:shikidesk/presentation/ScreenEnums.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';

import '../../domain/models/anime/AnimeModel.dart';
import '../../domain/models/manga/MangaModel.dart';
import '../../domain/models/roles/CharacterDetailsModel.dart';
import '../../domain/models/roles/CharacterModel.dart';
import '../../domain/models/roles/PersonDetailsModel.dart';

////////////////////////////////////////////////////////////////////////////////
///
/// СОБЫТИЯ
///
////////////////////////////////////////////////////////////////////////////////
abstract class CharacterPeopleScreenEvent {
  const CharacterPeopleScreenEvent();
}

/// Событие старта загрузки
class LoadCharacterPeopleData extends CharacterPeopleScreenEvent {
  final CharacterPeopleScreenType screenType;
  final int? id;

  const LoadCharacterPeopleData({required this.screenType, required this.id});
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class CharacterPeopleScreenState {
  const CharacterPeopleScreenState();
}

/// Загрузка данных о Персонаже или Человеке
class CharacterPeopleScreenLoading extends CharacterPeopleScreenState {
  const CharacterPeopleScreenLoading();
}

/// Данные о Персонаже загружены
class CharacterDataLoaded extends CharacterPeopleScreenState {
  final CharacterDetailsModel characterDetails;

  const CharacterDataLoaded({required this.characterDetails});
}

/// Данные о Человеке загружены
class PeopleDataLoaded extends CharacterPeopleScreenState {
  PersonDetailsModel personDetails;
  List<CharacterModel> seyuBestRoles;
  List<AnimeModel> bestWorksAnime;
  List<MangaModel> bestWorksManga;
  List<MangaModel> bestWorksRanobe;

  PeopleDataLoaded(
      {required this.personDetails,
      required this.seyuBestRoles,
      required this.bestWorksAnime,
      required this.bestWorksManga,
      required this.bestWorksRanobe});
}

/// Ошибка загрузки данных
class CharacterPeopleError extends CharacterPeopleScreenState {}

////////////////////////////////////////////////////////////////////////////////
///
/// БЛоК
///
////////////////////////////////////////////////////////////////////////////////
class CharacterPeopleScreenBloc
    extends Bloc<CharacterPeopleScreenEvent, CharacterPeopleScreenState> {
  CharacterPeopleScreenType screenType;
  final CharacterInteractor characterInteractor;
  final PeopleInteractor peopleInteractor;

  CharacterDetailsModel? _characterDetails;

  PersonDetailsModel? _personDetails;
  final List<CharacterModel> _seyuBestRoles = [];
  final List<AnimeModel> _bestWorksAnime = [];
  final List<MangaModel> _bestWorksManga = [];
  final List<MangaModel> _bestWorksRanobe = [];

  CharacterPeopleScreenBloc(
      {this.screenType = CharacterPeopleScreenType.character,
      required this.characterInteractor,
      required this.peopleInteractor})
      : super(const CharacterPeopleScreenLoading()) {
    on<LoadCharacterPeopleData>((event, emit) async {
      emit(const CharacterPeopleScreenLoading());

      screenType = event.screenType;

      if (screenType == CharacterPeopleScreenType.character) {
        await _loadCharacterData(event.id, (state) {
          emit(state);
        });
      } else {
        await _loadPeopleData(event.id, (state) {
          emit(state);
        });
      }
    });
  }

  /// Загрузка информации о Персонаже
  Future<void> _loadCharacterData(
      int? id, Function(CharacterPeopleScreenState state) state) async {
    await id?.let((it) async {
      try {
        final characterDetails =
            await characterInteractor.getCharacterDetails(it);
        characterDetails.fold((failure) {
          state(CharacterPeopleError());
        }, (details) {
          _characterDetails = details;
          if (_characterDetails != null) {
            state(CharacterDataLoaded(characterDetails: _characterDetails!));
          } else {
            state(CharacterPeopleError());
          }
        });
      } catch (e) {
        state(CharacterPeopleError());
      }
    });
  }

  /// Загрузка информации о Человеке
  Future<void> _loadPeopleData(
      int? id, Function(CharacterPeopleScreenState state) state) async {
    await id?.let((it) async {
      try {
        final personDetails = await peopleInteractor.getPersonDetails(it);
        personDetails.fold((failure) {
          state(CharacterPeopleError());
        }, (details) {
          _personDetails = details;

          for (var role in details.roles.orEmptyList()) {
            for (var character in role.characters.orEmptyList()) {
              _seyuBestRoles.add(character);
            }
          }

          for (var work in details.works.orEmptyList()) {

            work.anime?.let((it) {
              _bestWorksAnime.add(it);
            });

            work.manga?.let((it) {
              if (it.type == MangaType.lightNovel ||
                  it.type == MangaType.novel) {
                _bestWorksRanobe.add(it);
              } else {
                _bestWorksManga.add(it);
              }
            });

          }
        });

        if (_personDetails != null) {
          state(PeopleDataLoaded(
              personDetails: _personDetails!,
              seyuBestRoles: _seyuBestRoles,
              bestWorksAnime: _bestWorksAnime,
              bestWorksManga: _bestWorksManga,
              bestWorksRanobe: _bestWorksRanobe));
        } else {
          state(CharacterPeopleError());
        }
      } catch (e) {
        state(CharacterPeopleError());
      }
    });
  }
}
