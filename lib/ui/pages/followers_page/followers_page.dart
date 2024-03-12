import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'package:wishes_app/router/routes/user.dart';
import 'package:wishes_app/ui/pages/followers_page/followers_vm.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';
import 'package:wishes_app/ui/widgets/back_button.dart';

class FollowersPage extends StatelessWidget {
  const FollowersPage({
    required this.followedBy,
    required this.userId,
    super.key,
  });
  final String? userId;
  final bool followedBy;

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final userMeId = context.select((MainBloc vm) => vm.state.authState.user.id);

    return Material(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: ChangeNotifierProvider(
            create: (context) => FollowersVM(
              mainBloc: mainBloc,
              followedBy: followedBy,
              userId: userId ?? userMeId,
            ),
            child: const _FollowersPageView(),
          ),
        ),
      ),
    );
  }
}

class _FollowersPageView extends StatelessWidget {
  const _FollowersPageView();
  @override
  Widget build(BuildContext context) {
    final vm = context.read<FollowersVM>();
    final followedBy = vm.followedBy;
    final mainBloc = context.read<MainBloc>();
    final users = context.select((FollowersVM vm) => vm.users);

    return RefreshIndicator.adaptive(
      color: Theme.of(context).primaryColor,
      onRefresh: vm.getItems,
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
                      followedBy ? 'Подписчики' : 'Подписки',
                      style: TextStyleBook.title20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return _ItemCard(
                  key: ValueKey(users[index].id),
                  item: users[index],
                  onTap: () {
                    mainBloc.router.goTo(
                      UserPageRoute(
                        userId: users[index].id,
                        onSubscribeChangeState: () {},
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.item,
    required this.onTap,
    super.key,
  });
  final User item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<FollowersVM>();
    final followedBy = vm.followedBy;
    final isMyProfile = context.select((MainBloc vm) => vm.state.authState.user.id) == vm.userId;
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: item.photoUrl == null ? null : NetworkImage(item.photoUrl!),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      item.displayName,
                      style: TextStyleBook.title17,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.phone != null && item.phone!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          item.phone!,
                          style: TextStyleBook.text12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (item.email != null && item.email!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          item.email!,
                          style: TextStyleBook.text12,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              if (!followedBy && isMyProfile)
                InkWell(
                  onTap: () {
                    vm.unSubscribe(item.id);
                  },
                  child: const Icon(Icons.close),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
