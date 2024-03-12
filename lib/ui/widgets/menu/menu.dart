import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';

part 'bottom_menu.dart';
part 'side_menu.dart';

class MenuItem extends Equatable {
  final String label;
  final Widget icon;

  const MenuItem({
    required this.icon,
    required this.label,
  });

  @override
  List<Object?> get props => [
        label,
        icon,
      ];
}
