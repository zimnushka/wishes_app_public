import 'package:flutter/material.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';

class AlertModal extends StatelessWidget {
  const AlertModal({
    required this.title,
    required this.description,
    this.acceptLabel,
    this.cancelLabel,
    this.onAccept,
    this.onCancel,
    super.key,
  });
  final String title;
  final String description;
  final String? cancelLabel;
  final String? acceptLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onAccept;

  static void show({
    required BuildContext context,
    required String title,
    required String description,
    String? cancelLabel,
    String? acceptLabel,
    VoidCallback? onCancel,
    VoidCallback? onAccept,
  }) {
    showGeneralDialog(
      barrierLabel: '',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation1,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeInCubic,
          ),
          child: AlertModal(
            title: title,
            description: description,
            acceptLabel: acceptLabel,
            cancelLabel: cancelLabel,
            onAccept: onAccept,
            onCancel: onCancel,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyleBook.title20,
                  ),
                  if (description.isNotEmpty) const SizedBox(height: 20),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyleBook.text14.copyWith(color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                    ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onAccept?.call();
                        },
                        child: Text(acceptLabel ?? 'да'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onCancel?.call();
                        },
                        child: Text(cancelLabel ?? 'отменить'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
