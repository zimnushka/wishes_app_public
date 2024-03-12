part of 'menu.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    required this.curIndex,
    required this.onTap,
    required this.onLogoTap,
    required this.items,
    super.key,
  });
  final List<MenuItem> items;
  final int curIndex;
  final void Function(int index) onTap;
  final void Function() onLogoTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              InkWell(
                onTap: onLogoTap,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SvgPicture.asset(
                        'assets/icons/logo.svg',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'ХОТЕЛКИ',
                      style: TextStyleBook.title20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ...List.generate(
                items.length,
                (index) => _SideMenuButton(
                  item: items[index],
                  index: index,
                  curIndex: curIndex,
                  onTap: onTap,
                ),
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}

class _SideMenuButton extends StatefulWidget {
  const _SideMenuButton({
    required this.item,
    required this.index,
    required this.curIndex,
    required this.onTap,
  });

  final MenuItem item;
  final int index;
  final int curIndex;
  final Function(int) onTap;

  @override
  State<_SideMenuButton> createState() => _SideMenuButtonState();
}

class _SideMenuButtonState extends State<_SideMenuButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.index == widget.curIndex;
    final color = isHover
        ? Theme.of(context).primaryColor
        : Theme.of(context).textTheme.displayMedium?.color?.withOpacity(
              isActive ? 1 : 0.5,
            );
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: InkWell(
        onTap: () => widget.onTap(widget.index),
        onHover: (val) {
          setState(() {
            isHover = val;
          });
        },
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Row(
          children: [
            IconTheme(
              data: IconThemeData(
                size: 30,
                color: color,
              ),
              child: widget.item.icon,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                widget.item.label.toUpperCase(),
                style: TextStyleBook.text14.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
