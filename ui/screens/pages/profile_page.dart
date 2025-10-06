import 'package:flutter/material.dart';
import 'package:mojang_nontr/ui/components/custom_divider.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';
import '../../components/profile_pricture.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text("Profile"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        Expanded(
          child: Consumer<UserProvider>(
            builder: (context, provider, child) => RefreshIndicator(
              onRefresh: () => UserProvider.refresh(context),
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Center(child: ProfilePicture(size: 186)),
                  ColumnDivider(space: 40),
                  ListTile(title: Text("Nama Lengkap"), subtitle: Text(provider.user.nama ?? "-")),
                  ColumnDivider(space: 5),
                  ListTile(title: Text("NIK"), subtitle: Text(provider.user.nik ?? "-")),
                  ColumnDivider(space: 5),
                  ListTile(title: Text("Nama Badan Usaha"), subtitle: Text(provider.user.namaBadanUsaha ?? "-")),
                  ColumnDivider(space: 5),
                  ListTile(title: Text("Jabatan"), subtitle: Text(provider.user.jabatan ?? "-")),
                  ColumnDivider(space: 5),
                  ListTile(title: Text("Layanan"), subtitle: Text(provider.auth!.service)),
                  ColumnDivider(space: 30),
                  ListTile(
                    title: Text("Logout"),
                    leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                    textColor: Theme.of(context).colorScheme.error,
                    onTap: () => UserProvider.logout(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
