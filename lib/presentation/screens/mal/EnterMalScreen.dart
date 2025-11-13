
import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Sizes.dart';

import '../../../ui/Colors.dart';
import '../../../ui/Strings.dart';
import '../../../ui/components/ImageFromAsset.dart';
import '../../../ui/components/MyButton.dart';
import '../../../ui/components/Paddings.dart';
import '../../items/Texts.dart';

class EnterMalScreen extends StatelessWidget {

  final Function() mainCallback;

  const EnterMalScreen({super.key, required this.mainCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            ImageFromAsset(
              size: 100,
              path: myAnimeListLogo,
              color: Theme.of(context).colorScheme.onPrimary,
            ),

            const PaddingBySide(
              bottom: Doubles.ten,
              child: MyText(
                text: "Сервер Shikimori не отвечает\nВы можете повторить запрос или использовать сервер MyAnimeList, но часть текста будет на английском",
                maxLines: 2,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [

                MyButton(
                    btnText: oneMoreTryTitle,
                    btnColor: Theme.of(context).primaryColor,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    onClick: () {
                      mainCallback();
                    }),

                MyButton(
                    btnText: continueTitle,
                    btnColor: ShikidroidColors.darkColorSecondary,
                    borderColor: Colors.transparent,
                    onClick: () {
                      navigateMalRail(context: context);
                    })

              ],
            )
          ],
        ),
      ),
    );
  }
}