import 'package:flutter/material.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/screens/widgets/header_appbar.dart';
import 'package:ideal11/services/razorpay_payment_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double walletBalance = 0.0;
  List transactions = [];
  TextEditingController amountController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    RazorpayPaymentService.init(_handlePaymentSuccess, _handlePaymentError);
    fetchData();
  }

  void fetchData() async {
    setState(() {
      loading = true;
    });
    final balance = await ApiService.getWalletBalance();
    final txns = await ApiService.getWalletTransactions();
    setState(() {
      walletBalance = double.parse(balance);
      transactions = txns;
      loading = false;
    });
  }

  void _handlePaymentSuccess(response) async {
    await ApiService.addWalletCredit(double.parse(amountController.text));
    amountController.clear();
    fetchData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment Success!")));
  }

  void _handlePaymentError(response) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Payment Failed")));
  }

  void _validateAndCreateOrder() async {
    double? amount = double.tryParse(amountController.text);
    if (amount == null || amount < 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Enter amount ₹10 or above")));
      return;
    }
    try {
      // Request backend to create Razorpay order id
      final orderId = await ApiService.createRazorpayOrder(
        (amount * 100).toInt(),
      );

      // Open Razorpay Checkout with the order id
      RazorpayPaymentService.openCheckout(
        orderId: orderId,
        amount: amount,
        userEmail: "Test",
        userContact: '9475635421',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to create order")));
    }
  }

  @override
  void dispose() {
    RazorpayPaymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderAppBar(),
      body:
          loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter Amount (Min ₹10)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _validateAndCreateOrder,
                          child: Text("Add Money"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child:
                        transactions.isEmpty
                            ? Center(child: Text("No Transactions Found"))
                            : ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final tx = transactions[index];
                                return ListTile(
                                  title: Text(
                                    "${tx.transactionType} ₹${tx.amount}",
                                  ),
                                  subtitle: Text("${tx.description}"),
                                  trailing: Text("${tx.createdAt}"),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }
}
