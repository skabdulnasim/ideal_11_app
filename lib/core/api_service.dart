import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ideal11/models/contest.dart';
import 'package:ideal11/models/contest_prize.dart';
import 'package:ideal11/models/match.dart';
import 'package:ideal11/models/user_team.dart';
import 'package:ideal11/models/wallets_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ideal11/core/constants.dart';

class ApiService {
  static Future<bool> sendOtp(String mobile) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/request_otp'),
      body: jsonEncode({'mobile': mobile}),
      headers: jsonHeaders(null),
    );
    return res.statusCode == 200;
  }

  static Future<bool> verifyOtp(String mobile, String otp) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/verify_otp'),
      body: jsonEncode({'mobile': mobile, 'otp': otp}),
      headers: jsonHeaders(null),
    );

    if (res.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(res.body);
      await prefs.setString('token', data['token']);
      await prefs.setInt('userId', data['user']['id']);
      return true;
    }
    return false;
  }

  static Future<bool> updateProfile({
    required String name,
    required String gender,
    required String dob,
    required String city,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    final res = await http.post(
      Uri.parse('$baseUrl/users/$userId/save_profile'),
      body: jsonEncode({
        'name': name,
        'gender': gender,
        'dob': dob,
        'city': city,
      }),
      headers: jsonHeaders(token),
    );
    return res.statusCode == 200;
  }

  static Future<List<MatchModel>> fetchMatches(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse(
        '$baseUrl/matches?state=$type',
      ), // state: live/upcoming/completed
      headers: jsonHeaders(token),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['matches'] as List)
          .map((e) => MatchModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<List<MatchModel>> fetchProcessingMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/matches/user_processing_matches'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['matches'] as List)
          .map((e) => MatchModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<List<MatchModel>> fetchFinishedMatches() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/matches/user_finished_matches'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['matches'] as List)
          .map((e) => MatchModel.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<Map<String, dynamic>> fetchMatchDetail(int matchId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/matches/$matchId'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return {
        'match': MatchModel.fromJson(data['match']),
        'teams': data['teams'],
      };
    }
    throw Exception("Failed to load match detail");
  }

  static Future<void> createUserTeam(UserTeam team) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.post(
      Uri.parse('$baseUrl/user_teams'),
      headers: jsonHeaders(token),
      body: jsonEncode(team.toJson()),
    );
    print(res.statusCode);
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Team creation failed: ${res.body}");
    }
  }

  static Future<void> updateUserTeam(int id, UserTeam team) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.put(
      Uri.parse('$baseUrl/user_teams/$id'),
      headers: jsonHeaders(token),
      body: jsonEncode(team.toJson()),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Team update failed: ${res.body}");
    }
  }

  static Future<List<Contest>> getContests(int matchId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/contests?match_id=$matchId'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load contests');
    }

    final dynamic response = jsonDecode(res.body);

    // Ensure 'data' is a List and map each to Contest
    final List<dynamic> dataList = response['data'];
    return dataList.map<Contest>((json) => Contest.fromJson(json)).toList();
  }

  static Future<List<ContestPrize>> getContestPrizes(int contestId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/contests/$contestId'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load prizes');
    }

    final dynamic response = jsonDecode(res.body);
    final List<dynamic> dataList = response['data']['contest_prizes'];
    return dataList
        .map<ContestPrize>((json) => ContestPrize.fromJson(json))
        .toList();
  }

  static Future<String> createRazorpayOrder(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.post(
      Uri.parse('$baseUrl/razorpay_orders'),
      headers: jsonHeaders(token),
      body: jsonEncode({'paisa': amount}),
    );
    print(res.statusCode);
    final data = jsonDecode(res.body);
    return data['order_id'];
  }

  static Future<String> getWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/wallets/balance'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load contests');
    }

    final dynamic response = jsonDecode(res.body);

    final String balance = response['balance'];
    return balance;
  }

  static Future<bool> joinContest(int contestId, int userTeamId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.post(
      Uri.parse('$baseUrl/user_teams/$userTeamId/join_contest'),
      headers: jsonHeaders(token),
      body: jsonEncode({'contest_id': contestId}),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['success'];
    } else {
      return false;
    }
  }

  static Future<void> addWalletCredit(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.post(
      Uri.parse('$baseUrl/wallets/credit'),
      headers: jsonHeaders(token),
      body: jsonEncode({'amount': amount, "description": "Added via Razorpay"}),
    );
    print(res.statusCode);
  }

  static Future<List<UserTeam>> getUserTeams(int matchId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/user_teams?match_id=$matchId'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load contests');
    }

    final dynamic response = jsonDecode(res.body);

    // Ensure 'data' is a List and map each to Contest
    final List<dynamic> dataList = response['data'];
    return dataList.map<UserTeam>((json) => UserTeam.fromJson(json)).toList();
  }

  static Future<List<WalletsTransaction>> getWalletTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse('$baseUrl/wallets/transactions'),
      headers: jsonHeaders(token),
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load transaction!');
    }

    final List<dynamic> dataList = jsonDecode(res.body);
    print(dataList);
    return dataList
        .map<WalletsTransaction>((json) => WalletsTransaction.fromJson(json))
        .toList();
  }
}
