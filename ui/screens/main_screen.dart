import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mojang_nontr/core/providers/main_screen_provider.dart';
import 'package:mojang_nontr/core/resources/themes.dart';
import 'package:mojang_nontr/ui/screens/pages/penugasan_history_page.dart';
import 'package:provider/provider.dart';

import '../../core/providers/penugasan_provider.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      PenugasanProvider.refresh(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MainScreenProvider>(
        builder: (context, value, child) => IndexedStack(
          index: value.index,
          children: [
            HomePage(),
            PenugasanHistoryPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Consumer<MainScreenProvider>(
        builder: (context, value, child) => BottomNavigationBar(
          currentIndex: value.index,
          onTap: value.setIndex,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/home.png",
                width: 40,
                height: 40,
                color: value.index == 0 ? colorScheme(context).primary : colorScheme(context).onSecondary,
              ),
              label: 'Beranda',
              tooltip: "Halaman Beranda",
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme(context).primary,
                ),
                child: Image.asset(
                  value.index == 1 ? "assets/icons/work_color.png" : "assets/icons/work.png",
                  width: 40,
                  height: 40,
                ),
              ),
              label: 'Pekerjaan',
              tooltip: "Tap untuk memulai pekerjaan",
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/profile.png",
                width: 40,
                height: 40,
                color: value.index == 2 ? colorScheme(context).primary : colorScheme(context).onSecondary,
              ),
              label: 'Profil',
              tooltip: "Halaman Profil",
            ),
          ],
        ),
      ),
    );
  }
}
