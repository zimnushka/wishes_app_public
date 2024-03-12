import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishes_app/bloc/main_bloc.dart';
import 'package:wishes_app/helpers/color_helper.dart';
import 'package:wishes_app/router/routes/user.dart';
import 'package:wishes_app/router/routes/wish.dart';
import 'package:wishes_app/ui/modals/alert_modal.dart';
import 'package:wishes_app/ui/pages/wish_page/wish_vm.dart';
import 'package:wishes_app/ui/styles/colors_book.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';
import 'package:wishes_app/ui/widgets/back_button.dart';
import 'package:wishes_app/ui/widgets/close_button.dart';
import 'package:wishes_app/ui/widgets/responsive_ui.dart';
import 'package:wishes_app/ui/widgets/share_icon.dart';

part 'widgets/inputs.dart';
part 'widgets/buttons.dart';
part 'states/create_state.dart';
part 'states/edit_state.dart';
part 'states/mobile/view_state.dart';
part 'states/desctop/view_state.dart';

class WishPage extends StatelessWidget {
  const WishPage({
    required this.wishId,
    this.initImageLink,
    this.onUpdate,
    super.key,
  });
  final String? wishId;
  final String? initImageLink;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    final mainBloc = context.read<MainBloc>();
    return ChangeNotifierProvider(
      create: (context) => WishVM(
        mainBloc: mainBloc,
        wishId: wishId,
        onUpdate: onUpdate,
        initImageLink: initImageLink,
      ),
      child: Builder(builder: (context) {
        final state = context.select((WishVM vm) => vm.state);
        return ResponsiveUi(
          builder: (context, mode) {
            switch (state) {
              case WishPageState.edit:
                switch (mode) {
                  case ResponsiveUiMode.mobile:
                    return const _WishPageEdit();
                  case ResponsiveUiMode.desctop:
                    return const _WishPageEdit();
                }
              case WishPageState.view:
                switch (mode) {
                  case ResponsiveUiMode.mobile:
                    return const _WishPageMobile();
                  case ResponsiveUiMode.desctop:
                    return const _WishPageDesctop();
                }

              case WishPageState.create:
                switch (mode) {
                  case ResponsiveUiMode.mobile:
                    return const _WishPageCreate();
                  case ResponsiveUiMode.desctop:
                    return const _WishPageCreate();
                }
            }
          },
        );
      }),
    );
  }
}
