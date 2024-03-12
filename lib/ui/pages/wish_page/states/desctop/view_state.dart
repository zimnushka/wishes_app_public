part of '../../wish_page.dart';

class _WishPageDesctop extends StatefulWidget {
  const _WishPageDesctop();

  @override
  State<_WishPageDesctop> createState() => _WishPageDesctopState();
}

class _WishPageDesctopState extends State<_WishPageDesctop> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final isLoading = context.select((WishVM vm) => vm.isLoading);
    final isMyWish = context.select((WishVM vm) => vm.isMyWish);
    final item = context.select((WishVM vm) => vm.item);
    final imageUrl = context.select((WishVM vm) => vm.imageUrl);
    final initImageLink = context.select((WishVM vm) => vm.initImageLink);

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 60),
            child: SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 40),
                  BackButtonL(
                    onTap: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  if (isMyWish && !isLoading)
                    _PopUpMenuViewState(
                      onDeleteTap: () async {
                        final success = await vm.delete();
                        if (success && mounted) {
                          Navigator.pop(context);
                        }
                      },
                      onEditTap: () {
                        vm.startEdit();
                      },
                    )
                ],
              ),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400, minWidth: 200, minHeight: 200),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Hero(
                        tag: 'wishImage${vm.wishId}',
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: imageUrl == null ? ColorHelper.gradientFromId(item.id, Theme.of(context)) : null,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            image: imageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  )
                                : isLoading && initImageLink != null
                                    ? DecorationImage(
                                        image: NetworkImage(initImageLink),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: !isLoading
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: TextStyleBook.title20),
                              if (item.price != null) ...[
                                const SizedBox(height: 30),
                                Text('цена', style: TextStyleBook.text14),
                                const SizedBox(height: 10),
                                Text('${item.price}₽', style: TextStyleBook.title17),
                              ],
                              if (item.description != null && item.description!.isNotEmpty) ...[
                                const SizedBox(height: 30),
                                Text('описание', style: TextStyleBook.text14),
                                const SizedBox(height: 10),
                                Text(item.description ?? '', style: TextStyleBook.title17),
                              ],
                              if (!isMyWish && !isLoading) const _ReserveWishButton(),
                            ],
                          )
                        : const SizedBox(),
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
