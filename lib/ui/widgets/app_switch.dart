import 'package:flutter/material.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';

class AppSwitch extends StatefulWidget {
  const AppSwitch({
    required this.firstLabel,
    required this.secondLabel,
    required this.isFirstSelected,
    required this.onChange,
    this.bkgColor,
    this.indicatorColor,
    super.key,
  });
  final String firstLabel;
  final String secondLabel;
  final Color? indicatorColor;
  final Color? bkgColor;
  final bool isFirstSelected;
  final Function(bool val) onChange;

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 400),
    vsync: this,
  );
  late final Animation<AlignmentGeometry> _animation = Tween<AlignmentGeometry>(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutExpo,
      reverseCurve: Curves.easeInOutExpo,
    ),
  );

  @override
  void initState() {
    _controller.value = !widget.isFirstSelected ? 1 : 0;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
      onTap: () {
        if (widget.isFirstSelected) {
          _controller.forward();
          widget.onChange(false);
        } else {
          _controller.reverse();
          widget.onChange(true);
        }
      },
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: widget.bkgColor ?? Theme.of(context).scaffoldBackgroundColor,
              ),
              child: AlignTransition(
                alignment: _animation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: widget.indicatorColor ?? Theme.of(context).cardColor,
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth / 2,
                        height: constraints.maxHeight,
                      );
                    }),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        widget.firstLabel,
                        maxLines: 1,
                        style: TextStyleBook.title17,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: Text(
                        widget.secondLabel,
                        maxLines: 1,
                        style: TextStyleBook.title17,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
