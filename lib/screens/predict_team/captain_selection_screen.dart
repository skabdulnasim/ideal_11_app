import 'package:flutter/material.dart';

class CaptainSelectionScreen extends StatefulWidget {
  final List<Map<String, dynamic>> players;
  final void Function(
    Map<String, dynamic> captain,
    Map<String, dynamic> viceCaptain,
  )
  onSave;

  const CaptainSelectionScreen({required this.players, required this.onSave});

  @override
  _CaptainSelectionScreenState createState() => _CaptainSelectionScreenState();
}

class _CaptainSelectionScreenState extends State<CaptainSelectionScreen> {
  Map<String, dynamic>? captain;
  Map<String, dynamic>? viceCaptain;

  // Group players by role
  Map<String, List<Map<String, dynamic>>> _groupPlayersByRole() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var player in widget.players) {
      final role = player['type'] ?? 'Others';
      if (!grouped.containsKey(role)) {
        grouped[role] = [];
      }
      grouped[role]!.add(player);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedPlayers = _groupPlayersByRole();

    return Scaffold(
      appBar: AppBar(title: Text("Select Captain & Vice-Captain")),
      body: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "Player",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    "C",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    "Vc",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children:
                  groupedPlayers.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 6,
                          ),
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                        ...entry.value.map((player) {
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(child: Text(player['name'])),
                                SizedBox(
                                  width: 60,
                                  child: Radio<Map<String, dynamic>>(
                                    value: player,
                                    groupValue: captain,
                                    onChanged:
                                        (value) =>
                                            setState(() => captain = value),
                                  ),
                                ),
                                SizedBox(
                                  width: 60,
                                  child: Radio<Map<String, dynamic>>(
                                    value: player,
                                    groupValue: viceCaptain,
                                    onChanged:
                                        (value) =>
                                            setState(() => viceCaptain = value),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed:
                  captain != null && viceCaptain != null
                      ? () {
                        widget.onSave(captain!, viceCaptain!);
                        Navigator.pop(context);
                      }
                      : null,
              child: Text("Save Team"),
            ),
          ),
        ],
      ),
    );
  }
}
