part of '../user_page.dart';

class _WishCard extends StatefulWidget {
  const _WishCard({
    required this.item,
    required this.onTap,
    super.key,
  });
  final Wish item;
  final VoidCallback onTap;

  @override
  State<_WishCard> createState() => _WishCardState();
}

class _WishCardState extends State<_WishCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserVM>();
    final isMyWish = context.select((UserVM vm) => vm.isMyProfile);

    return InkWell(
      hoverColor: Colors.transparent,
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      onTap: widget.onTap,
      onHover: (val) {
        setState(() {
          isHover = val;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'wishImage${widget.item.id}',
              child: Stack(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: widget.item.imageLink == null ? ColorHelper.gradientFromId(widget.item.id, Theme.of(context)) : null,
                      // color: widget.item.imageLink == null ? ColorHelper.colorFromId(widget.item.id) : null,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      image: widget.item.imageLink != null
                          ? DecorationImage(
                              image: NetworkImage(vm.formatImageUrl(widget.item.imageLink!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: const SizedBox.expand(),
                  ),
                  if (widget.item.reservedById != null && !isMyWish)
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.6),
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                        ),
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.lock,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              widget.item.name,
              style: TextStyleBook.title17.copyWith(
                color: isHover ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 5),
          if (widget.item.price != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                '${widget.item.price}₽',
                style: TextStyleBook.text14,
              ),
            )
        ],
      ),
    );
  }
}

class _LoadingWishCard extends StatelessWidget {
  const _LoadingWishCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
            ),
            child: const SizedBox(
              height: 17,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(height: 12),
      ],
    );
  }
}
