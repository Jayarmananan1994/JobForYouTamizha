import 'package:flutter/material.dart';
import 'package:jobforyoutamizha/service/payment_service.dart';
import 'package:jobforyoutamizha/service_locator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MemberShip extends StatefulWidget {
  static const String PATH = '/membership';

  @override
  _MemberShipState createState() => _MemberShipState();
}

class _MemberShipState extends State<MemberShip> {
  Razorpay _razorpay;
  PaymentService _paymentService = locator<PaymentService>();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Become a member')),
      body: Container(
          child: Center(
        child: RaisedButton(
          onPressed: openCheckout,
          child: Text('Member plan comes here'),
        ),
      )),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_MYlEKxC0ajcsjy',
      'amount': 2000,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'name': 'Vijay Kumar','contact': '7708668625', 'email': 'jayaramanan.kumar@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };


    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: " + response.walletName);
  }
}
