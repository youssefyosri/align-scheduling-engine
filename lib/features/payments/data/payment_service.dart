import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

enum PaymentGateway { stripe, paypal }

class PaymentResult {
  final bool isSuccess;
  final String? errorMessage;
  PaymentResult({required this.isSuccess, this.errorMessage});
}

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

class PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<PaymentResult> processPayment({
    required BuildContext context,
    required double amount,
    required String currency,
    required PaymentGateway gateway,
  }) async {
    try {
      if (gateway == PaymentGateway.stripe) {
        return await _processStripePayment(amount, currency);
      } else {
        return await _processPayPalPayment(context, amount, currency);
      }
    } catch (e) {
      return PaymentResult(isSuccess: false, errorMessage: e.toString());
    }
  }

  Future<PaymentResult> _processStripePayment(double amount, String currency) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('createStripePaymentIntent');
      final response = await callable.call({
        'amount': (amount * 100).toInt(), // Stripe expects cents
        'currency': currency.toLowerCase(),
      });

      final clientSecret = response.data['clientSecret'];
      if (clientSecret == null) throw Exception('Failed to retrieve client secret.');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'MVP Boilerplate',
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return PaymentResult(isSuccess: true);

    } on StripeException catch (e) {
      return PaymentResult(
        isSuccess: false,
        errorMessage: e.error.localizedMessage ?? 'Payment failed',
      );
    } catch (e) {
      return PaymentResult(isSuccess: false, errorMessage: 'An unexpected error occurred.');
    }
  }

  Future<PaymentResult> _processPayPalPayment(BuildContext context, double amount, String currency) async {
    bool success = false;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true, // TODO: Tie this to your Environment.dev config
          clientId: "YOUR_PAYPAL_CLIENT_ID",
          secretKey: "YOUR_PAYPAL_SECRET_KEY",
          transactions: [
            {
              "amount": {
                "total": amount.toStringAsFixed(2),
                "currency": currency,
                "details": {
                  "subtotal": amount.toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "MVP Checkout",
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            success = true;
            Navigator.pop(context); // Close the WebView
          },
          onError: (error) {
            success = false;
            Navigator.pop(context);
          },
          onCancel: () {
            success = false;
            Navigator.pop(context);
          },
        ),
      ),
    );

    return PaymentResult(
      isSuccess: success,
      errorMessage: success ? null : 'PayPal transaction failed or was canceled.',
    );
  }
}