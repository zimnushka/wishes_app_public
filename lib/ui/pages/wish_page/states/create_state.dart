part of '../wish_page.dart';

class _WishPageCreate extends StatefulWidget {
  const _WishPageCreate();

  @override
  State<_WishPageCreate> createState() => _WishPageCreateState();
}

class _WishPageCreateState extends State<_WishPageCreate> {
  final pageController = PageController();
  int curPageIndex = 0;

  void changePage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        context.read<MainBloc>().router.pop();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  scrollBehavior: const ScrollBehavior().copyWith(
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                  onPageChanged: (val) {
                    curPageIndex = val;
                    setState(() {});
                  },
                  controller: pageController,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    if (index == 1) {
                      return const _AddFieldsCreateState();
                    }
                    return _AddLinkCreateState(
                      toNextPage: () {
                        changePage(1);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddLinkCreateState extends StatelessWidget {
  const _AddLinkCreateState({required this.toNextPage});
  final VoidCallback toNextPage;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final isLoading = context.select((WishVM vm) => vm.isLoading);
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _LinkInput(
                  onUpdatePreviewData: () async {
                    final link = vm.extractLinkFromLinkControllerText();
                    if (link == null) return;
                    await vm.getPreview(link);
                    if (!context.mounted) return;
                    toNextPage();
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: toNextPage,
                child: const Text(
                  'продолжить без ссылки',
                ),
              ),
            ],
          );
  }
}

class _AddFieldsCreateState extends StatelessWidget {
  const _AddFieldsCreateState();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final image = context.select((WishVM vm) => vm.image);
    final isLoading = context.select((WishVM vm) => vm.isLoading);
    final isEditOrCreateBTNActive = context.select((WishVM vm) => vm.isEditOrCreateBTNActive);
    return Column(
      children: [
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
                            color: image == null ? Theme.of(context).disabledColor : null,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            image: image != null
                                ? DecorationImage(
                                    image: MemoryImage(image.bytes),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    if (image != null && !isLoading)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                Text('${image.size.toStringAsFixed(2)} KB'),
                                const SizedBox(width: 20),
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
                _LinkInput(
                  onUpdatePreviewData: () {
                    final link = vm.extractLinkFromLinkControllerText();
                    if (link == null) return;
                    vm.getPreview(link);
                  },
                ),
                const SizedBox(height: 20),
                const _DescriptionInput(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: _EditWishButton(
            text: 'Создать хотелку',
            isDisable: !isEditOrCreateBTNActive || isLoading,
            onAction: vm.create,
          ),
        ),
      ],
    );
  }
}
