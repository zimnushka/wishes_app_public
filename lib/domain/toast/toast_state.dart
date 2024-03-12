import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:wishes_app/ui/styles/colors_book.dart';

enum ToastType {
  error,
  info,
  success;

  Color get color {
    switch (this) {
      case ToastType.error:
        return ColorsBook.error;
      case ToastType.info:
        return ColorsBook.active;
      case ToastType.success:
        return ColorsBook.success;
    }
  }
}

class ToastState extends Equatable {
  final String text;
  final ToastType type;

  const ToastState({required this.text, required this.type});

  factory ToastState.empty() => const ToastState(text: '', type: ToastType.info);

  bool get isEmpty => text.isEmpty;

  @override
  List<Object?> get props => [text, type];
}
