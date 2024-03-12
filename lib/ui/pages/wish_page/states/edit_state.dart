part of '../wish_page.dart';

class _WishPageEdit extends StatelessWidget {
  const _WishPageEdit();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final isLoading = context.select((WishVM vm) => vm.isLoading);
    final deletePreviousImageInEdit = context.select((WishVM vm) => vm.deletePreviousImageInEdit);
    final isEditOrCreateBTNActive = context.select((WishVM vm) => vm.isEditOrCreateBTNActive);

    final image = context.select((WishVM vm) => vm.image);
    final imageUrl = context.select((WishVM vm) {
      return deletePreviousImageInEdit ? null : vm.imageUrl;
    });

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BackButtonL(
                      onTap: () {
                        vm.state = WishPageState.view;
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: isLoading ? null : vm.getImage,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: image == null && imageUrl == null ? Theme.of(context).disabledColor : null,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  image: image != null
                                      ? DecorationImage(
                                          image: MemoryImage(image.bytes),
                                          fit: BoxFit.cover,
                                        )
                                      : imageUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                ),
                              ),
                            ),
                          ),
                          if ((image != null || imageUrl != null) && !isLoading)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Row(
                                    children: [
                                      if (image != null)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: Text('${image.size.toStringAsFixed(2)} KB'),
                                        ),
                                      CloseButtonL(onTap: vm.deleteImage),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          'Обязательно',
                          style: TextStyleBook.text12,
                        ),
                      ),
                      const _TitleInput(),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(
                          'Дополнительно',
                          style: TextStyleBook.text12,
                        ),
                      ),
                      const _PriceInput(),
                      const SizedBox(height: 20),
                      _LinkInput(onUpdatePreviewData: () {
                        final link = vm.extractLinkFromLinkControllerText();
                        if (link == null) return;
                        vm.getPreview(link);
                      }),
                      const SizedBox(height: 20),
                      const _DescriptionInput(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: _EditWishButton(
                  text: 'сохранить',
                  isDisable: !isEditOrCreateBTNActive || isLoading,
                  onAction: vm.edit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
