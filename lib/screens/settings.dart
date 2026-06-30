import 'package:flutter/material.dart';
import '../main.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Внешний вид',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.amber[700],
            ),
            title: const Text('Тёмная тема'),
            subtitle: Text(
              isDarkMode ? 'Включена' : 'Выключена',
              style: TextStyle(
                color: isDarkMode ? Colors.amber[700] : Colors.grey,
              ),
            ),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                isDarkModeNotifier.value = value;
              },
              activeColor: Colors.amber[700],
              activeTrackColor: Colors.amber[200],
            ),
            onTap: () {
              isDarkModeNotifier.value = !isDarkMode;
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                isDarkModeNotifier.value = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Тема сброшена на светлую'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              icon: Icon(Icons.refresh, color: Colors.amber[700]),
              label: const Text('Сбросить на светлую тему'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),

          const Divider(height: 32),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Другие настройки',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.language, color: Colors.amber[700]),
            title: const Text('Язык'),
            subtitle: const Text('Русский'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber[700]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Выбор языка в разработке')),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.notifications, color: Colors.amber[700]),
            title: const Text('Уведомления'),
            subtitle: const Text('Включены'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber[700]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки уведомлений в разработке')),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.volume_up, color: Colors.amber[700]),
            title: const Text('Звук'),
            subtitle: const Text('Включён'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber[700]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Настройки звука в разработке')),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.info, color: Colors.amber[700]),
            title: const Text('О приложении'),
            subtitle: const Text('Версия 1.0.0'),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.amber[700]),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('О приложении'),
                    content: const Text(
                      'Версия: 1.0.0\n'
                      'Разработчик: https://github.com/festW099\n'
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Закрыть'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}