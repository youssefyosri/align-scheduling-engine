import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/utils/app_ui_utils.dart';
import '../data/payment_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final double amount;
  final String currency;

  const CheckoutScreen({
    super.key,
    required this.amount,
    this.currency = 'USD',
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {

  Future<void> _processPayment(PaymentGateway gateway) async {
    AppUIUtils.showLoadingOverlay(context);

    final result = await ref.read(paymentServiceProvider).processPayment(
      context: context,
      amount: widget.amount,
      currency: widget.currency,
      gateway: gateway,
    );

    if (mounted) {
      AppUIUtils.hideLoadingOverlay(context);

      if (result.isSuccess) {
        AppUIUtils.showSuccess(context, 'Payment successful! Thank you.');
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go('/');
        }
      } else {
        AppUIUtils.showError(context, result.errorMessage ?? 'Payment failed or was canceled.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Due',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Gap(8),
                    Text(
                      '\$${widget.amount.toStringAsFixed(2)}',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(48),

              Text(
                'Select Payment Method',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),

              AppButton.primary(
                text: 'Credit Card or Wallet',
                icon: Icons.credit_card,
                onPressed: () => _processPayment(PaymentGateway.stripe),
              ),
              const Gap(16),

              AppButton.outline(
                text: 'PayPal',
                icon: Icons.paypal,
                onPressed: () => _processPayment(PaymentGateway.paypal),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const Gap(8),
                  Text(
                    'Payments are secure and encrypted',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}