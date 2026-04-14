import 'package:flutter/material.dart';

class TabItem<T> {
  final Widget icon;
  final String? title;
  final String? key;

  const TabItem({
    required this.icon,
    this.title,
    this.key,
  });
}
