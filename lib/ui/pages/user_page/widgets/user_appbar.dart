part of '../user_page.dart';

class _UserAppBar extends StatelessWidget {
  const _UserAppBar({required this.percent, required this.showBackBTN});
  final double percent;
  final bool showBackBTN;

  void share(BuildContext context) {
    final route = UserPageRoute(userId: context.read<UserVM>().userId);
    Share.share(
      route.toUri(config: context.read<MainBloc>().state.config).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final user = context.select((UserVM vm) => vm.user);
    final avatarRadius = 22 + pow(percent, 6) * 18;

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 100),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 18, 30, 0),
          child: Stack(
            children: [
              showBackBTN
                  ? Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: BackButtonL(
                        onTap: mainBloc.router.pop,
                      ),
                    )
                  : const SizedBox(),
              Column(
                children: [
                  SizedBox(height: showBackBTN ? 60 * pow(percent, 4) as double : 0),
                  SizedBox(
                    height: avatarRadius * 2,
                    child: Row(
                      children: [
                        showBackBTN ? SizedBox(width: 55 * (1 - pow(percent, 6) as double)) : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).cardColor,
                              image: user.photoUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(user.photoUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: SizedBox(
                              width: avatarRadius * 2,
                              height: avatarRadius * 2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraint) {
                              return FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: SizedBox(
                                  width: constraint.maxWidth,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.displayName,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyleBook.title20.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
