import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/models/user.dart';
import 'package:wishes_app/router/routes/user.dart';
import 'package:wishes_app/ui/pages/search_page/search_vm.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (context) => SearchVM(mainBloc: mainBloc),
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatelessWidget {
  const _SearchPageView();

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final vm = context.read<SearchVM>();
    final items = context.select((SearchVM vm) => vm.users);
    final isLoading = context.select((SearchVM vm) => vm.isLoading);
    final isSearchTextEmpty = context.select((SearchVM vm) => vm.isSearchTextEmpty);

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: vm.searchController,
                      onEditingComplete: vm.getItems,
                      style: TextStyleBook.title20,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        hintText: 'Найти пользователя',
                        suffixIcon: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: _InviteUser(),
                  ),
                  SliverToBoxAdapter(
                    child: isSearchTextEmpty && items.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: Text(
                              'Возможно вы знакомы',
                              style: TextStyleBook.title17,
                            ),
                          )
                        : items.isNotEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Divider(height: 1),
                              )
                            : const SizedBox(),
                  ),
                  SliverList.separated(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _UserCard(
                        onTap: () {
                          mainBloc.router.goTo(
                            UserPageRoute(
                              userId: items[index].id,
                              onSubscribeChangeState: () {},
                            ),
                          );
                        },
                        item: items[index],
                      );
                    },
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Divider(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.item,
    required this.onTap,
  });
  final VoidCallback onTap;
  final User item;

  @override
  Widget build(BuildContext context) {
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
              Column(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _InviteUser extends StatelessWidget {
  const _InviteUser();

  void share(BuildContext context) {
    final route = UserPageRoute(userId: context.read<MainBloc>().state.authState.user.id);
    Share.share(
      route.toUri(config: context.read<MainBloc>().state.config).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () => share(context),
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const SizedBox(
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'пригласить друга'.toUpperCase(),
                    style: TextStyleBook.title17,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
