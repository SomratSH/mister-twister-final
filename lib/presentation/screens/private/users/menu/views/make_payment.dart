import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mister_twister/common/widgets/custom_snackbar.dart';
import 'package:mister_twister/core/routes/app_route_path.dart';
import 'package:mister_twister/presentation/screens/private/drivers/orders/controllers/orders_controller.dart';
import 'package:provider/provider.dart';

import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

/// 🔑 Square Config (Sandbox)
const String squareAppId = "sandbox-sq0idb-aiRIKxCeUtdPmBM71ZGrGA";
const String squareLocationId = "LM0HJD54QN31J";

// iOS only (keep for future)
const String applePayMerchantId = "merchant.com.your.app";

class MakePayment extends StatefulWidget {
  const MakePayment({super.key});

  @override
  State<MakePayment> createState() => MakePaymentState();
}

class MakePaymentState extends State<MakePayment> {
  bool isLoading = true;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSquarePayment();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

Future<void> _initSquarePayment() async {
  /// 1️⃣ Init Square
  await InAppPayments.setSquareApplicationId(squareAppId);

  bool canUseApplePay = false;
  bool canUseGooglePay = false;

  /// 2️⃣ iOS → Apple Pay
  if (Platform.isIOS) {
    // Set the Apple Pay merchant ID (must match your Apple developer account)
    await InAppPayments.initializeApplePay( 
      applePayMerchantId, // e.g., "merchant.com.yourcompany.app"
     
    );

    // Check if Apple Pay is available on this device
    canUseApplePay = await InAppPayments.canUseApplePay;
  }

  /// 3️⃣ Android → Google Pay
  if (Platform.isAndroid) {
    await InAppPayments.initializeGooglePay(
      squareLocationId,
      google_pay_constants.environmentTest,
    );
    canUseGooglePay = await InAppPayments.canUseGooglePay;
  }

  /// 4️⃣ Update UI state
  setState(() {
    isLoading = false;
    applePayEnabled = canUseApplePay;
    googlePayEnabled = canUseGooglePay;
  });
}

  /// 💳 Card Payment
  void _startCardPayment() {
    InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: _onCardNonceSuccess,
      onCardEntryCancel: () {
        debugPrint("❌ Card entry cancelled");
      },
    );
  }

  /// ✅ Card Success
  void _onCardNonceSuccess(CardDetails result) async {
    debugPrint("✅ Card Nonce: ${result.nonce}");
    final order = await Provider.of<OrdersController>(
      context,
      listen: false,
    ).getArrivedOrder();

    final response = await Provider.of<OrdersController>(
      context,
      listen: false,
    ).payment(result.nonce, order!.orderId.toInt());

    CustomSnackbar.show(
      context,
      message: "Payemnt Success",
      backgroundColor: Colors.green,
    );

    context.go(RoutePath.home);

    // TODO: Send nonce to your backend for payment

    InAppPayments.completeCardEntry(
      onCardEntryComplete: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Payment Successful")));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderController = context.watch<OrdersController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Square Payment Demo'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// 💳 Card Pay
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.credit_card),
                      label: const Text('Pay with Card'),
                      onPressed: _startCardPayment,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // /// 🟢 Google Pay
                  // if (googlePayEnabled)
                  //   SizedBox(
                  //     width: double.infinity,
                  //     child: ElevatedButton.icon(
                  //       icon: const Icon(Icons.payment),
                  //       label: const Text('Pay with Google Pay'),
                  //       onPressed: _startGooglePay,
                  //     ),
                  //   ),

                  // if (!googlePayEnabled)
                  //   const Text(
                  //     "Google Pay not available",
                  //     style: TextStyle(color: Colors.grey),
                  //   ),
                ],
              ),
            ),
    );
  }
}
