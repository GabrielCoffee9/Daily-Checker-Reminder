import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../data/repositories/locale_repository.dart';
import '../../../i18n/generated/app_localizations.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.language,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: DropdownMenu(
            leadingIcon: Icon(Icons.translate),
            initialSelection:
                context.read<LocaleRepository>().currentLocaleString ??
                    AppLocalizations.of(context)?.localeName ??
                    'en',
            dropdownMenuEntries: [
              DropdownMenuEntry(
                  value: 'en', label: AppLocalizations.of(context)!.english),
              DropdownMenuEntry(
                  value: 'pt', label: AppLocalizations.of(context)!.portuguese),
              DropdownMenuEntry(
                  value: 'pt_BR',
                  label: AppLocalizations.of(context)!.brazilian),
              DropdownMenuEntry(
                  value: 'es', label: AppLocalizations.of(context)!.spanish),
              DropdownMenuEntry(
                  value: 'fr', label: AppLocalizations.of(context)!.french),
              DropdownMenuEntry(
                  value: 'it', label: AppLocalizations.of(context)!.italian),
              DropdownMenuEntry(
                  value: 'de', label: AppLocalizations.of(context)!.german),
              DropdownMenuEntry(
                  value: 'zh', label: AppLocalizations.of(context)!.chinese),
              DropdownMenuEntry(
                  value: 'ja', label: AppLocalizations.of(context)!.japanese),
            ],
            onSelected: (value) async {
              context
                  .read<LocaleRepository>()
                  .changeLocale(locale: value ?? 'en');
            },
          ),
        )
      ],
    );
  }
}
