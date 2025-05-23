import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/models/user_team.dart';
import 'package:ideal11/models/user_team_player.dart';
import 'package:ideal11/screens/predict_team/captain_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PredictTeamScreen extends StatefulWidget {
  final int matchId;
  final List teams;

  PredictTeamScreen({required this.matchId, required this.teams});

  @override
  _PredictTeamScreenState createState() => _PredictTeamScreenState();
}

class _PredictTeamScreenState extends State<PredictTeamScreen> {
  List<Map<String, dynamic>> selectedPlayers = [];
  bool loading = false;

  int maxPlayers = 11;

  int batterCount = 0, bowlerCount = 0, allrounderCount = 0, wkCount = 0;

  bool isValid = true;
  String validationMessage = '';

  Map<String, dynamic>? selectedCaptain;
  Map<String, dynamic>? selectedViceCaptain;

  void selectPlayer(Map<String, dynamic> player) {
    if (selectedPlayers.length < maxPlayers) {
      selectedPlayers.add(player);
      updateValidation();
    }
  }

  void removePlayer(Map<String, dynamic> player) {
    selectedPlayers.removeWhere((p) => p['id'] == player['id']);
    updateValidation();
  }

  void updateValidation() {
    batterCount =
        selectedPlayers
            .where((p) => p['type'].toLowerCase() == 'batter')
            .length;
    bowlerCount =
        selectedPlayers
            .where((p) => p['type'].toLowerCase() == 'bowler')
            .length;
    allrounderCount =
        selectedPlayers
            .where((p) => p['type'].toLowerCase().contains('allrounder'))
            .length;
    wkCount =
        selectedPlayers
            .where((p) => p['type'].toLowerCase().contains('wk'))
            .length;

    isValid =
        batterCount >= 3 &&
        bowlerCount >= 3 &&
        wkCount >= 1 &&
        selectedPlayers.length == maxPlayers;

    validationMessage =
        isValid
            ? 'Your team is valid!'
            : 'Select 3 batters, 3 bowlers, and 1 wicketkeeper. Total: 11 players';
    setState(() {});
  }

  Widget buildPlayerCard(Map<String, dynamic> player) {
    bool isSelected = selectedPlayers.any((p) => p['id'] == player['id']);
    return Card(
      child: ListTile(
        title: Text(player['name']),
        subtitle: Text(player['type']),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.check_circle_outline,
        ),
        onTap: () {
          if (isSelected) {
            removePlayer(player);
          } else {
            selectPlayer(player);
          }
        },
      ),
    );
  }

  List getFilteredPlayers(String category) {
    final players = widget.teams.expand((team) => team['players']).toList();
    return players.where((p) {
      final type = p['type'].toString().toLowerCase();
      switch (category) {
        case 'WKs':
          return type.contains('wk');
        case 'BATTERs':
          return type == 'batter';
        case 'ARs':
          return type.contains('allrounder');
        case 'BOWLERs':
          return type == 'bowler';
        default:
          return false;
      }
    }).toList();
  }

  void goToCaptainSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CaptainSelectionScreen(
              players: selectedPlayers,
              onSave: (captain, viceCaptain) => saveTeam(captain, viceCaptain),
            ),
      ),
    );
  }

  void saveTeam(
    Map<String, dynamic> captain,
    Map<String, dynamic> viceCaptain,
  ) async {
    setState(() => loading = true);
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId')!;

    final team = UserTeam(
      userId: userId,
      matchId: widget.matchId,
      players:
          selectedPlayers
              .map(
                (p) => UserTeamPlayer(
                  matchTeamPlayerId: p['match_team_player_id'],
                  isCaptain: p['id'] == captain['id'],
                  isViceCaptain: p['id'] == viceCaptain['id'],
                ),
              )
              .toList(),
    );

    try {
      await ApiService.createUserTeam(team);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Team saved successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select Your Team"),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "WKs"),
              Tab(text: "BATTERs"),
              Tab(text: "ARs"),
              Tab(text: "BOWLERs"),
            ],
          ),
        ),
        body:
            loading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select 11 players for match: ${widget.matchId}',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        validationMessage,
                        style: TextStyle(
                          color: isValid ? Colors.green : Colors.red,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: TabBarView(
                          children:
                              ['WKs', 'BATTERs', 'ARs', 'BOWLERs'].map((
                                category,
                              ) {
                                final players = getFilteredPlayers(category);
                                return ListView(
                                  children:
                                      players
                                          .map(
                                            (player) => buildPlayerCard(player),
                                          )
                                          .toList(),
                                );
                              }).toList(),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: isValid ? goToCaptainSelection : null,
                        child: Text("Next"),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
