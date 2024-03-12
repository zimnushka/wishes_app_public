part of '../../wish_page.dart';

class _WishPageMobile extends StatefulWidget {
  const _WishPageMobile();

  @override
  State<_WishPageMobile> createState() => _WishPageMobileState();
}

class _WishPageMobileState extends State<_WishPageMobile> {
  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final vm = context.read<WishVM>();
    final isLoading = context.select((WishVM vm) => vm.isLoading);
    final isMyWish = context.select((WishVM vm) => vm.isMyWish);
    final item = context.select((WishVM vm) => vm.item);
    final imageUrl = context.select((WishVM vm) => vm.imageUrl);
    final initImageLink = context.select((WishVM vm) => vm.initImageLink);

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BackButtonL(
                    onTap: context.read<MainBloc>().router.pop,
                  ),
                  const SizedBox(width: 20),
                  const Spacer(),
                  const _ShareWishButton(),
                  if (isMyWish && !isLoading)
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: _PopUpMenuViewState(
                        onDeleteTap: () async {
                          final success = await vm.delete();
                          if (success && mounted) {
                            Navigator.pop(context);
                          }
                        },
                        onEditTap: () {
                          vm.startEdit();
                        },
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
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
                    const SizedBox(height: 20),
                    if (!isLoading) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: TextStyleBook.title17),
                              if (item.price != null || item.link != null) const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (item.price != null)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('цена', style: TextStyleBook.text12),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${item.price}₽',
                                          style: TextStyleBook.title17.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  const Spacer(),
                                  if (item.link != null)
                                    TextButton(
                                      onPressed: () {
                                        launchUrl(Uri.parse(item.link!));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'ссылка',
                                            style: TextStyleBook.title17,
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.open_in_new,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      if (!isMyWish) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('владелец', style: TextStyleBook.text14),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: InkWell(
                            hoverColor: Colors.transparent,
                            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                            onTap: () {
                              mainBloc.router.goTo(UserPageRoute(userId: item.user.id));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: item.user.photoUrl != null ? NetworkImage(item.user.photoUrl!) : null,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.user.displayName,
                                      style: TextStyleBook.title17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (item.description != null && item.description!.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text('описание', style: TextStyleBook.text14),
                        ),
                        const SizedBox(height: 10),
                        Card(
                          child: SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(item.description ?? '', style: TextStyleBook.text14),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            if (!isLoading) const _LoadedBottomBar()
          ],
        ),
      ),
    );
  }
}

class _LoadedBottomBar extends StatelessWidget {
  const _LoadedBottomBar();

  @override
  Widget build(BuildContext context) {
    final isMyWish = context.select((WishVM vm) => vm.isMyWish);

    if (isMyWish) {
      return const SizedBox();
    }

    return const Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 30),
      child: _ReserveWishButton(isExpaned: true),
    );
  }
}
