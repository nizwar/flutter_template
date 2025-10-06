import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mojang_nontr/core/providers/main_screen_provider.dart';
import 'package:mojang_nontr/core/providers/penugasan_provider.dart';
import 'package:mojang_nontr/core/providers/user_provider.dart';
import 'package:mojang_nontr/core/resources/themes.dart';
import 'package:mojang_nontr/core/utils/utils.dart';
import 'package:mojang_nontr/ui/components/custom_divider.dart';
import 'package:mojang_nontr/ui/components/profile_pricture.dart';
import 'package:provider/provider.dart';

import '../../components/penugasan_card.dart';
import '../penugasan/penugasan_list_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          _profileSection(context),
          ColumnDivider(space: 20),
          _taskSummarySection(context),
          ColumnDivider(space: 15),
          _taskSection(context),
        ],
      ),
    );
  }

  Widget _taskSummarySection(BuildContext context) {
    Widget cardBuilder(String title, String? value, String icon) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10).copyWith(bottom: 20),
        decoration: BoxDecoration(color: colorScheme(context).secondaryContainer, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(alignment: Alignment.centerRight, child: Image.asset(icon, width: 25, height: 25)),
            if (value != null)
              Text(
                value,
                style: textTheme(context).headlineMedium?.copyWith(color: colorScheme(context).onSecondaryContainer, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            else
              Container(
                height: 40,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ColumnDivider(),
            Text(
              title,
              style: textTheme(context).bodySmall?.copyWith(color: colorScheme(context).onSecondaryContainer, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Consumer<PenugasanProvider>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Dashboard", style: textTheme(context).titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ColumnDivider(),
          Row(
            spacing: 20,
            children: [
              cardBuilder("Penugasan Baru", !value.isLoading ? value.penugasanBaru.length.toString() : null, "assets/icons/flash.png"),
              cardBuilder("Penugasan Selesai", !value.isLoading ? value.penugasanSelesai.length.toString() : null, "assets/icons/success_badge.png"),
            ].map((item) => Expanded(child: item)).toList(),
          )
        ],
      ),
    );
  }

  Widget _taskSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(child: Text("Penugasan Instalasi", style: textTheme(context).titleSmall?.copyWith(fontWeight: FontWeight.bold))),
            TextButton(onPressed: () => _onLihatSemuaPenugasanClicked(context), child: Text("Lihat Semua", style: textTheme(context).bodySmall?.copyWith(fontWeight: FontWeight.bold))),
          ],
        ),
        ColumnDivider(),
        Consumer<PenugasanProvider>(
          builder: (context, value, child) {
            if (value.penugasanBaru.isNotEmpty) {
              return PenugasanCard(value.penugasanBaru.first);
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  Widget _profileSection(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Consumer<UserProvider>(
        builder: (context, provider, child) => Text("Hi, ${provider.user.nama}", style: textTheme(context).titleSmall?.copyWith(fontWeight: FontWeight.bold)),
      ),
      subtitle: Text("Have a nice day!", style: textTheme(context).bodySmall),
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => MainScreenProvider.read(context).setIndex(2),
        child: ProfilePicture(size: 50, borderWidth: 1),
      ),
    );
  }

  void _onLihatSemuaPenugasanClicked(BuildContext context) {
    startScreen(context, PenugasanListScreen());
  }
}
