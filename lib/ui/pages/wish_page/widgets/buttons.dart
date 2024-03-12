part of '../wish_page.dart';

class _ShareWishButton extends StatelessWidget {
  const _ShareWishButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final route = WishPageRoute(wishId: context.read<WishVM>().wishId);
        Share.share(
          route.toUri(config: context.read<MainBloc>().state.config).toString(),
        );
      },
      child: const ShareIcon(),
    );
  }
}

class _PopUpMenuViewState extends StatelessWidget {
  const _PopUpMenuViewState({
    required this.onDeleteTap,
    required this.onEditTap,
  });
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final foregroundColor = Theme.of(context).iconTheme.color;
    final isArchived = context.select((WishVM vm) => vm.item.isArchived);
    return PopupMenuButton(
      color: Theme.of(context).cardColor,
      surfaceTintColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () {
            if (isArchived) {
              vm.unArchive();
            } else {
              vm.archive();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              isArchived ? 'Вернуть' : 'Архивировать',
              style: TextStyleBook.title17.copyWith(color: foregroundColor),
            ),
          ),
        ),
        PopupMenuItem(
          onTap: onEditTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Редактировать',
              style: TextStyleBook.title17.copyWith(color: foregroundColor),
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            AlertModal.show(
              context: context,
              title: 'Удалить хотелку?',
              description: 'Вы хотите удалить хотелку навсегда?',
              onAccept: onDeleteTap,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Удалить',
              style: TextStyleBook.title17.copyWith(
                color: ColorsBook.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReserveWishButton extends StatelessWidget {
  const _ReserveWishButton({this.isExpaned = false});
  final bool isExpaned;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final reservedById = context.select((WishVM vm) => vm.item.reservedById);
    final userId = context.select((MainBloc vm) => vm.state.authState.user.id);

    final isReserved = reservedById != null;
    final isReservedByMe = reservedById == userId;

    return isReserved
        ? isReservedByMe
            ? OutlinedButton(
                onPressed: vm.unReserve,
                child: SizedBox(
                  height: 45,
                  width: isExpaned ? double.infinity : null,
                  child: Center(
                    child: Text(
                      'Отменить резервирование'.toUpperCase(),
                      style: TextStyleBook.text14,
                    ),
                  ),
                ),
              )
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Эта хотелка уже зарезервирована',
                      style: TextStyleBook.title17,
                    ),
                  ),
                ),
              )
        : ElevatedButton(
            onPressed: vm.reserve,
            child: SizedBox(
              height: 45,
              width: isExpaned ? double.infinity : null,
              child: Center(
                child: Text(
                  'Зарезервировать'.toUpperCase(),
                  style: TextStyleBook.text14,
                ),
              ),
            ),
          );
  }
}

class _EditWishButton extends StatelessWidget {
  const _EditWishButton({
    required this.text,
    required this.onAction,
    required this.isDisable,
  });
  final String text;
  final VoidCallback onAction;
  final bool isDisable;
  static const double height = 60;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            minimumSize: const Size(double.infinity, height),
          ),
          onPressed: isDisable ? null : onAction,
          child: Text(text.toLowerCase()),
        ),
      ),
    );
  }
}
