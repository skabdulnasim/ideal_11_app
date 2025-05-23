import 'package:flutter/material.dart';
import 'package:ideal11/screens/login/splash_screen.dart';
import 'package:ideal11/routes/routes.dart';
import 'package:ideal11/screens/match/match_detail_screen.dart';
import 'package:ideal11/screens/predict_team/predict_team_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IDEAL 11',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: SplashScreen(), // will create later
      routes: appRoutes, // ✅ Add this line
      onGenerateRoute: (settings) {
        if (settings.name!.startsWith('/match/')) {
          final matchId = int.parse(settings.name!.split('/').last);
          return MaterialPageRoute(
            builder: (_) => MatchDetailScreen(matchId: matchId),
          );
        }

        if (settings.name!.startsWith('/predict-team')) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder:
                (_) => PredictTeamScreen(
                  matchId: args['matchId'],
                  teams: args['teams'],
                ),
          );
        }
        // more routes...
      },
    );
  }
}
