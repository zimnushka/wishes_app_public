part of '../user_page.dart';

class _InfoUserWidget extends StatefulWidget {
  const _InfoUserWidget({
    required this.label,
    required this.followers,
    this.onTap,
  });
  final String label;
  final List<Follower> followers;
  final VoidCallback? onTap;

  @override
  State<_InfoUserWidget> createState() => _InfoUserWidgetState();
}

class _InfoUserWidgetState extends State<_InfoUserWidget> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    const rangeIndex = 3;
    final rangedList = widget.followers.length > rangeIndex ? widget.followers.getRange(0, rangeIndex - 1) : widget.followers;
    return InkWell(
      hoverColor: Colors.transparent,
      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
      onHover: (val) {
        isHover = val;
        setState(() {});
      },
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: TextStyleBook.text12.copyWith(
              color: isHover ? Theme.of(context).primaryColor : null,
            ),
          ),
          const SizedBox(height: 10),
          rangedList.isEmpty
              ? const _EmptyUserCircle()
              : SizedBox(
                  height: 40,
                  width: 80,
                  child: Stack(
                    children: List.generate(
                      rangedList.length + (widget.followers.length > rangeIndex ? 1 : 0),
                      (index) {
                        if (index == rangedList.length) {
                          return Positioned(
                            left: index * 20,
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: 20,
                              child: Center(
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: '+',
                                      style: TextStyleBook.text11.copyWith(
                                        color: ColorsBook.lightBase,
                                      ),
                                    ),
                                    TextSpan(
                                      text: (widget.followers.length - rangeIndex).toString(),
                                      style: TextStyleBook.text12.copyWith(
                                        color: ColorsBook.lightBase,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          );
                        }
                        final follower = rangedList.elementAt(index);
                        return Positioned(
                          left: index * 20,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).disabledColor,
                            radius: 20,
                            backgroundImage: follower.photoUrl != null ? NetworkImage(follower.photoUrl!) : null,
                            child: follower.photoUrl != null ? null : Text(follower.displayName.substring(0, 1)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _EmptyUserCircle extends StatelessWidget {
  const _EmptyUserCircle();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Theme.of(context).disabledColor,
          ),
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: Icon(
              Icons.person_outlined,
              size: 25,
              color: Theme.of(context).disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}
