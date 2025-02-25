import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//1. Providers
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

//2. Consumer
class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          final theme = ref.watch(themeNotifierProvider);
          final notifier = ref.read(themeNotifierProvider.notifier);
          return Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Thème actuel : ${theme.name}"),
              const SizedBox(height: 20),
              Switch(value: theme == AppTheme.light, onChanged: (newValue)  {
                notifier.toggle();
              } )
            ],
          );
        },
      ),
    );
  }
}

//3. StateNotifier
class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme.light) {
    load();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString("theme");
    state = (theme == null)
        ? AppTheme.light
        : (theme == "light")
            ? AppTheme.light
            : AppTheme.dark;
  }

  Future<void> save(AppTheme appTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", appTheme.name);
    state = appTheme;
  }

  void toggle() {
    state = (state == AppTheme.light) ? AppTheme.dark : AppTheme.light;
    save(state);
  }
}

enum AppTheme { light, dark }
