import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wishes_app/domain/toast/toast_state.dart';

class OverlayToast extends StatefulWidget {
  const OverlayToast({
    super.key,
    required this.text,
    required this.type,
    required this.duration,
    required this.onTap,
    required this.onDismiss,
  });
  final String text;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback onDismiss;

  @override
  State<OverlayToast> createState() => _OverlayToastState();
}

class _OverlayToastState extends State<OverlayToast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    reverseDuration: const Duration(milliseconds: 300),
    vsync: this,
  )..forward();
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, -1),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeIn,
    ),
  );

  late final stream = Stream.periodic(const Duration(milliseconds: 10), (tic) {
    final curMillis = tic * 10;
    final totalMillis = widget.duration.inMilliseconds;
    final percent = totalMillis / 100;
    final curPercent = curMillis / percent;
    final valuePercent = curPercent / 100;
    final reversPercent = 1 - valuePercent;
    if (reversPercent < 0.1 && _controller.isCompleted) {
      _controller.reverse();
    }
    return reversPercent;
  });

  statusListener(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      widget.onDismiss();
    }
  }

  @override
  void initState() {
    _controller.addStatusListener(statusListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = const SizedBox();

    switch (widget.type) {
      case ToastType.error:
        icon = const Icon(
          Icons.cancel,
          color: Colors.white,
          size: 30,
        );
      case ToastType.info:
        icon = const Icon(
          Icons.info,
          color: Colors.white,
          size: 30,
        );
      case ToastType.success:
        icon = const Icon(
          Icons.done,
          color: Colors.white,
          size: 30,
        );
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top,
      right: 0,
      left: 0,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: GestureDetector(
            onTap: () {
              widget.onTap?.call();
              _controller.reverse();
            },
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              elevation: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: widget.type.color,
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Stack(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: StreamBuilder<double>(
                                stream: stream,
                                builder: (context, snapshot) {
                                  return CircularProgressIndicator(
                                    strokeWidth: 3,
                                    strokeCap: StrokeCap.round,
                                    value: snapshot.data,
                                    color: Colors.white,
                                    backgroundColor: widget.type.color,
                                  );
                                },
                              ),
                            ),
                          ),
                          Center(child: icon),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        widget.text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Theme.of(context).iconTheme.color, fontSize: 15),
                      ),
                    ),
                  ),
                  if (widget.type == ToastType.error)
                    InkWell(
                      hoverColor: Colors.transparent,
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.text));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.copy,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
