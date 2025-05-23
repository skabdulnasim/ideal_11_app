import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/models/user_team.dart';

class TeamSelectionWidget extends StatefulWidget {
  final int matchId;
  final int? selectedTeamId;
  final ValueChanged<int?> onTeamSelected;

  TeamSelectionWidget({
    required this.matchId,
    required this.selectedTeamId,
    required this.onTeamSelected,
  });

  @override
  _TeamSelectionWidgetState createState() => _TeamSelectionWidgetState();
}

class _TeamSelectionWidgetState extends State<TeamSelectionWidget> {
  List<UserTeam> userTeams = [];
  // int? selectedTeamId;

  @override
  void initState() {
    super.initState();
    fetchUserTeams();
  }

  Future<void> fetchUserTeams() async {
    try {
      final teams = await ApiService.getUserTeams(widget.matchId);
      setState(() {
        userTeams = teams;
      });
    } catch (e) {
      // Handle error, optionally show Snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return userTeams.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Column(
          children:
              userTeams.map((team) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  elevation: 3,
                  child: RadioListTile<int>(
                    value: team.id!,
                    groupValue: widget.selectedTeamId,
                    onChanged: widget.onTeamSelected,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text("C"), Text("VC")],
                    ),
                    subtitle: Text(team.title!),
                  ),
                );
              }).toList(),
        );
  }
}
