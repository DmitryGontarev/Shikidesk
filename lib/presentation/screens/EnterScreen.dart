
import 'package:flutter/material.dart';
import 'package:shikidesk/presentation/items/Texts.dart';
import 'package:shikidesk/presentation/navigation/NavigationFunctions.dart';
import 'package:shikidesk/ui/AssetsPath.dart';
import 'package:shikidesk/ui/Colors.dart';
import 'package:shikidesk/ui/Strings.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/ui/components/MyButton.dart';
import 'package:shikidesk/ui/components/Paddings.dart';

class EnterScreen extends StatelessWidget {
  const EnterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PaddingAll(
              child: ImageFromAsset(
                size: 100,
                path: shikimoriLogo,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const PaddingAll(
              child: MyText(
                text: shikidroidLogoTitle,
                fontSize: 27,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                MyButton(
                    btnText: enterLikeGuestTitle,
                    btnColor: Theme.of(context).primaryColor,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    onClick: () {
                      navigateGuestRail(context: context);
                    }),
                MyButton(
                    btnText: enterTitle,
                    btnColor: ShikidroidColors.darkColorSecondary,
                    borderColor: Colors.transparent,
                    onClick: () {
                      navigateAuthorizationScreen(context: context);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
