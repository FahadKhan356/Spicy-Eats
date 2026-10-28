import 'package:flutter/material.dart';

enum CardBrand { visa, mastercard, amex, discover, generic }

class PaymentMethodModel {
  final String? paymentId;
  final String userId;
  final String? accountHolderName;
  final String? cardHolder;
  final String cardNumber;
  final String? expiryDate;
  final String? cvv;
  final String? mmYy;
  final String paymentType;
  final bool isDefault;

  PaymentMethodModel({
    this.paymentId,
    required this.userId,
    this.accountHolderName,
    this.cardHolder,
    required this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.mmYy,
    this.paymentType = 'Card',
    this.isDefault = false,
  });

  /// Extracts the effective holder name.
  String get effectiveHolderName {
    if (cardHolder != null && cardHolder!.trim().isNotEmpty) {
      return cardHolder!.trim();
    }
    if (accountHolderName != null && accountHolderName!.trim().isNotEmpty) {
      return accountHolderName!.trim();
    }
    return 'Valued Customer';
  }

  /// Extracts the effective expiration date formatted as MM/YY.
  String get effectiveExpiry {
    if (mmYy != null && mmYy!.trim().isNotEmpty) {
      return mmYy!.trim();
    }
    if (expiryDate != null && expiryDate!.trim().isNotEmpty) {
      return expiryDate!.trim();
    }
    return '12/28';
  }

  /// Returns masked card number like "•••• •••• •••• 4242".
  String get maskedCardNumber {
    final clean = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (clean.length < 4) return clean;
    final last4 = clean.substring(clean.length - 4);
    return '•••• •••• •••• $last4';
  }

  /// Detects card brand from card number prefix.
  CardBrand get brand {
    final clean = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (clean.startsWith('4')) return CardBrand.visa;
    if (clean.startsWith(RegExp(r'^(5[1-5]|2[2-7])'))) return CardBrand.mastercard;
    if (clean.startsWith(RegExp(r'^3[47]'))) return CardBrand.amex;
    if (clean.startsWith('6011') || clean.startsWith('65')) return CardBrand.discover;
    return CardBrand.generic;
  }

  String get brandName {
    switch (brand) {
      case CardBrand.visa:
        return 'Visa';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.amex:
        return 'American Express';
      case CardBrand.discover:
        return 'Discover';
      case CardBrand.generic:
        return paymentType;
    }
  }

  IconData get brandIcon {
    switch (brand) {
      case CardBrand.visa:
      case CardBrand.mastercard:
      case CardBrand.amex:
      case CardBrand.discover:
        return Icons.credit_card;
      case CardBrand.generic:
        return paymentType.toLowerCase().contains('cash')
            ? Icons.payments_outlined
            : Icons.credit_card;
    }
  }

  Map<String, dynamic> toJson() {
    final expiry = effectiveExpiry;
    final holder = effectiveHolderName;
    return {
      if (paymentId != null) 'paymentId': paymentId,
      'user_id': userId,
      'accountHolderName': holder,
      'cardHolder': holder,
      'cardNumber': cardNumber,
      'expiryDate': expiry,
      'MM/YY': expiry,
      'cvv': cvv ?? '***',
      'paymentType': paymentType,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      paymentId: json['paymentId']?.toString(),
      userId: json['user_id']?.toString() ?? '',
      accountHolderName: json['accountHolderName']?.toString(),
      cardHolder: json['cardHolder']?.toString(),
      cardNumber: json['cardNumber']?.toString() ?? '•••• 0000',
      expiryDate: json['expiryDate']?.toString(),
      cvv: json['cvv']?.toString(),
      mmYy: json['MM/YY']?.toString(),
      paymentType: json['paymentType']?.toString() ?? 'Card',
      isDefault: json['isDefault'] is bool
          ? json['isDefault'] as bool
          : (json['isDefault']?.toString() == 'true'),
    );
  }

  PaymentMethodModel copyWith({
    String? paymentId,
    String? userId,
    String? accountHolderName,
    String? cardHolder,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? mmYy,
    String? paymentType,
    bool? isDefault,
  }) {
    return PaymentMethodModel(
      paymentId: paymentId ?? this.paymentId,
      userId: userId ?? this.userId,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      cardHolder: cardHolder ?? this.cardHolder,
      cardNumber: cardNumber ?? this.cardNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      mmYy: mmYy ?? this.mmYy,
      paymentType: paymentType ?? this.paymentType,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
