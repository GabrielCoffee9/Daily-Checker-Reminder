import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/theme_repository.dart';

class ThemeSetting extends StatelessWidget {
  const ThemeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.app_color_theme,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Card(
              elevation: 2,
              child: ColorPicker(
                enableShadesSelection: false,
                pickersEnabled: const <ColorPickerType, bool>{
                  ColorPickerType.both: false,
                  ColorPickerType.primary: false,
                  ColorPickerType.accent: true,
                  ColorPickerType.bw: false,
                  ColorPickerType.custom: false,
                  ColorPickerType.customSecondary: false,
                  ColorPickerType.wheel: false,
                },
                color: context.watch<ThemeRepository>().themeSeedColor,
                onColorChanged: (Color color) {
                  context
                      .read<ThemeRepository>()
                      .changeThemeColor(newColor: color);
                },
                width: 44,
                height: 44,
                borderRadius: 22,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
