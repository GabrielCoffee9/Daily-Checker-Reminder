import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'data/repositories/date_format_repository.dart';
import 'data/repositories/local_storage_repository.dart';
import 'data/repositories/locale_repository.dart';
import 'data/repositories/theme_repository.dart';
import 'ui/calendar/view_model/calendar_view_model.dart';
import 'ui/calendar/widgets/calendar_screen.dart';
import 'ui/home/view_model/home_view_model.dart';
import 'ui/home/widgets/add_item_dialog.dart';
import 'ui/home/widgets/home_screen.dart';
import 'ui/settings/view_model/settings_view_model.dart';
import 'ui/settings/widgets/settings_screen.dart';

class DailyCheckerReminder extends StatefulWidget {
  const DailyCheckerReminder({super.key});

  @override
  State<DailyCheckerReminder> createState() => _DailyCheckerReminderState();
}

class _DailyCheckerReminderState extends State<DailyCheckerReminder> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => LocalStorageRepository()),
        ChangeNotifierProvider(create: (context) => ThemeRepository()),
        ChangeNotifierProvider(create: (context) => LocaleRepository()),
        ChangeNotifierProvider(create: (context) => DateFormatRepository()),
        ChangeNotifierProvider(
            create: (context) =>
                HomeViewModel(localStorageRepository: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                CalendarViewModel(localStorageRepository: context.read())),
        ChangeNotifierProvider(
            create: (context) =>
                SettingsViewModel(localStorageRepository: context.read())),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Daily Checker Reminder',
          theme: ThemeData(
            textTheme: GoogleFonts.notoSerifTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: context.watch<ThemeRepository>().themeSeedColor,
            ),
            useMaterial3: true,
          ),
          locale: context.watch<LocaleRepository>().currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppWidget(),
        );
      }),
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      context.read<HomeViewModel>().load.execute();

      context
          .read<CalendarViewModel>()
          .onChangedSelectedDay
          .execute(DateTime.now());

      context.read<CalendarViewModel>().onSelected.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 600) return MediumApp();

      return SmallApp();
    });
  }
}

class MediumApp extends StatefulWidget {
  const MediumApp({super.key});

  @override
  State<MediumApp> createState() => _MediumAppState();
}

class _MediumAppState extends State<MediumApp> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(viewModel: context.read()),
      CalendarScreen(viewModel: context.read()),
    ];
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            labelType: MediaQuery.sizeOf(context).width < 300
                ? NavigationRailLabelType.all
                : NavigationRailLabelType.none,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        viewModel: context.read(),
                      ),
                    ));
              },
              icon: const Icon(Icons.settings),
            ),
            destinations: [
              NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text(AppLocalizations.of(context)!.today)),
              NavigationRailDestination(
                  icon: Icon(Icons.calendar_today),
                  label: Text(AppLocalizations.of(context)!.all_days))
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(
                top: 40.0, left: 32.0, right: 32.0, bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: pages[selectedIndex],
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (MediaQuery.sizeOf(context).height > 400) {
            showDialog(
              context: context,
              builder: (context) => AddItemDialog(
                onItemAdded: (item) async {
                  context.read<HomeViewModel>().addItem.execute(item);
                },
              ),
            );
          } else {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) => SingleChildScrollView(
                child: AddItemDialog(
                  onItemAdded: (item) async {
                    context.read<HomeViewModel>().addItem.execute(item);
                  },
                ),
              ),
            );
          }
        },
        label: Text(AppLocalizations.of(context)!.add),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class SmallApp extends StatelessWidget {
  const SmallApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Daily Checker'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        viewModel: context.read(),
                      ),
                    ));
              },
              icon: const Icon(Icons.settings),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                  text: AppLocalizations.of(context)!.today,
                  icon: Icon(Icons.home)),
              Tab(
                  text: AppLocalizations.of(context)!.all_days,
                  icon: Icon(Icons.calendar_today)),
            ],
          ),
        ),
        body: TabBarView(children: [
          HomeScreen(viewModel: context.read()),
          CalendarScreen(viewModel: context.read()),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddItemDialog(
                onItemAdded: (item) async {
                  context.read<HomeViewModel>().addItem.execute(item);
                },
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
