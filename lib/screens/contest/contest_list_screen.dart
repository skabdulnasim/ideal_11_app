import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/models/contest.dart';
import 'package:ideal11/screens/contest/join_contest_screen.dart';

class ContestListScreen extends StatefulWidget {
  final int matchId;

  const ContestListScreen({required this.matchId});

  @override
  _ContestListScreenState createState() => _ContestListScreenState();
}

class _ContestListScreenState extends State<ContestListScreen> {
  List<Contest> contests = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadContests();
  }

  void loadContests() async {
    try {
      contests = await ApiService.getContests(widget.matchId);
    } catch (e) {
      print(e);
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contests')),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: contests.length,
                itemBuilder: (ctx, i) {
                  final c = contests[i];
                  return ListTile(
                    title: Text('Prize Pool: ₹${c.prizePool}'),
                    subtitle: Text(
                      'Entry Fee: ₹${c.entryFee} | Max: ${c.allowedSporters}',
                    ),
                    trailing: ElevatedButton(
                      child: Text("Join"),
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JoinContestScreen(contest: c),
                            ),
                          ),
                    ),
                  );
                },
              ),
    );
  }
}
