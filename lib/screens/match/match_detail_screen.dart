import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/core/helpers.dart';
import 'package:ideal11/models/contest.dart';
import 'package:ideal11/models/match.dart';
import 'package:ideal11/screens/contest/join_contest_screen.dart';
import 'package:ideal11/screens/widgets/bottom_floating_action_bar.dart';
import 'package:ideal11/screens/widgets/header_appbar.dart';
import 'package:ideal11/screens/widgets/match_details_bottom_bar.dart';

class MatchDetailScreen extends StatefulWidget {
  final int matchId;

  MatchDetailScreen({required this.matchId});

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  late MatchModel match;
  List<dynamic> teams = [];
  List<Contest> contests = [];
  int screenSelectedIndex = 1;

  bool loading = true;
  late Timer myTimer;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    setState(() => loading = true);
    await Future.wait([fetchMatchDetails(), loadContests()]);
    if (mounted) setState(() => loading = false);
  }

  Future<void> fetchMatchDetails() async {
    try {
      final data = await ApiService.fetchMatchDetail(widget.matchId);
      if (mounted) {
        match = data['match'];
        teams = data['teams'];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadContests() async {
    try {
      contests = await ApiService.getContests(widget.matchId);
    } catch (e) {
      print(e);
    }
  }

  Widget buildTeamCard(Map<String, dynamic> team) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(team['short_title']),

        children: [
          ...team['players'].map<Widget>(
            (p) => ListTile(title: Text(p['name']), subtitle: Text(p['type'])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderAppBar(),
      floatingActionButton: Transform.translate(
        offset: Offset(0, 10), // Push it 10 pixels down into the notch
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            setState(() {
              screenSelectedIndex = 2;
            });
          }, // Or use Image.asset('assets/logo.png')
          elevation: 4,
          child: Image.asset(
            'assets/logo_only.png', // Your logo image path
            width: 36,
            height: 36,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: MatchDetailsBottomBar(
        selectedIndex: screenSelectedIndex,
        onTabSelected: (index) {
          setState(() {
            screenSelectedIndex = index;
          });
        },
      ),
      body: Stack(
        children: [
          loading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView(
                  children: [
                    Text(
                      match.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Text("${match.city}, ${match.ground}"),
                    Text(
                      Helpers().formatToIST(match.startDate, match.startTime),
                    ),
                    SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Row(
                    //     children: [
                    //       ...teams.map((t) => buildTeamCard(t)).toList(),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(
                    //       context,
                    //       '/predict-team',
                    //       arguments: {'matchId': match.id, 'teams': teams},
                    //     );
                    //   },
                    //   child: Text("Create Predict Team"),
                    // ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: contests.length,
                      itemBuilder: (ctx, i) {
                        final c = contests[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          elevation: 3,
                          child: ListTile(
                            title: Text('Prize Pool: ₹${c.prizePool}'),
                            subtitle: Text('Max: ${c.allowedSporters}'),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 233, 6, 6),
                              ),
                              child: Text(
                                "₹${c.entryFee.toInt()}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                // Implement the join functionality here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => JoinContestScreen(contest: c),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          BottomFloatingActionBar(
            // onContestsPressed: () {
            //   Navigator.pushNamed(context, '/contests', arguments: match);
            // },
            onCreateTeamPressed: () {
              Navigator.pushNamed(
                context,
                '/predict-team',
                arguments: {'matchId': match.id, 'teams': teams},
              );
            },
          ),
        ],
      ),
    );
  }
}
