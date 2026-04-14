import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

formatDate(int date) {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  final String formattedOrderDate =
      formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
  return formattedOrderDate;
}

String formatPrice(num price) {
  final locale = WidgetsBinding.instance.platformDispatcher.locale;

  var formattedPrice = price.toInt().toString();

  if (locale.countryCode?.toLowerCase() != "ph") {
    formattedPrice = price.toStringAsFixed(2);
  }

  if (price >= 1000) {
    formattedPrice = NumberFormat.compact().format(num.parse(formattedPrice));
  }

  return formattedPrice;
}

String formatPriceWithDecimal(num price) {
  final NumberFormat numberFormatter = NumberFormat.decimalPattern('en_US');
  numberFormatter.minimumFractionDigits = 2;
  numberFormatter.maximumFractionDigits = 2;

  final String formattedPrice = numberFormatter.format(price);
  return formattedPrice;
}

String capitalizeFirstLetter({required String string}) {
  String firstLetter = string[0].toUpperCase();
  String remainingString = string.substring(1, string.length);

  return firstLetter + remainingString;
}

Random random = Random();
