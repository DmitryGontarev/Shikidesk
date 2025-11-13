import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shikidesk/ui/components/ImageFromAsset.dart';
import 'package:shikidesk/ui/components/SpacerSized.dart';
import 'package:shikidesk/utils/Extensions.dart';

import '../../ui/AssetsPath.dart';
import '../../ui/Colors.dart';
import '../../ui/Strings.dart';
import '../../ui/components/MyButton.dart';
import '../../ui/components/Paddings.dart';
import '../items/Texts.dart';
import '../navigation/NavigationFunctions.dart';

class ErrorScreen extends StatelessWidget {
  final String icon;
  final String text;
  final int? errorCode;
  final bool showBackButton;
  final Function()? mainCallback;

  const ErrorScreen(
      {super.key,
      this.icon = iconNotFound,
      this.text = tryAnotherOneErrorText,
      this.errorCode,
      this.showBackButton = true,
      this.mainCallback});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SpacerSized(),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const PaddingAll(
                child: ImageFromAsset(
                  size: 100,
                  path: iconNotFound,
                  color: Colors.white,
                ),
              ),
              PaddingAll(
                child: MyText(
                  text: text,
                  fontSize: 27,
                  maxLines: 3,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (mainCallback != null)
                    MyButton(
                        btnText: oneMoreTryTitle,
                        btnColor: Theme.of(context).primaryColor,
                        borderColor: Theme.of(context).colorScheme.secondary,
                        onClick: () {
                          mainCallback?.let((it) {
                            it();
                          });
                        }),
                  if (showBackButton)
                    MyButton(
                        btnText: goBackTitle,
                        btnColor: ShikidroidColors.darkColorSecondary,
                        borderColor: Colors.transparent,
                        onClick: () {
                          navigateBack(context);
                        }),
                ],
              )
            ],
          ),

          if (errorCode != null) ...{
            PaddingAll(
              child: MyTextOnBackground(
                text: "код ошибки: $errorCode",
              ),
            )
          } else...{
            const SpacerSized()
          },
        ],
      ),
    );
  }
}
