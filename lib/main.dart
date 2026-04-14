import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:servana_cleaner_mobile/common/color_pallete.dart';
import 'package:servana_cleaner_mobile/common/domain/injectors/dependecy_injector.dart';
import 'package:servana_cleaner_mobile/common/domain/routes/main_router.dart';
import 'package:servana_cleaner_mobile/core/api/auth_session.dart';
import 'package:servana_cleaner_mobile/core/api/auth_token_holder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initInjector();
  final tokenHolder = dpLocator<AuthTokenHolder>();
  await AuthSessionBootstrap.restore(tokenHolder);
  runApp(MyApp(tokenHolder: tokenHolder));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.tokenHolder});

  final AuthTokenHolder tokenHolder;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router =
      MainRouter.router(authHolder: widget.tokenHolder);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Servana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorPalette.primaryColor),
        useMaterial3: true,
        timePickerTheme: TimePickerThemeData(
          backgroundColor: Colors.white,
          hourMinuteShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          hourMinuteColor: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? ColorPalette.primaryColorLight
                : Colors.grey[200]!,
          ),
          hourMinuteTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          dialHandColor: ColorPalette.primaryColorLight,
          dialBackgroundColor: Colors.grey[200],
          dayPeriodColor: WidgetStateColor.resolveWith(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return ColorPalette.primaryColorLight;
              }
              return Colors.grey[200]!;
            },
          ),
          dayPeriodTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          cancelButtonStyle: ButtonStyle(
            textStyle: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
                return const TextStyle(fontSize: 16);
              },
            ),
            foregroundColor: WidgetStateColor.resolveWith(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.blueAccent;
                }
                return Colors.black;
              },
            ),
          ),
          confirmButtonStyle: ButtonStyle(
            textStyle: WidgetStateProperty.resolveWith(
              (Set<WidgetState> states) {
                return const TextStyle(fontSize: 16);
              },
            ),
            foregroundColor: WidgetStateColor.resolveWith(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.blueAccent;
                }
                return Colors.black;
              },
            ),
          ),
        ),
      ),
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
      routerDelegate: _router.routerDelegate,
    );
  }
}
