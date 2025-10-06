import 'package:flutter/material.dart';
import 'package:mojang_nontr/core/providers/user_provider.dart';
import 'package:mojang_nontr/core/resources/themes.dart';
import 'package:mojang_nontr/core/utils/extensions.dart';
import 'package:mojang_nontr/core/utils/utils.dart';
import 'package:mojang_nontr/ui/components/custom_card.dart';
import 'package:mojang_nontr/ui/components/custom_divider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController nikController = TextEditingController(text: "6171051407930011");
  final TextEditingController passwordController = TextEditingController(text: "bypass@123");
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Image.asset("assets/icons/app_logo.png", height: 200),
                  ColumnDivider(space: 30),
                  CustomCard(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Mojang", textAlign: TextAlign.center, style: textTheme(context).headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ColumnDivider(space: 10),
                        Text("Hai Tenaga Teknik, gunakan akun yang terdaftar di SIUJANG GATRIK", style: textTheme(context).bodyMedium, textAlign: TextAlign.center),
                        ColumnDivider(space: 20),
                        TextField(
                          controller: nikController,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(hintText: "NIK"),
                        ),
                        ColumnDivider(space: 20),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(hintText: "Password"),
                          obscureText: true,
                        ),
                        ColumnDivider(space: 30),
                        ElevatedButton(
                          onPressed: () => _onSendClicked(context),
                          style: ElevatedButton.styleFrom(elevation: 5),
                          child: Text("Kirim", style: textTheme(context).bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme(context).primary)),
                        ),
                        ColumnDivider(space: 30),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme(context).secondary),
                            borderRadius: BorderRadius.circular(15),
                            color: colorScheme(context).primary.withValues(alpha: .1),
                          ),
                          child: Text("Catatan:\nMobile Ujang hanya diperuntukan bagi Tenaga Teknik Lembaga Inspeksi Teknik IPTL Non TR & Badan Usaha Pembangunan dan Pemasangan IPTL  Non TR"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final info = snapshot.data!;
                      return Text("Ver. ${info.version}", style: textTheme(context).bodyLarge);
                    }
                    return SizedBox.shrink();
                  }),
            )
          ],
        ),
      ),
    ).dismissKeyboardOnTap(context);
  }

  void _onSendClicked(BuildContext context) {
    UserProvider.login(context, nikController.text, passwordController.text).catchError((e) {
      showErrorSnackbar(context, e.toString());
      return false;
    }).showProgress(context);
  }
}
