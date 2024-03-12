import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/wish.dart';
import 'package:wishes_app/helpers/color_helper.dart';
import 'package:wishes_app/router/routes/wish.dart';
import 'package:wishes_app/ui/pages/reserved_wishes/reserved_wishes_vm.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';

class ReservedWishes extends StatelessWidget {
  const ReservedWishes({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => ReservedWishesVM(mainBloc: mainBloc),
          child: const _ReservedWishesView(),
        ),
      ),
    );
  }
}

class _ReservedWishesView extends StatelessWidget {
  const _ReservedWishesView();

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final vm = context.read<ReservedWishesVM>();
    final isLoading = context.select((ReservedWishesVM vm) => vm.isLoading);
    final items = context.select((ReservedWishesVM vm) => vm.items);
    return RefreshIndicator(
      onRefresh: vm.update,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Зарезервированные вами хотелки',
                style: TextStyleBook.title20,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 38 / 50,
              ),
              itemCount: isLoading ? 3 : items.length,
              itemBuilder: (context, index) {
                if (isLoading) {
                  return const _LoadingWishCard();
                }
                return _WishCard(
                  key: ValueKey(items[index].id),
                  item: items[index],
                  onTap: () {
                    mainBloc.router.goTo(
                      WishPageRoute(
                        wishId: items[index].id,
                        onUpdate: vm.update,
                        initImageLink: items[index].imageLink != null ? vm.formatImageUrl(items[index].imageLink!) : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
    final vm = context.read<ReservedWishesVM>();

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
            child: Stack(
              children: [
                Hero(
                  tag: 'wishImage${widget.item.id}',
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: widget.item.imageLink == null ? ColorHelper.gradientFromId(widget.item.id, Theme.of(context)) : null,
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
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Theme.of(context).cardColor.withOpacity(0.8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: widget.item.user.photoUrl != null ? NetworkImage(widget.item.user.photoUrl!) : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              widget.item.user.displayName,
                              style: TextStyleBook.text12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
            ),
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
