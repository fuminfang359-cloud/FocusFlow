import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ad_service.dart';
import 'app_state.dart';
import 'growth_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';
import 'tasks_screen.dart';
import 'timer_screen.dart';
import 'ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final state = await AppState.load();
  runApp(FocusFlowApp(state: state));
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: ValueListenableBuilder<bool>(
        valueListenable: state.darkNotifier,
        builder: (context, dark, _) => MaterialApp(
          title: 'FocusFlow',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(false),
          darkTheme: buildTheme(true),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: HomeShell(state: state),
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.state});
  final AppState state;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _pages = <Widget>[
    TimerScreen(),
    TasksScreen(),
    StatsScreen(),
    GrowthScreen(),
    SettingsScreen(),
  ];

  int _index = 0;
  StreamSubscription<String>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.state.events.listen(_onEvent);
  }

  void _onEvent(String message) {
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(child: _pages[_index]),
            AdBanner(adsRemoved: s.settings.adsRemoved),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.timer_outlined),
              selectedIcon: Icon(Icons.timer),
              label: '专注'),
          NavigationDestination(
              icon: Icon(Icons.checklist), label: '任务'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: '统计'),
          NavigationDestination(
              icon: Icon(Icons.emoji_events_outlined),
              selectedIcon: Icon(Icons.emoji_events),
              label: '成长'),
          NavigationDestination(
              icon: Icon(Icons.tune), label: '设置'),
        ],
      ),
    );
  }
}
