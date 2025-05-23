import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/core/helpers.dart';
import 'package:ideal11/models/match.dart';
import 'package:ideal11/screens/widgets/dashboard_bottom_bar.dart';
import 'package:ideal11/screens/widgets/header_appbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String matchType = 'upcoming';
  List<MatchModel> matches = [];
  bool loading = true;
  int screenSelectedIndex = 1;

  @override
  void initState() {
    super.initState();
    fetchMatchList();
  }

  Future<void> fetchMatchList() async {
    setState(() => loading = true);
    matches = await ApiService.fetchMatches(matchType);
    setState(() => loading = false);
  }

  Future<void> fetchProcessingMyMatchList() async {
    setState(() => loading = true);
    matches = await ApiService.fetchProcessingMatches();
    setState(() => loading = false);
  }

  Future<void> fetchFnishedMyMatchList() async {
    setState(() => loading = true);
    matches = await ApiService.fetchFinishedMatches();
    setState(() => loading = false);
  }

  Widget buildMatchCard(MatchModel match) {
    return Card(
      child: ListTile(
        title: Text(match.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${match.city}, ${match.ground}"),
            Text(Helpers().formatToIST(match.startDate, match.startTime)),
          ],
        ),
        trailing: Text(
          match.state.toUpperCase(),
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/match/${match.id}',
          ); // will handle later
        },
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
      bottomNavigationBar: DashboardBottomBar(
        selectedIndex: screenSelectedIndex,
        onTabSelected: (index) {
          setState(() {
            screenSelectedIndex = index;
          });
        },
      ),
      body: Column(
        children: [
          SizedBox(
            child: ToggleButtons(
              isSelected:
                  [
                    'processing',
                    'upcoming',
                    'completed',
                  ].map((e) => e == matchType).toList(),
              onPressed: (index) {
                setState(() {
                  matchType = ['processing', 'upcoming', 'completed'][index];
                });
                if (matchType == 'upcoming') {
                  fetchMatchList();
                } else if (matchType == 'processing') {
                  fetchProcessingMyMatchList();
                } else if (matchType == 'completed') {
                  fetchFnishedMyMatchList();
                }
              },
              constraints: BoxConstraints.expand(
                width:
                    (MediaQuery.of(context).size.width - 32) /
                    3, // Adjust 32 if you have horizontal padding
                height: 30,
              ),
              children: [
                Text("My Contest"),
                Text("Upcoming"),
                Text("Completed"),
              ],
            ),
          ),
          Expanded(
            child:
                loading
                    ? Center(child: CircularProgressIndicator())
                    : matches.isEmpty
                    ? Center(child: Text("No matches found"))
                    : ListView.builder(
                      itemCount: matches.length,
                      itemBuilder: (_, i) => buildMatchCard(matches[i]),
                    ),
          ),
        ],
      ),
    );
  }
}
