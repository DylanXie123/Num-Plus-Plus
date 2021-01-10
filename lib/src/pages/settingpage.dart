import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setting',
        ),
      ),
      body: ListView(
        itemExtent: 60.0,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        children: <Widget>[
          ListTile(
            leading: Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListTile(
            leading: Icon(MaterialCommunityIcons.getIconData("github-circle")),
            title: Text('Github'),
            onTap: () {
              _launchURL('https://github.com/DylanXie123/Num-Plus-Plus');
            },
          ),
          ListTile(
            leading: Icon(
              MaterialCommunityIcons.getIconData("email-edit-outline"),
            ),
            title: Text('Email'),
            onTap: () {
              _launchURL('mailto:dylanxie123@outlook.com?subject=num%2b%2b');
            },
          ),
          ListTile(
            leading: Icon(
              AntDesign.getIconData("alipay-circle"),
            ),
            title: Text('Donation'),
            onTap: () {
              _launchURL(
                  'alipayqr://platformapi/startapp?saId=10000007&qrcode=https://qr.alipay.com/tsx06831xbzn79nimg64e6a');
            },
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SettingModel {
  bool hideKeyboard = false;
  Completer loading = Completer();

  SettingModel() {
    initVal();
  }

  Future changeKeyboardMode(bool mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hideKeyboard = mode;
    prefs.setBool('hideKeyboard', hideKeyboard);
  }

  Future initVal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hideKeyboard = prefs.getBool('hideKeyboard') ?? false;
    loading.complete();
  }
}
