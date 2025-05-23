import 'package:flutter/material.dart';
import 'package:ideal11/screens/dashboard/dashboard_screen.dart';
import 'package:ideal11/screens/profile/profile_info_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/profile-info': (context) => ProfileInfoScreen(),
  '/dashboard': (context) => DashboardScreen(),
};
