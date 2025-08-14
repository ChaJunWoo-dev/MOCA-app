import 'package:flutter/material.dart';
import 'package:prob/provider/signup/categories_provider.dart';
import 'package:prob/provider/signup/email_provider.dart';
import 'package:prob/provider/signup/nickname_provider.dart';
import 'package:prob/provider/signup/passwd_provider.dart';
import 'package:prob/provider/signup/signup_provider.dart';
import 'package:provider/provider.dart';

class Reset {
  static void resetproviders(BuildContext context) {
    final emailProvider = context.read<EmailProvider>();
    final passwdProvider = context.read<PasswdProvider>();
    final nicknameProvider = context.read<NicknameProvider>();
    final categoriesProvider = context.read<CategoriesProvider>();
    final signupProvider = context.read<SignupProvider>();

    emailProvider.reset();
    passwdProvider.reset();
    nicknameProvider.reset();
    categoriesProvider.reset();
    signupProvider.reset();
  }
}
