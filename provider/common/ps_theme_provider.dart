import 'package:flutter/material.dart';
import 'package:flutterrestaurant/provider/common/ps_provider.dart';
import 'package:flutterrestaurant/repository/ps_theme_repository.dart';

class PsThemeProvider extends PsProvider {
  PsThemeProvider({required PsThemeRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
  }
 late  PsThemeRepository _repo;

  Future<dynamic> updateTheme(bool isDarkTheme) {
    return _repo.updateTheme(isDarkTheme);
  }

  ThemeData getTheme() {
    return _repo.getTheme();
  }
}
