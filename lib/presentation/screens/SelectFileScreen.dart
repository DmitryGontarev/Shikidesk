
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

import '../../ui/Colors.dart';
import '../../ui/Strings.dart';
import '../../ui/components/MyButton.dart';
import '../items/Texts.dart';
import '../navigation/NavigationFunctions.dart';

////////////////////////////////////////////////////////////////////////////////
/// Контейнер экрана Видеоплеер
////////////////////////////////////////////////////////////////////////////////
class SelectFileContainer extends StatelessWidget {
  const SelectFileContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Navigator(
        key: const Key("SelectFile"),
        onGenerateRoute: (route) => MaterialPageRoute(
            settings: route, builder: (context) => const SelectFileScreen()),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
/// Экран выбора файлов для воспроизведения в плеере
////////////////////////////////////////////////////////////////////////////////
class SelectFileScreen extends StatefulWidget {
  const SelectFileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SelectFileScreenState();
  }
}

class _SelectFileScreenState extends State<SelectFileScreen> {

  void _pickFile({required Function(List<String> playlist) callback}) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      dialogTitle: "Выберите файл для плеера Shikidesk",
      type: FileType.custom,
      allowedExtensions: ["avi", "flv", "mkv", "mov", "mp4", "mpeg", "webm", "wmv", "aac", "midi", "mp3", "ogg", "wav", "flac"]
    );

    if (result == null) {
      return;
    } else {
      List<String?> filePaths = result.paths;

      List<String> playlist = [];

      for (var i in filePaths) {
        if (i != null && i.isNotEmpty) {
          playlist.add(i);
        }
      }

      if (playlist.isNotEmpty) {
        callback(playlist);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PaddingAll(
              child: ImageFromAsset(
                path: iconVideo,
                size: 100.0,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const PaddingAll(
              child: MyText(
                text: playerTitle,
                fontSize: 27,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                MyButton(
                    btnText: selectFiles,
                    btnColor: ShikidroidColors.darkColorSecondary,
                    borderColor: Colors.transparent,
                    onClick: () {
                      _pickFile(callback: (playlist) {
                        navigateVideoPlayer(playlist: playlist, context: context);
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
