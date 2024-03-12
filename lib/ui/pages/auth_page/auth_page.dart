import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/ui/pages/auth_page/auth_vm.dart';
import 'package:wishes_app/ui/styles/icons.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';

part 'widgets/banner.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => AuthVM(mainBloc: mainBloc),
        child: const _AuthView(),
      ),
    );
  }
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<AuthVM>();
    final isLoading = context.select((AuthVM vm) => vm.isLoading);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
        ),
      );
    }

    return Column(
      children: [
        const Expanded(child: _Banner()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: OutlinedButton(
                    onPressed: isLoading || AuthVM.vkService == null
                        ? null
                        : () {
                            launchUrl(Uri.parse(vm.vkAuthUrl!), mode: LaunchMode.inAppBrowserView);

                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return _VkWebView(vm: vm);
                            //   },
                            // );
                          },
                    child: const AppIcon(
                      AppIcons.vk,
                      width: 25,
                      height: 25,
                    )),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          vm.googleSignIn();
                        },
                  child: const AppIcon(
                    AppIcons.google,
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
