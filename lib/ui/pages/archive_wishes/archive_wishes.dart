import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/wish.dart';
import 'package:wishes_app/helpers/color_helper.dart';
import 'package:wishes_app/router/routes/wish.dart';
import 'package:wishes_app/ui/pages/archive_wishes/archive_wishes_vm.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';
import 'package:wishes_app/ui/widgets/back_button.dart';

class ArchirvedWishes extends StatelessWidget {
  const ArchirvedWishes({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => ArchivedWishesVM(mainBloc: mainBloc),
          child: const _ArchirvedWishesView(),
        ),
      ),
    );
  }
}

class _ArchirvedWishesView extends StatelessWidget {
  const _ArchirvedWishesView();

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final vm = context.read<ArchivedWishesVM>();
    final isLoading = context.select((ArchivedWishesVM vm) => vm.isLoading);
    final items = context.select((ArchivedWishesVM vm) => vm.items);
    return RefreshIndicator(
      onRefresh: vm.update,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              children: [
                BackButtonL(
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Архив ваших хотелок',
                      style: TextStyleBook.title20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              itemCount: isLoading ? 3 : items.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                childAspectRatio: 38 / 50,
              ),
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
    final vm = context.read<ArchivedWishesVM>();

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
