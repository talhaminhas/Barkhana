import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterrestaurant/api/ps_api_service.dart';
import 'package:flutterrestaurant/constant/ps_constants.dart';
import 'package:flutterrestaurant/ui/dashboard/core/drawer_view.dart';
import 'package:flutterrestaurant/utils/utils.dart';
import 'package:flutterrestaurant/viewobject/api_token.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/route_paths.dart';
import '../db/common/ps_shared_preferences.dart';
import '../provider/app_info/app_info_provider.dart';
import '../ui/common/dialog/error_dialog.dart';
import '../ui/common/ps_toast.dart';
import 'common/ps_resource.dart';

class ApiTokenRefresher  extends WidgetsBindingObserver{
  ApiTokenRefresher({required PsApiService psApiService}) {
    _psApiService = psApiService;
    _init();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      updateToken();
    }
  }
  late PsApiService _psApiService;
  Timer? timer;
  BuildContext? context;
  AppInfoProvider? provider;
  bool isExpired = true;

  Future<void> updateToken() async {

    //print('updated token called');
    //print('api token old: ${PsSharedPreferences.instance.getApiToken()}');

    ApiToken? responseToken;
    if (PsSharedPreferences.instance.getApiToken() == null)
      {
        responseToken = await getApiToken(PsConst.API_GUEST_EMAIL, PsConst.API_GUEST_PASSWORD);
      }
    else {
      responseToken = await _refreshApiToken();
    }

    if(responseToken != null) {
      //print(responseToken.expired);
      //print(responseToken.expiry);
      if (responseToken?.expired == 'true' && Utils.isUserLoggedIn(context!)) {
          callLogout(
              provider!,
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context!);
      }
      PsSharedPreferences.instance.replaceApiToken(responseToken.token!);
      isExpired = false;
      _resetTimer(PsConst.API_TOKEN_UPDATE_DURATION);
      print('token updated');
      //print('api token new: ${PsSharedPreferences.instance.getApiToken()}');
    }
    else{
      print('failed to update retrying');
      _resetTimer(10);
    }

  }
  dynamic callLogout(
      AppInfoProvider appInfoProvider, int index, BuildContext context) async {
    // updateSelectedIndex( index);
    await appInfoProvider.replaceLoginUserId('');
    await appInfoProvider.replaceLoginUserName('');
    await FirebaseAuth.instance.signOut();
    if(dashboardViewKey.currentState != null) {
      Navigator.of(context).popUntil((route) =>
      route.settings.name == RoutePaths.home);
      dashboardViewKey.currentState?.updateSelectedIndexWithAnimation(
          Utils.getString(context, 'home__drawer_menu_menu'),
          PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
    }
    PsToast().showToast(Utils.getString(context!, 'user_logged__out'));
  }

  Future<dynamic> getApiToken(String email, String password) async {

    if (await Utils.checkInternetConnectivity()) {
      final Map<String, dynamic> jsonMap = <String, dynamic>{};
      jsonMap['user_email'] = email;
      jsonMap['user_password'] = password;

      final PsResource<ApiToken> apiTokenResource = await _psApiService
          .getApiToken(jsonMap);
      return apiTokenResource.data;
    }
    PsToast().showToast(Utils.getString(context!, 'error_dialog__no_internet'));
    return null;
  }
  Future<dynamic> _refreshApiToken() async {
    if (await Utils.checkInternetConnectivity()) {
      final Map<String, dynamic> jsonMap = <String, dynamic>{};
      jsonMap['user_token'] = PsSharedPreferences.instance.getApiToken();
      final PsResource<ApiToken> apiTokenResource = await _psApiService
          .updateApiToken(jsonMap);
      return apiTokenResource.data;
    }
    PsToast().showToast(Utils.getString(context!, 'error_dialog__no_internet'));
    return null;
  }
  void onLoginSuccess(){}
  void _init() {

  }

  void _resetTimer(int duration) {
    timer?.cancel();
    timer = Timer(Duration(seconds: duration), (){
      print('timer expired');
      isExpired = true;
      updateToken();
    });
  }

  void dispose() {
    timer?.cancel();
  }
}