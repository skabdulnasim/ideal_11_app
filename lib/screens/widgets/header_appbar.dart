import 'package:flutter/material.dart';
import 'package:ideal11/app_constant.dart';
import 'package:ideal11/core/api_service.dart';
import 'package:ideal11/screens/wallet/wallet_screen.dart';

class HeaderAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HeaderAppBar({Key? key}) : super(key: key);

  @override
  State<HeaderAppBar> createState() => _HeaderAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderAppBarState extends State<HeaderAppBar> {
  double _walletBalance = 0.0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      loading = true;
    });
    final balance = await ApiService.getWalletBalance();
    setState(() {
      _walletBalance = double.parse(balance);
      loading = false;
    });
  }

  void updateWalletBalance(double newBalance) {
    setState(() {
      _walletBalance = newBalance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: true,
      // centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      leadingWidth: 40,
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: MAIN_GRADIENT),
      ),
      elevation: 2,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset(
            'assets/logo_only.png', // Your logo image path
            height: 48,
          ),
          const Text(
            'IDEAL11',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 204, 0),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WalletScreen()),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: LITE_BLACK,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  '₹${_walletBalance.toInt()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        // IconButton(
        //   icon: const Icon(Icons.notifications, color: Colors.black),
        //   onPressed: widget.onNotificationPressed,
        // ),
      ],
    );
  }
}
