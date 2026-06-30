import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/map.dart';
import 'screens/bookmarks.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'screens/splash.dart';

final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier<bool>(false);
final String _themeKey = 'is_dark_mode';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadTheme(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          isDarkModeNotifier.value = snapshot.data!;
        }
        return ValueListenableBuilder<bool>(
          valueListenable: isDarkModeNotifier,
          builder: (context, isDarkMode, child) {
            return MaterialApp(
              title: 'Map Navigator',
              theme: ThemeData(
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
              ),
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.amber,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
              ),
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              home: const SplashScreen(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }

  Future<bool> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_themeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> saveTheme(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDark);
    } catch (e) {
      debugPrint('Ошибка сохранения темы: $e');
    }
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    Map(),
    Bookmarks(),
    Home(),
    Profile(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[700],
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Карта',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Метки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),
    );
  }
}