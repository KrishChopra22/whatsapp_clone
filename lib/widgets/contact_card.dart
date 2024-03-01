import 'package:flutter/material.dart';
import '../global_vars.dart';
import '../theme/custom_theme_extension.dart';

import '../models/user_model.dart';
import '../utils/colours.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contact,
    required this.onTap,
  });

  final UserModel contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      leading: CircleAvatar(
          backgroundColor: context.theme.greyColor!.withOpacity(.3),
          radius: 20,
          backgroundImage: null,
          child: const Icon(
            Icons.person,
            size: 30,
            color: Colors.white,
          )),
      title: Text(
        contact.uid == globalUID
            ? "${contact.userName} (You)"
            : contact.userName,
        style: const TextStyle(
          letterSpacing: 0,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: contact.uid.isNotEmpty
          ? Text(
              "Hey there! I'm using WhatsApp",
              style: TextStyle(
                color: context.theme.greyColor,
                fontWeight: FontWeight.w400,
              ),
            )
          : null,
      trailing: contact.uid.isEmpty
          ? TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                foregroundColor: Colours.greenDark,
              ),
              child: const Text('INVITE'),
            )
          : null,
    );
  }
}
