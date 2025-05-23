import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/models/contest.dart';
import 'package:ideal11/screens/widgets/team_selection_widget.dart';
import 'package:ideal11/services/razorpay_payment_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class JoinContestScreen extends StatefulWidget {
  final Contest contest;

  JoinContestScreen({required this.contest});

  @override
  _JoinContestScreenState createState() => _JoinContestScreenState();
}

class _JoinContestScreenState extends State<JoinContestScreen> {
  double walletBalance = 0.0;
  bool loading = true;
  int? selectedTeamId;

  @override
  void initState() {
    super.initState();
    fetchWallet();
    RazorpayPaymentService.init(_handlePaymentSuccess, _handlePaymentFailure);
  }

  void fetchWallet() async {
    String _walletBalance = await ApiService.getWalletBalance();
    walletBalance = double.parse(_walletBalance);
    setState(() => loading = false);
  }

  void _joinContest() async {
    if (selectedTeamId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a team")));
      return;
    }

    if (walletBalance >= widget.contest.entryFee) {
      final success = await ApiService.joinContest(
        widget.contest.id,
        selectedTeamId!,
      );

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Joined Contest")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to join")));
      }
    } else {
      // Need to add funds
      final amountToAdd = widget.contest.entryFee - walletBalance;

      final rOrderId = await ApiService.createRazorpayOrder(
        (amountToAdd * 100).toInt(),
      );
      RazorpayPaymentService.openCheckout(
        orderId: rOrderId,
        amount: amountToAdd,
        userEmail: "user@example.com",
        userContact: "9876543210",
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await ApiService.addWalletCredit(widget.contest.entryFee);
    fetchWallet();
    _joinContest(); // retry after wallet update
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment failed")));
  }

  @override
  void dispose() {
    RazorpayPaymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Join Contest")),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Text("Wallet: ₹$walletBalance"),
                  TeamSelectionWidget(
                    matchId: widget.contest.matchId,
                    selectedTeamId: selectedTeamId,
                    onTeamSelected: (int? id) {
                      setState(() => selectedTeamId = id);
                    },
                  ),
                  ElevatedButton(
                    onPressed: _joinContest,
                    child: Text("Join for ₹${widget.contest.entryFee}"),
                  ),
                ],
              ),
    );
  }
}
