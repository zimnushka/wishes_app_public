part of '../user_page.dart';

class _SubscribeButton extends StatelessWidget {
  const _SubscribeButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UserVM>();
    final isSubscribed = context.select((UserVM vm) => vm.isInSubscribed);
    final isLoading = context.select((UserVM vm) => vm.isLoading);

    return ResponsiveUi(
      builder: (context, mode) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: mode == ResponsiveUiMode.desctop ? 300 : double.infinity),
          child: isSubscribed
              ? OutlinedButton(
                  onPressed: isLoading ? null : vm.unSubscribe,
                  child: Text(
                    'Вы подписаны',
                    style: TextStyleBook.text14.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: isLoading ? null : vm.subscribe,
                  child: Text(
                    'Подписаться',
                    style: TextStyleBook.text14.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).cardColor,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
