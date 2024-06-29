import 'package:cleanercms/model/menu_model.dart';
import 'package:flutter/material.dart';


class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.person, title: 'Users'),
    MenuModel(icon: Icons.report, title: 'Reports'),
    MenuModel(icon: Icons.chat_bubble, title: 'Community'),
    MenuModel(icon: Icons.local_shipping, title: 'Pickup Requests'),
    MenuModel(icon: Icons.calendar_month, title: 'Schedule'),
    MenuModel(icon: Icons.logout, title: 'SignOut'),
  ];
}