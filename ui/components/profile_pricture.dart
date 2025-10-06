import 'package:flutter/material.dart';
import 'package:mojang_nontr/core/resources/themes.dart';
import 'package:provider/provider.dart';

import '../../core/providers/user_provider.dart';

class ProfilePicture extends StatelessWidget {
  final double size;
  final double borderWidth;
  const ProfilePicture({
    this.size = 100,
    this.borderWidth = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, provider, child) => Container(
        width: size,
        height: size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: borderWidth)),
        padding: EdgeInsets.all(borderWidth + 3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.network(
            "${provider.user.foto}",
            fit: BoxFit.cover,
            errorBuilder: (context, e, s) {
              return Icon(Icons.person, size: 100, color: colorScheme(context).onSurfaceVariant);
            },
          ),
        ),
      ),
    );
  }
}
