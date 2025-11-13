import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shikidesk/domain/interactors/MangaInteractor.dart';
import 'package:shikidesk/domain/interactors/RanobeIneractor.dart';
import 'package:shikidesk/domain/models/anime/AnimeDetailsModel.dart';
import 'package:shikidesk/domain/models/anime/AnimeVideoModel.dart';
import 'package:shikidesk/domain/models/anime/ScreenshotModel.dart';
import 'package:shikidesk/domain/models/common/Failure.dart';
import 'package:shikidesk/domain/models/common/LinkModel.dart';
import 'package:shikidesk/domain/models/manga/MangaModel.dart';
import 'package:shikidesk/domain/models/roles/CharacterModel.dart';
import 'package:shikidesk/presentation/ScreenEnums.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/ListExtensions.dart';

import '../../domain/interactors/AnimeInteractor.dart';
import '../../domain/models/anime/AnimeModel.dart';
import '../../domain/models/common/RelatedModel.dart';
import '../../domain/models/common/RolesModel.dart';
import '../../domain/models/manga/MangaDetailsModel.dart';

////////////////////////////////////////////////////////////////////////////////
///
/// СОБЫТИЯ
///
////////////////////////////////////////////////////////////////////////////////
abstract class DetailsScreenEvent {
  const DetailsScreenEvent();
}

/// Событие старта загрузки
class LoadDetails extends DetailsScreenEvent {
  final DetailsScreenType screenType;
  final int? id;

  const LoadDetails({required this.screenType, required this.id});
}

////////////////////////////////////////////////////////////////////////////////
/// СОСТОЯНИЯ
////////////////////////////////////////////////////////////////////////////////
abstract class DetailsScreenState {
  const DetailsScreenState();
}

/// Загрузка данных Детальной информации
class DetailsLoading extends DetailsScreenState {
  const DetailsLoading();
}

/// Данные Детальной информации об Аниме загружены
class AnimeDetailsLoaded extends DetailsScreenState {
  final AnimeDetailsModel animeDetails;
  final List<CharacterModel> characters;
  final List<ScreenshotModel> screenshots;
  final List<AnimeVideoModel> animeVideos;
  final List<RelatedModel> animeRelated;
  final List<AnimeModel> animeSimilar;
  final List<LinkModel> externalLinks;

  const AnimeDetailsLoaded(
      {required this.animeDetails,
      required this.characters,
      required this.screenshots,
      required this.animeVideos,
      required this.animeRelated,
      required this.animeSimilar,
      required this.externalLinks});
}

/// Данные Детальной информации о Манге загружены
class MangaRanobeDetailsLoaded extends DetailsScreenState {
  final MangaDetailsModel mangaRanobeDetails;
  final List<CharacterModel> characters;
  final List<RelatedModel> mangaRelated;
  final List<MangaModel> mangaRanobeSimilar;

  const MangaRanobeDetailsLoaded(
      {required this.mangaRanobeDetails,
      required this.characters,
      required this.mangaRelated,
      required this.mangaRanobeSimilar});
}

/// Ошибка загрузки данных
class DetailsError extends DetailsScreenState {}

////////////////////////////////////////////////////////////////////////////////
///
/// БЛоК экрана Детальной информации
///
////////////////////////////////////////////////////////////////////////////////
class DetailsScreenBloc extends Bloc<DetailsScreenEvent, DetailsScreenState> {
  DetailsScreenType screenType;
  final AnimeInteractor animeInteractor;
  final MangaInteractor mangaInteractor;
  final RanobeInteractor ranobeInteractor;

  AnimeDetailsModel? _animeDetails;
  MangaDetailsModel? _mangaRanobeDetails;
  List<RolesModel> _roles = [];
  List<CharacterModel> _characters = [];
  List<CharacterModel> _mainCharacters = [];
  List<CharacterModel> _supportingCharacters = [];
  List<ScreenshotModel> _screenshots = [];
  List<AnimeVideoModel> _animeVideos = [];
  List<RelatedModel> _related = [];
  List<AnimeModel> _animeSimilar = [];
  List<MangaModel> _mangaRanobeSimilar = [];
  List<LinkModel> _externalLinks = [];

  static const String mainCharacter = "Main";
  static const String supportingCharacter = "Supporting";

  DetailsScreenBloc(
      {this.screenType = DetailsScreenType.anime,
      required this.animeInteractor,
      required this.mangaInteractor,
      required this.ranobeInteractor})
      : super(const DetailsLoading()) {
    /// Загрузка данных
    on<LoadDetails>((event, emit) async {
      emit(const DetailsLoading());

      screenType = event.screenType;

      if (screenType == DetailsScreenType.anime) {
        await _loadAnimeData(event.id, (state) {
          emit(state);
        });
      } else {
        await _loadMangaRanobeData(event.id, (state) {
          emit(state);
        });
      }
    });
  }

  /// Загрузка всей информации об аниме
  Future<void> _loadAnimeData(
      int? id, Function(DetailsScreenState state) state) async {
    await _loadAnimeDetails(id);

    await _loadRoles(id);

    await _loadScreenshots(id);

    await _loadAnimeVideos(id);

    await _loadRelated(id);

    await _loadAnimeSimilar(id);

    await _loadLinks(id);

    if (_animeDetails != null) {
      state(AnimeDetailsLoaded(
          animeDetails: _animeDetails!,
          characters: _characters,
          screenshots: _screenshots,
          animeVideos: _animeVideos,
          animeRelated: _related,
          animeSimilar: _animeSimilar,
          externalLinks: _externalLinks));
    } else {
      state(DetailsError());
    }
  }

  /// Загрузка всей информации о Манге или Ранобэ
  Future<void> _loadMangaRanobeData(
      int? id, Function(DetailsScreenState state) state) async {
    await _loadMangaRanobeDetails(id);

    await _loadRoles(id);

    await _loadRelated(id);

    await _loadMangaRanobeSimilar(id);

    if (_mangaRanobeDetails != null) {
      state(MangaRanobeDetailsLoaded(
          mangaRanobeDetails: _mangaRanobeDetails!,
          characters: _characters,
          mangaRelated: _related,
          mangaRanobeSimilar: _mangaRanobeSimilar));
    } else {
      state(DetailsError());
    }
  }

  /// Загрузка Детальной информации об Аниме
  Future<void> _loadAnimeDetails(int? id) async {
    await id?.let((it) async {
      try {
        final animeDetails = await animeInteractor.getAnimeDetailsById(it);
        animeDetails.fold((failure) {
          _animeDetails = null;
        }, (details) {
          _animeDetails = details;
        });
      } catch (e) {
        _animeDetails = null;
      }
    });
  }

  /// Загрузка Детальной информации о Манге/Ранобэ
  Future<void> _loadMangaRanobeDetails(int? id) async {
    await id?.let((it) async {
      try {
        Either<Failure, MangaDetailsModel> details;
        if (screenType == DetailsScreenType.manga) {
          details = await mangaInteractor.getMangaDetailsById(id);
        } else {
          details = await ranobeInteractor.getRanobeDetailsById(id);
        }
        details.fold((failure) {
          _mangaRanobeDetails = null;
        }, (details) {
          _mangaRanobeDetails = details;
        });
      } catch (e) {
        _mangaRanobeDetails = null;
      }
    });
  }

  /// Загрузка Персонажей и Людей, принимавших участие в создании Аниме/Манги/Ранобэ
  Future<void> _loadRoles(int? id) async {
    await id?.let((it) async {
      try {
        Either<Failure, List<RolesModel>> rolesList;
        switch (screenType) {
          case (DetailsScreenType.anime):
            rolesList = await animeInteractor.getAnimeRolesById(id);
          case (DetailsScreenType.manga):
            rolesList = await mangaInteractor.getMangaRolesById(id);
          default:
            rolesList = await ranobeInteractor.getRanobeRolesById(id);
        }
        rolesList.fold((fauilure) {
          _roles = [];
        }, (roles) {
          _roles = roles;

          List<CharacterModel> main = [];
          List<CharacterModel> support = [];

          var characters = roles.filter((item) {
            return item.character != null;
          });

          for (var role in characters) {
            if (role.roles?.contains(mainCharacter) == true) {
              role.character?.let((it) {
                main.add(it);
              });
            } else {
              if (role.roles?.contains(supportingCharacter) == true) {
                role.character?.let((it) {
                  support.add(it);
                });
              } else {
                role.character?.let((it) {
                  support.add(it);
                });
              }
            }
          }

          _characters = main + support;
          _mainCharacters = main;
          _supportingCharacters = support;
        });
      } catch (e) {
        _roles = [];
      }
    });
  }

  /// Загрузка Скриншотов
  Future<void> _loadScreenshots(int? id) async {
    await id?.let((it) async {
      try {
        final screenshots = await animeInteractor.getAnimeScreenshotsById(it);
        screenshots.fold((failure) {
          _screenshots = [];
        }, (screens) {
          _screenshots = screens;
        });
      } catch (e) {
        _screenshots = [];
      }
    });
  }

  /// Загрузка видео, связанных с аниме
  Future<void> _loadAnimeVideos(int? id) async {
    await id?.let((it) async {
      try {
        final animeVideos = await animeInteractor.getAnimeVideos(it);
        animeVideos.fold((failure) {
          _animeVideos = [];
        }, (videos) {
          _animeVideos = videos;
        });
      } catch (e) {
        _animeVideos = [];
      }
    });
  }

  /// Загрузка Связанных аниме
  Future<void> _loadRelated(int? id) async {
    await id?.let((it) async {
      try {
        Either<Failure, List<RelatedModel>> relatedList;
        switch (screenType) {
          case (DetailsScreenType.anime):
            relatedList = await animeInteractor.getRelatedAnime(id);
          case (DetailsScreenType.manga):
            relatedList = await mangaInteractor.getRelatedManga(id);
          default:
            relatedList = await ranobeInteractor.getRelatedRanobe(id);
        }
        relatedList.fold((failure) {
          _related = [];
        }, (related) {
          _related = related;
        });
      } catch (e) {
        _related = [];
      }
    });
  }

  /// Загрузка Похожего аниме
  Future<void> _loadAnimeSimilar(int? id) async {
    await id?.let((it) async {
      try {
        final animeSimilar = await animeInteractor.getSimilarAnime(id);
        animeSimilar.fold((failure) {
          _animeSimilar = [];
        }, (similar) {
          _animeSimilar = similar;
        });
      } catch (e) {
        _animeSimilar = [];
      }
    });
  }

  /// Загрузка Похожей Манги/Ранобэ
  Future<void> _loadMangaRanobeSimilar(int? id) async {
    await id?.let((it) async {
      try {
        Either<Failure, List<MangaModel>> similarList;
        if (screenType == DetailsScreenType.manga) {
          similarList = await mangaInteractor.getSimilarManga(id);
        } else {
          similarList = await ranobeInteractor.getSimilarRanobe(id);
        }
        similarList.fold((failure) {
          _mangaRanobeSimilar = [];
        }, (similar) {
          _mangaRanobeSimilar = similar;
        });
      } catch (e) {
        _mangaRanobeSimilar = [];
      }
    });
  }

  /// Загрузка ссылок на связанные сайты
  Future<void> _loadLinks(int? id) async {
    await id?.let((it) async {
      try {
        Either<Failure, List<LinkModel>> externalLinksList;
        switch (screenType) {
          case (DetailsScreenType.anime):
            externalLinksList =
                await animeInteractor.getAnimeExternalLinksById(id);
          case (DetailsScreenType.manga):
            externalLinksList =
                await animeInteractor.getAnimeExternalLinksById(id);
          default:
            externalLinksList =
                await animeInteractor.getAnimeExternalLinksById(id);
        }
        externalLinksList.fold((failure) {
          _externalLinks = [];
        }, (related) {
          _externalLinks = related;
        });
      } catch (e) {
        _externalLinks = [];
      }
    });
  }
}