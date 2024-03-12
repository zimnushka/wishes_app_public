import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishes_app/bloc/events/change_theme_event.dart';
import 'package:wishes_app/bloc/events/logout_event.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/domain/firebase/push_notification.dart';
import 'package:wishes_app/helpers/error_helper.dart';
import 'package:wishes_app/repository/api/api_repository.dart';
import 'package:wishes_app/router/routes/archive_wish.dart';
import 'package:wishes_app/router/routes/edit_profile.dart';
import 'package:wishes_app/ui/modals/alert_modal.dart';
import 'package:wishes_app/ui/styles/colors_book.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';
import 'package:wishes_app/ui/widgets/app_switch.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    final user = context.select((MainBloc vm) => vm.state.authState.user);
    final isDarkTheme = context.select((MainBloc vm) => vm.state.isDarkTheme);
    final isDebug = context.select((MainBloc vm) => vm.state.config.isDebug);

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(context).primaryColor,
                          backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: TextStyleBook.title20,
                            ),
                            if (user.email != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  user.email!,
                                  style: TextStyleBook.text14,
                                ),
                              ),
                            if (user.phone != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  user.phone!,
                                  style: TextStyleBook.text14,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RouteButton(
                          label: 'Редактировать профиль',
                          onTap: () {
                            mainBloc.router.goTo(EditProfilePageRoute());
                          },
                        ),
                        const Divider(),
                        _RouteButton(
                          label: 'Архив хотелок',
                          onTap: () {
                            mainBloc.router.goTo(ArchivedWishesPageRoute());
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: Text(
                      'Тема',
                      style: TextStyleBook.title17,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: AppSwitch(
                            firstLabel: 'Темная',
                            secondLabel: 'Светлая',
                            isFirstSelected: isDarkTheme,
                            onChange: (val) {
                              mainBloc.add(ChangeThemeEvent(isDarkTheme: !isDarkTheme));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isDebug) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: Text(
                        'TEST FUNCTIONS',
                        style: TextStyleBook.title17,
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _RouteButton(
                            label: 'COPY TOKENS',
                            onTap: () async {
                              final apiToken = mainBloc.state.repo.token;
                              final pushToken = await FirebasePush.getToken();
                              Clipboard.setData(ClipboardData(text: '''
                              API TOKEN: $apiToken
                              PUSH TOKEN: $pushToken
                              '''));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                    child: Text(
                      'Опасная зона',
                      style: TextStyleBook.title17,
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RouteButton(
                          label: 'Удалить профиль',
                          isRed: true,
                          onTap: () {
                            AlertModal.show(
                                context: context,
                                title: 'Вы хотите удалить ваш аккаунт?',
                                description: 'Все вашы данные, будут удалены навсегда',
                                onAccept: () async {
                                  await ErrorHelper.catchError(
                                    mainBloc: mainBloc,
                                    func: () async {
                                      await mainBloc.state.repo.deleteAccount();
                                      mainBloc.add(LogoutEvent());
                                    },
                                  );
                                });
                          },
                        ),
                        const Divider(),
                        _RouteButton(
                          label: 'Выйти',
                          isRed: true,
                          onTap: () {
                            AlertModal.show(
                              context: context,
                              title: 'Вы хотите выйти из аккаунта?',
                              description: '',
                              onAccept: () {
                                mainBloc.add(LogoutEvent());
                              },
                            );
                          },
                        ),
                      ],
                    ),
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

class _RouteButton extends StatelessWidget {
  const _RouteButton({
    required this.label,
    required this.onTap,
    this.isRed = false,
  });
  final String label;
  final bool isRed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
      onTap: onTap,
      child: SizedBox(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyleBook.text14.copyWith(
                  color: isRed ? ColorsBook.error : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
