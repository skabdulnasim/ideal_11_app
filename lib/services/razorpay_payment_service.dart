import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentService {
  static late Razorpay _razorpay;

  static void init(Function onSuccess, Function onFailure) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (_) {});
  }

  static void dispose() {
    _razorpay.clear();
  }

  static void openCheckout({
    required String orderId,
    required double amount,
    required String userEmail,
    required String userContact,
  }) {
    var options = {
      'key': 'rzp_test_qU3bdWCLbDymGA', // replace with your Razorpay Key
      'amount': (amount * 100).toInt(),
      'currency': 'INR',
      'name': 'IDEAL11',
      'order_id': orderId,
      'description': 'Wallet Top-up',
      'prefill': {'contact': userContact, 'email': userEmail},
    };
    _razorpay.open(options);
  }
}
