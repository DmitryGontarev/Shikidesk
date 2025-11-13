import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:shikidesk/presentation/items/ContainerColor.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Sizes.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/FixMouseRegion.dart';
import 'package:shikidesk/ui/components/Loader.dart';
import 'package:shikidesk/ui/components/Paddings.dart';
import 'package:shikidesk/ui/components/PopupMenuButtons.dart';
import 'package:shikidesk/ui/components/ToolbarForApp.dart';
import 'package:shikidesk/utils/Extensions.dart';
import 'package:shikidesk/utils/IntExtensions.dart';
import 'package:window_manager/window_manager.dart';

const int playbackStep = 10;
const double volumeStep = 5;

////////////////////////////////////////////////////////////////////////////////
/// Видеоплеер для проигрывания локальных файлов
////////////////////////////////////////////////////////////////////////////////
class VideoPlayerScreen extends StatefulWidget {
  final List<String> playlist;

  const VideoPlayerScreen({super.key, required this.playlist});

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerScreenState();
  }
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final Player player = Player();

  late final VideoController controller = VideoController(player,
      configuration:
          const VideoControllerConfiguration(enableHardwareAcceleration: true));

  final FocusNode _focusNode = FocusNode();

  var isBuffering = true;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    if (mounted) {
      player.stream.buffering.listen((event) {
        setState(() {
          isBuffering = event;
        });
      });
      player.stream.playing.listen((event) {
        if (event && showPlayPause) {
          if (event && showPlayPause) {
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                showPlayPause = false;
              });
            });
          }
        }
      });
    }

    List<Media> playlist = [];

    for (String path in widget.playlist) {
      playlist.add(Media(path));
    }

    Playable playable = Playlist(playlist);

    playable.let((playableList) async {
      await player.open(playableList, play: true);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    player.dispose();
    timer?.cancel();
    super.dispose();
  }

  /// флаг для показа кнопок плеера
  bool showControls = false;

  /// флаг для показа текущей громкости
  bool showVolume = false;

  /// флаг для показа текущего времени просмотра видео
  bool showDuration = false;

  /// флаг для показа воспроизведения/паузы при нажатии пробела
  bool showPlayPause = false;

  /// текущее значение громкости
  double unmutedVolume = 0.5;

  /// текущая позиция видео
  int currentPosition = 0;

  /// флаг перемотки видео
  bool isRewinding = false;

  /// Таймер для скрытия кнопок экрана
  Timer? timer;

  /// флаг показа курсора мыши
  bool showCursor = true;

  void startTimer() {
    setState(() {
      showCursor = true;
      showControls = true;
    });

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick >= 5) {
        setState(() {
          showCursor = false;
          showControls = false;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    void showVolumeState() {
      setState(() {
        showVolume = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          showVolume = false;
        });
      });
    }

    void showDurationState() {
      setState(() {
        showDuration = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (isRewinding == false) {
          setState(() {
            showDuration = false;
          });
        }
      });
    }

    void showPlayPauseState() {
      setState(() {
        showPlayPause = true;
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (player.state.playing) {
          setState(() {
            showPlayPause = false;
          });
        }
      });
    }

    String getTitleString() {
      String path = widget.playlist[player.state.playlist.index];
      int lastSlashIndex = path.lastIndexOf('\\');
      int formatIndex = path.lastIndexOf('.');
      return path.substring(lastSlashIndex, formatIndex).replaceFirst('\\', '');
    }

    int getPlayerPosition({required int time}) {
      if (time > player.state.position.inSeconds) {
        return player.state.position.inSeconds +
            (time - player.state.position.inSeconds);
      }
      if (time < player.state.position.inSeconds) {
        return player.state.position.inSeconds -
            (player.state.position.inSeconds - time);
      }
      return player.state.position.inSeconds;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: FixMouseRegion(
        cursor: showCursor ? SystemMouseCursors.basic : SystemMouseCursors.none,
        onEnter: (d) {
          setState(() {
            showControls = true;
          });
        },
        onExit: (d) {
          setState(() {
            showCursor = true;
            showControls = false;
            timer?.cancel();
          });
        },
        onHover: (d) {
          startTimer();
        },
        child: RawKeyboardListener(
            autofocus: true,
            focusNode: _focusNode,
            onKey: (event) {
              /// Нажатие на пробел
              if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                if (player.state.completed) {
                  player.seek(const Duration(seconds: 0));
                }
                if (player.state.playing) {
                  player.pause();
                } else {
                  player.play();
                }
                showPlayPauseState();
                setState(() {});
              }

              /// Нажатие на левую стрелку
              if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                if (!isRewinding) {
                  currentPosition = player.state.position.inSeconds ?? 0;
                }
                isRewinding = true;
                if (!(currentPosition - playbackStep).isNegative) {
                  currentPosition -= playbackStep;
                }
                showDurationState();
              }

              if (event is RawKeyUpEvent &&
                  event.logicalKey == LogicalKeyboardKey.arrowLeft) {
                player.seek(Duration(
                    seconds: getPlayerPosition(time: currentPosition)));
                isRewinding = false;
                setState(() {});
              }

              /// Нажатие на правую стрелку
              if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                if (!isRewinding) {
                  currentPosition = player.state.position.inSeconds ?? 0;
                }
                isRewinding = true;
                int duration = player.state.duration.inSeconds ?? 0;
                if ((currentPosition + playbackStep) <= duration) {
                  currentPosition += playbackStep;
                }
                showDurationState();
              }

              if (event is RawKeyUpEvent &&
                  event.logicalKey == LogicalKeyboardKey.arrowRight) {
                player.seek(Duration(
                    seconds: getPlayerPosition(time: currentPosition)));
                isRewinding = false;
                setState(() {});
              }

              /// Нажатие на стрелку вверх
              if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                if (player.state.volume < 100 &&
                    (player.state.volume + volumeStep < 100)) {
                  setState(() {
                    player.setVolume(player.state.volume + volumeStep);
                  });
                } else {
                  setState(() {
                    player.setVolume(100);
                  });
                }
                showVolumeState();
              }

              /// Нажатие на стрелку вниз
              if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                if (player.state.volume > 0 &&
                    (player.state.volume - volumeStep > 0)) {
                  setState(() {
                    player.setVolume(player.state.volume - volumeStep);
                  });
                } else {
                  setState(() {
                    player.setVolume(0);
                  });
                }
                showVolumeState();
              }

              /// Нажатие на кнопку M
              if (event.isKeyPressed(LogicalKeyboardKey.keyM)) {
                if (player.state.volume > 0) {
                  unmutedVolume = player.state.volume;
                  player.setVolume(0);
                } else {
                  player.setVolume(unmutedVolume);
                }
                setState(() {});
                showVolumeState();
              }

              /// Нажатие на Backspace <-
              if (event is RawKeyUpEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                navigateBack(context);
              }
            },
            child: Stack(
              children: [
                SizedBox(
                  height: height,
                  width: width,
                  child: Video(
                    controller: controller,
                    controls: NoVideoControls,
                  ),
                ),

                /// Отображение кнопок плеер при наведении курсора на экран
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showControls ? 1 : 0,
                  child: _Controls(
                      player: player,
                      title: getTitleString(),
                      playlist: widget.playlist),
                ),

                /// Отображение громкости при регулировке с клавиатуры
                AnimatedOpacity(
                  opacity: showVolume ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: PaddingBySide(
                      top: MediaQuery.of(context).size.height / 3,
                      child: ContainerColor(
                          child: PaddingAll(
                              child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyTextSemiBold(
                            text: "${(player.state.volume).toInt()} %",
                            fontSize: TextSize.big,
                          ),
                          PaddingBySide(
                              start: Doubles.seven,
                              child: Icon(getVolumeIcon(player: player)))
                        ],
                      ))),
                    ),
                  ),
                ),

                /// Отображение текущего времени просмотра при регулировке с клавиатуры
                AnimatedOpacity(
                  opacity: showDuration ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: PaddingBySide(
                        top: MediaQuery.of(context).size.height / 3,
                        child: ContainerColor(
                            child: PaddingAll(
                                all: Doubles.twelve,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MyTextSemiBold(
                                        text: currentPosition.toVideoTime(),
                                        fontSize: TextSize.big,
                                        color: Colors.white),
                                    MyTextOnBackground(
                                        text:
                                            " | ${player.state.position.inSeconds.toVideoTime()} | ",
                                        fontSize: TextSize.big),
                                    MyTextSemiBold(
                                        text: player.state.duration.inSeconds
                                            .toVideoTime(),
                                        fontSize: TextSize.big,
                                        color: Colors.white),
                                  ],
                                )))),
                  ),
                ),

                /// Отображение иконки воспроизведение/пауза при нажатии пробела
                AnimatedOpacity(
                  opacity: showPlayPause ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: ContainerColor(
                        child: PaddingAll(
                            all: Doubles.twelve,
                            child: Icon(getPlayerStateIcon(player: player)))),
                  ),
                ),

                /// Отображение индикатора загрузки видео
                AnimatedOpacity(
                  opacity: isBuffering ? 1 : 0,
                  duration: const Duration(milliseconds: 100),
                  child: const Loader(),
                )
              ],
            )),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Контроллеры экрана
////////////////////////////////////////////////////////////////////////////////
class _Controls extends StatefulWidget {
  final Player player;
  final String? title;
  final List<String> playlist;

  const _Controls({required this.player, this.title, required this.playlist});

  @override
  State<StatefulWidget> createState() {
    return _ControlsState();
  }
}

class _ControlsState extends State<_Controls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ToolbarForApp(
          backspaceListen: false,
          centerWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextOnBackground(text: widget.title, maxLines: 3),
              // MyTextOnBackground(text: "${widget.video?.episodeId} эпизод")
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [_VolumeControl(player: widget.player)],
        ),
        PaddingBySide(
            start: Doubles.seven,
            top: Doubles.seven,
            end: Doubles.seven,
            bottom: Doubles.fourteen,
            child: _BottomControls(
              player: widget.player,
              playlist: widget.playlist,
            ))
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Контроллер громкости с правой стороны экрана
////////////////////////////////////////////////////////////////////////////////
class _VolumeControl extends StatefulWidget {
  final Player player;

  const _VolumeControl({required this.player});

  @override
  State<StatefulWidget> createState() {
    return _VolumeControlState();
  }
}

class _VolumeControlState extends State<_VolumeControl> {
  double volume = 50;
  double unmutedVolume = 50;

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).colorScheme.secondary;

    return SizedBox(
      width: 60,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PaddingBySide(
              end: Doubles.fourteen,
              bottom: Doubles.three,
              child: RotatedBox(
                quarterTurns: -1,
                child: MouseRegion(
                  onExit: (d) {
                    _focusNode.unfocus();
                  },
                  child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10)),
                      child: Slider(
                        focusNode: _focusNode,
                        min: 0.0,
                        max: 100.0,
                        value: widget.player.state.volume,
                        onChanged: (volume) {
                          setState(() {
                            widget.player.setVolume(volume);
                          });
                        },
                        activeColor: color,
                        thumbColor: color,
                        inactiveColor: Colors.white24,
                      )),
                ),
              )),
          PaddingBySide(
              end: Doubles.fourteen,
              child: InkWell(
                onTap: () {
                  muteUnmute();
                },
                child: ContainerColor(
                    child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          muteUnmute();
                        },
                        icon: Icon(getVolumeIcon(player: widget.player)))),
              ))
        ],
      ),
    );
  }

  /// Функция для отключения звука плеера
  void muteUnmute() {
    if (widget.player.state.volume > 0) {
      unmutedVolume = widget.player.state.volume;
      widget.player.setVolume(0);
    } else {
      widget.player.setVolume(unmutedVolume);
    }
    setState(() {});
  }
}

/// Функция для получения иконки громкости в завимисости от значения
///
/// [player] плеер для воспроизведения видео
IconData getVolumeIcon({required Player player}) {
  if (player.state.volume > 50) {
    return Icons.volume_up_sharp;
  } else if (player.state.volume > 0) {
    return Icons.volume_down_sharp;
  } else {
    return Icons.volume_off_sharp;
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Нижние контроллеры видеоплеера
////////////////////////////////////////////////////////////////////////////////
class _BottomControls extends StatefulWidget {
  final Player player;
  final List<String> playlist;

  const _BottomControls({required this.player, required this.playlist});

  @override
  State<StatefulWidget> createState() {
    return _BottomControlsState();
  }
}

class _BottomControlsState extends State<_BottomControls> {
  var progress = const Duration(seconds: 0);
  var total = const Duration(seconds: 100);

  var currentPosition = 0.0;

  var showCurrentPositionText = false;

  List<double> videoSpeed = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  double currentVideoSpeed = 1.0;

  String icon = iconFullscreen;

  String iconText = enterFullscreenText;

  String getVideoSpeedText({required double speed}) {
    switch (speed) {
      case (0.25):
        return "0.25x";
      case (0.5):
        return "0.5x";
      case (0.75):
        return "0.75x";
      case (1.0):
        return "1x";
      case (1.25):
        return "1.25x";
      case (1.5):
        return "1.5x";
      case (1.75):
        return "1.75x";
      case (2.0):
        return "2x";
      default:
        return "1x";
    }
  }

  @override
  Widget build(BuildContext context) {
    var player = widget.player;
    var color = Theme.of(context).colorScheme.secondary;

    final FocusNode _focusNode = FocusNode();

    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: widget.player.stream.position,
            builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
              final durationState = snapshot.data;

              progress = widget.player.state.position ?? Duration.zero;
              total = widget.player.state.duration ?? Duration.zero;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                    text: progress.inSeconds.toVideoTime(),
                    color: Colors.white,
                  ),
                  PaddingBySide(
                      start: Doubles.three,
                      end: Doubles.three,
                      child: MouseRegion(
                        onExit: (d) {
                          _focusNode.unfocus();
                        },
                        child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 10)),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 280,
                              child: Slider(
                                  focusNode: _focusNode,
                                  min: 0,
                                  max: total.inSeconds.toDouble(),
                                  value: getCurrentPosition(),
                                  onChanged: (position) {
                                    setState(() {
                                      currentPosition = position;
                                      showCurrentPositionText = true;
                                    });
                                  },
                                  onChangeEnd: (position) {
                                    setState(() {
                                      widget.player.seek(
                                          Duration(seconds: position.toInt()));
                                      showCurrentPositionText = false;
                                      currentPosition = 0;
                                    });
                                  },
                                  activeColor: color,
                                  thumbColor: color,
                                  inactiveColor: Colors.white24),
                            )),
                      )),
                  MyText(
                    text: total.inSeconds.toVideoTime(),
                    color: Colors.white,
                  )
                ],
              );
            }),
        PaddingBySide(
            start: Doubles.twenty,
            end: Doubles.twenty,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: showCurrentPositionText ? 1 : 0,
                  child: ContainerColor(
                    child: PaddingAll(
                      child: MyText(
                          text: currentPosition.toInt().toVideoTime(),
                          color: Colors.white),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: widget.player.stream.position,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (player.state.playlist.index > 0) ...{
                          IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            icon: const Icon(Icons.skip_previous),
                            onPressed: () async {
                              await player.previous();
                            },
                          )
                        } else ...{
                          const SizedBox(width: 20)
                        },
                        const SizedBox(width: 50),
                        IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            icon: const Icon(Icons.replay_10),
                            onPressed: () {
                              int position =
                                  player.state.position.inSeconds ?? 0;
                              if (!(position - playbackStep).isNegative) {
                                position -= playbackStep;
                              }
                              player.seek(Duration(seconds: position));
                              setState(() {});
                            }),
                        const SizedBox(width: 20),
                        IconButton(
                          color: Colors.white,
                          iconSize: 30,
                          icon: Icon(getPlayIcon(player: widget.player)),
                          onPressed: () {
                            if (player.state.completed) {
                              player.seek(const Duration(milliseconds: 0));
                            }
                            if (player.state.playing) {
                              player.pause();
                            } else {
                              player.play();
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            icon: const Icon(Icons.forward_10),
                            onPressed: () {
                              int duration =
                                  player.state.duration.inSeconds ?? 0;
                              int position =
                                  player.state.position.inSeconds ?? 1;
                              if ((position + playbackStep) <= duration) {
                                position += playbackStep;
                                player.seek(Duration(seconds: position));
                              }
                              setState(() {});
                            }),
                        const SizedBox(width: 50),
                        if (player.state.playlist.index <
                            widget.playlist.length - 1) ...{
                          IconButton(
                            color: Colors.white,
                            iconSize: 30,
                            icon: const Icon(Icons.skip_next),
                            onPressed: () async {
                              await player.next();
                            },
                          )
                        } else ...{
                          const SizedBox(width: 20)
                        },
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    PopupMenuTextButton(
                        buttonText: getVideoSpeedText(speed: currentVideoSpeed),
                        message: "Изменить скорость воспроизведения",
                        color: Colors.white,
                        menuWidgets: videoSpeed
                            .map((e) =>
                                MyText(text: getVideoSpeedText(speed: e)))
                            .toList(),
                        callback: (index) {
                          widget.player.setRate(videoSpeed[index]);
                          currentVideoSpeed = videoSpeed[index];
                          setState(() {});
                        }),
                    PopupMenuIconButton(
                        message: "Сменить устройство вывода звука",
                        icon: const Icon(Icons.speaker, color: Colors.white),
                        menuWidgets: widget.player.state.audioDevices
                            .map((device) => MyText(
                                  text: device.name,
                                  fontSize: 14,
                                  textAlign: TextAlign.start,
                                ))
                            .toList(),
                        callback: (index) {
                          player.setAudioDevice(
                              widget.player.state.audioDevices[index]);
                          setState(() {});
                        }),
                    // TooltipButton(
                    //   message: iconText,
                    //     icon: iconFullscreen,
                    //     onClick: () async {
                    //     consolePrint("FULL");
                    //       if (await windowManager.isFullScreen()) {
                    //         await windowManager.setFullScreen(false);
                    //         setState(() {
                    //           icon = iconFullscreen;
                    //           iconText = enterFullscreenText;
                    //         });
                    //       } else {
                    //         await windowManager.setFullScreen(true);
                    //         setState(() {
                    //           icon = iconLeaveFullscreen;
                    //           iconText = leaveFullscreenText;
                    //         });
                    //       }
                    //     }
                    // )
                  ],
                )
              ],
            ))
      ],
    ));
  }

  double getCurrentPosition() {
    if (currentPosition == 0) {
      return progress.inSeconds.toDouble();
    } else {
      return currentPosition;
    }
  }
}

IconData getPlayIcon({required Player player}) {
  if (player.state.completed) {
    return Icons.replay;
  }
  if (player.state.playing) {
    return Icons.pause;
  }
  if (player.state.playing != true) {
    return Icons.play_arrow;
  }
  return Icons.play_arrow;
}

IconData getPlayerStateIcon({required Player player}) {
  if (player.state.completed) {
    return Icons.replay;
  }
  if (player.state.playing) {
    return Icons.play_arrow;
  }
  if (player.state.playing != true) {
    return Icons.pause;
  }
  return Icons.pause;
}
