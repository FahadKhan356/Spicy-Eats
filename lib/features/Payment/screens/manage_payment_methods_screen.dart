import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Payment/controller/payment_methods_controller.dart';
import 'package:spicy_eats/features/Payment/model/payment_method_model.dart';

class ManagePaymentMethodsScreen extends ConsumerStatefulWidget {
  static const String routename = '/manage-payments';

  const ManagePaymentMethodsScreen({super.key});

  @override
  ConsumerState<ManagePaymentMethodsScreen> createState() =>
      _ManagePaymentMethodsScreenState();
}

class _ManagePaymentMethodsScreenState
    extends ConsumerState<ManagePaymentMethodsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paymentMethodsControllerProvider.notifier).load();
    });
  }

  void _showMessage(String text, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text)),
            ],
          ),
          backgroundColor: isError ? Colors.red[600] : Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }

  void _openAddCardBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddCardSheet(
        onSaved: () {
          _showMessage('Payment card saved successfully!');
        },
      ),
    );
  }

  void _confirmDelete(PaymentMethodModel method) {
    if (method.paymentId == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline, color: Colors.red[700], size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Remove Card',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove card ending in ${method.maskedCardNumber.split(' ').last}?',
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(paymentMethodsControllerProvider.notifier)
                  .deleteCard(method.paymentId!);
              if (success) {
                _showMessage('Card removed successfully');
              } else {
                _showMessage('Failed to delete card', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentMethodsControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _openAddCardBottomSheet,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.purple[700], size: 22),
            ),
            tooltip: 'Add New Card',
          ),
          IconButton(
            onPressed: () => ref
                .read(paymentMethodsControllerProvider.notifier)
                .load(force: true),
            icon: state.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.purple),
                  )
                : Icon(Icons.refresh, color: Colors.grey[700]),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: state.isLoading && state.methods.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.purple),
            )
          : RefreshIndicator(
              color: Colors.purple,
              onRefresh: () => ref
                  .read(paymentMethodsControllerProvider.notifier)
                  .load(force: true),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  // Cash on Delivery Card
                  _buildCodCard(),
                  const SizedBox(height: 20),

                  // Saved Cards Header
                  Row(
                    children: [
                      Text(
                        'Saved Cards (${state.methods.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _openAddCardBottomSheet,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Card'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.purple[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (state.methods.isEmpty)
                    _buildEmptyCardsState()
                  else
                    ...state.methods.map((card) {
                      final isDef = state.defaultMethod?.paymentId == card.paymentId ||
                          card.isDefault;
                      return _buildCreditCardItem(card, isDefault: isDef);
                    }),
                ],
              ),
            ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: _openAddCardBottomSheet,
            icon: const Icon(Icons.credit_card, color: Colors.white),
            label: const Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.payments_outlined, color: Colors.green[700], size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cash on Delivery',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Pay with cash at your doorstep upon delivery.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Text(
              'ENABLED',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCardItem(PaymentMethodModel card, {required bool isDefault}) {
    final gradientColors = card.brand == CardBrand.visa
        ? [const Color(0xFF1A1F71), const Color(0xFF00579F)]
        : card.brand == CardBrand.mastercard
            ? [const Color(0xFF2C3E50), const Color(0xFFE74C3C)]
            : [const Color(0xFF232526), const Color(0xFF414345)];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      card.brandIcon,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 28,
                    ),
                    Row(
                      children: [
                        if (isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green[500],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check, size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'DEFAULT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _confirmDelete(card),
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.white70, size: 20),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Remove Card',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Card Number
                Text(
                  card.maskedCardNumber,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    letterSpacing: 3,
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Card Holder and Expiry
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CARD HOLDER',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 9,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.effectiveHolderName.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXPIRES',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 9,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          card.effectiveExpiry,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (!isDefault && card.paymentId != null)
                      TextButton(
                        onPressed: () {
                          ref
                              .read(paymentMethodsControllerProvider.notifier)
                              .setDefault(card.paymentId!);
                          _showMessage('Card set as default payment method');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Set Default',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCardsState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.credit_card_off_outlined,
                size: 40, color: Colors.purple[700]),
          ),
          const SizedBox(height: 14),
          const Text(
            'No Saved Cards',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Save your credit or debit card for fast, secure, one-tap checkout on your food orders.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _AddCardSheet extends ConsumerStatefulWidget {
  final VoidCallback onSaved;

  const _AddCardSheet({required this.onSaved});

  @override
  ConsumerState<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends ConsumerState<_AddCardSheet> {
  final _cardNumberController = TextEditingController();
  final _holderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isDefault = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final rawNumber = _cardNumberController.text.replaceAll(' ', '').trim();
    final holder = _holderController.text.trim();
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();

    if (rawNumber.length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid card number (at least 12 digits).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (holder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the cardholder name.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (expiry.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid expiry date (MM/YY).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await ref
        .read(paymentMethodsControllerProvider.notifier)
        .addCard(
          cardNumber: rawNumber,
          cardHolder: holder,
          expiryDate: expiry,
          cvv: cvv,
          isDefault: _isDefault,
        );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
        widget.onSaved();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save card. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.add_card, color: Colors.purple[700], size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Add Payment Card',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Card Number
            const Text(
              'Card Number',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                _CardNumberFormatter(),
              ],
              decoration: InputDecoration(
                hintText: '4000 1234 5678 9010',
                prefixIcon: const Icon(Icons.credit_card, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // Cardholder Name
            const Text(
              'Cardholder Name',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _holderController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'e.g. John Doe',
                prefixIcon: const Icon(Icons.person_outline, color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // Expiry & CVV
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Expiry Date (MM/YY)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _expiryController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          _ExpiryDateFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: 'MM/YY',
                          prefixIcon: const Icon(Icons.date_range, color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CVV',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _cvvController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: InputDecoration(
                          hintText: '123',
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Set as default switch
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isDefault,
              activeTrackColor: Colors.purple[700],
              title: const Text(
                'Set as default payment method',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              onChanged: (val) => setState(() => _isDefault = val),
            ),
            const SizedBox(height: 20),

            // Save CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Card',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
