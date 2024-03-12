import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/bloc/main_state.dart';
import 'package:wishes_app/domain/models/follower.dart';
import 'package:wishes_app/domain/models/wish.dart';
import 'package:wishes_app/helpers/color_helper.dart';
import 'package:wishes_app/router/routes/followers.dart';
import 'package:wishes_app/router/routes/user.dart';
import 'package:wishes_app/router/routes/wish.dart';
import 'package:wishes_app/ui/pages/user_page/user_vm.dart';
import 'package:wishes_app/ui/styles/colors_book.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';
import 'package:wishes_app/ui/widgets/app_bar_sliver_delegate.dart';
import 'package:wishes_app/ui/widgets/back_button.dart';
import 'package:wishes_app/ui/widgets/responsive_ui.dart';
import 'package:wishes_app/ui/widgets/share_icon.dart';

part 'widgets/subscribe_button.dart';
part 'widgets/user_info.dart';
part 'widgets/wish_card.dart';
part 'widgets/user_appbar.dart';

class UserPage extends StatelessWidget {
  const UserPage({this.userId, this.onSubscribeChangeState, this.showBackBTN = true, super.key});
  final String? userId;
  final bool showBackBTN;
  final VoidCallback? onSubscribeChangeState;

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (context) => UserVM(
        mainBloc: mainBloc,
        userId: userId ?? mainBloc.state.authState.user.id,
      ),
      child: _UserView(showBackBTN: showBackBTN),
    );
  }
}

class _UserView extends StatelessWidget {
  const _UserView({required this.showBackBTN});
  final bool showBackBTN;

  void share(BuildContext context) {
    final route = UserPageRoute(userId: context.read<UserVM>().userId);
    Share.share(
      route.toUri(config: context.read<MainBloc>().state.config).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserVM>();
    final mainBloc = context.read<MainBloc>();
    final isMyProfile = context.select((UserVM vm) => vm.isMyProfile);
    final items = context.select((UserVM vm) => vm.items);
    final isLoading = context.select((UserVM vm) => vm.isLoading);
    final user = context.select((UserVM vm) => vm.user);
    final reservedWishesCount = items.where((wish) => wish.reservedById != null).length;

    return BlocListener<MainBloc, MainState>(
      listenWhen: (prevState, state) {
        if (prevState.authState.user != state.authState.user && isMyProfile) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        vm.updateUserMeProfile(state.authState.user);
      },
      child: RefreshIndicator(
        onRefresh: vm.update,
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isMyProfile ? const _AddWishButton() : null,
            body: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: AppBarSliverDelegate(
                    maxHeight: showBackBTN ? 190 : 130,
                    minHeight: 84,
                    builder: (percent) {
                      return _UserAppBar(
                        percent: percent,
                        showBackBTN: showBackBTN,
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 50,
                          runSpacing: 20,
                          children: [
                            _InfoUserWidget(
                              label: 'Подписчики'.toUpperCase(),
                              followers: user.followedBy,
                              onTap: () {
                                mainBloc.router.goTo(
                                  FollowersPageRoute(
                                    followedBy: true,
                                    userId: user.id,
                                  ),
                                );
                              },
                            ),
                            _InfoUserWidget(
                              label: 'Подписки'.toUpperCase(),
                              followers: user.follows,
                              onTap: () {
                                mainBloc.router.goTo(
                                  FollowersPageRoute(
                                    followedBy: false,
                                    userId: user.id,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  ResponsiveUiMode.byWidth(MediaQuery.sizeOf(context).width) == ResponsiveUiMode.desctop ? 300 : double.infinity,
                            ),
                            child: SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: isMyProfile
                                  ? OutlinedButton(
                                      onPressed: () => share(context),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'поделиться списком'.toUpperCase(),
                                            style: TextStyleBook.text12,
                                          ),
                                          const SizedBox(width: 20),
                                          const ShareIcon(size: 16)
                                        ],
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        const Expanded(child: _SubscribeButton()),
                                        const SizedBox(width: 20),
                                        OutlinedButton(
                                          onPressed: () => share(context),
                                          child: const ShareIcon(),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'ХОТЕЛКИ',
                              style: TextStyleBook.text12,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$reservedWishesCount из ${items.length} зарезервировано',
                          style: TextStyleBook.text12,
                        ),
                      ],
                    ),
                  ),
                ),
                items.isEmpty && !isLoading
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 300),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture(
                                    const SvgAssetLoader('assets/icons/empty_wish_list.svg'),
                                    width: 100,
                                    height: 100,
                                    colorFilter: ColorFilter.mode(
                                      Theme.of(context).textTheme.titleMedium!.color!,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Text(
                                    isMyProfile
                                        ? 'Нажмите на "+", чтобы добавить свою хотелку'
                                        : '${user.displayName} еще не добавил список своих хотелок',
                                    style: TextStyleBook.title17,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                        sliver: SliverGrid.builder(
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
                if (items.isNotEmpty && !isLoading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: SizedBox(
                      height: 84,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddWishButton extends StatelessWidget {
  const _AddWishButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserVM>();
    return InkWell(
      onTap: () {
        final mainBloc = context.read<MainBloc>();
        mainBloc.router.goTo(
          WishPageRoute(
            onUpdate: vm.update,
          ),
        );
      },
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        elevation: 5,
        child: const SizedBox(
          width: 70,
          height: 70,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Icon(
              Icons.add,
              size: 30,
              color: ColorsBook.lightBase,
            ),
          ),
        ),
      ),
    );
  }
}
