import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PayPalService {
  static Future<void> handlePayment(String orderId, double amount) async {
    // Launch PayPal checkout page
    final approveUrl =
        "https://www.sandbox.paypal.com/checkoutnow?token=$orderId";
    if (await canLaunchUrl(Uri.parse(approveUrl))) {
      await launchUrl(Uri.parse(approveUrl));
    }
  }

  static Future<bool> capturePayment(String orderId) async {
    final response = await http.post(
      Uri.parse(
          'https://api.sandbox.paypal.com/v2/checkout/orders/$orderId/capture'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN'
      },
    );
    return response.statusCode == 201;
  }
}
