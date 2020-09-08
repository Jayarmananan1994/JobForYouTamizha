import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';

class PaymentService {
  static const SUBCRIPTION_ENDPOINT =
      'https://api.razorpay.com/v1/subscriptions';

  static const CLIENT_ID = 'rzp_test_MYlEKxC0ajcsjy';
  static const SECRET = 'cZVhDL8B5fAGnIT15XMD0wWk';
  

  Future<dynamic> createSubscription(planId, subscriptionInfo) async {
    var client = BasicAuthClient(CLIENT_ID, SECRET);
    var response = await client.post(SUBCRIPTION_ENDPOINT,
        body: convert.jsonEncode(subscriptionInfo),
        headers: {"content-type": "application/json"});
    //f (response.statusCode == 200) {
      final body = convert.jsonDecode(response.body);
      return body;
    //}else{
     // response.
    //}

  }
}
