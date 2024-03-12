part of 'menu.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    required this.curIndex,
    required this.onTap,
    required this.items,
    super.key,
  });
  final List<MenuItem> items;
  final int curIndex;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: SafeArea(
          left: false,
          right: false,
          top: false,
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                items.length,
                (index) => _BottomMenuButton(
                  icon: items[index].icon,
                  index: index,
                  curIndex: curIndex,
                  onTap: onTap,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomMenuButton extends StatelessWidget {
  const _BottomMenuButton({
    required this.icon,
    required this.index,
    required this.curIndex,
    required this.onTap,
  });

  final Widget icon;
  final int index;
  final int curIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: IconTheme(
            data: IconThemeData(
              size: 30,
              color: Theme.of(context).textTheme.displayMedium?.color?.withOpacity(
                    index == curIndex ? 1 : 0.5,
                  ),
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}
