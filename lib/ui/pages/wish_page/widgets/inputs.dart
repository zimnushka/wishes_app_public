part of '../wish_page.dart';

class _LinkInput extends StatefulWidget {
  const _LinkInput({this.onUpdatePreviewData});
  final VoidCallback? onUpdatePreviewData;

  @override
  State<_LinkInput> createState() => _LinkInputState();
}

class _LinkInputState extends State<_LinkInput> {
  static const _animationDuration = Duration(milliseconds: 400);
  static const _animationCurve = Curves.easeInOutExpo;

  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  bool isShowAcceptBTN = false;

  void controllerListener() {
    if (widget.onUpdatePreviewData == null) {
      isShowAcceptBTN = false;
      return;
    }
    if (!mounted) return;
    // Если ссылка пуста
    if (controller.text.isEmpty) {
      isShowAcceptBTN = false;
      setState(() {});
      return;
    }
    // Если ссылка есть
    final vm = context.read<WishVM>();
    final isValidate = vm.linkTextValidate;

    if (isShowAcceptBTN != isValidate) {
      isShowAcceptBTN = isValidate;
      setState(() {});
    }
  }

  @override
  void initState() {
    final vm = context.read<WishVM>();
    controller = vm.linkTextController;
    focus = vm.linkFocus;

    controllerListener();
    controller.addListener(controllerListener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = context.select((WishVM vm) => vm.linkError);
    final isLoading = context.select((WishVM vm) => vm.isLoading);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: isLoading,
                    textInputAction: TextInputAction.done,
                    focusNode: focus,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Ссылка на товар',
                      error: error != null ? const SizedBox() : null,
                    ),
                  ),
                ),
                AnimatedSize(
                  alignment: Alignment.centerLeft,
                  duration: _animationDuration,
                  curve: _animationCurve,
                  child: SizedBox(
                    width: isShowAcceptBTN ? 125 : 0,
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: SizedBox(
                width: 115,
                child: AnimatedSlide(
                  duration: _animationDuration,
                  curve: _animationCurve,
                  offset: isShowAcceptBTN ? Offset.zero : const Offset(1, 0),
                  child: AnimatedScale(
                    curve: _animationCurve,
                    scale: isShowAcceptBTN ? 1 : 0,
                    duration: _animationDuration,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                        ),
                        onPressed: () {
                          widget.onUpdatePreviewData?.call();
                        },
                        child: const Text('применить'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              error,
              style: TextStyleBook.text12.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _TitleInput extends StatelessWidget {
  const _TitleInput();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final controller = vm.titleTextController;
    final focus = vm.titleFocus;
    final error = context.select((WishVM vm) => vm.titleError);
    final isLoading = context.select((WishVM vm) => vm.isLoading);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: isLoading,
          controller: controller,
          focusNode: focus,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Название',
            error: error != null ? const SizedBox() : null,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              error,
              style: TextStyleBook.text12.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final controller = vm.descTextController;
    final focus = vm.descFocus;
    final error = context.select((WishVM vm) => vm.descError);
    final isLoading = context.select((WishVM vm) => vm.isLoading);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: isLoading,
          controller: controller,
          focusNode: focus,
          decoration: InputDecoration(
            hintText: 'Описание',
            error: error != null ? const SizedBox() : null,
          ),
          textInputAction: TextInputAction.next,
          minLines: null,
          maxLines: 6,
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              error,
              style: TextStyleBook.text12.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WishVM>();
    final controller = vm.priceTextController;
    final focus = vm.priceFocus;
    final error = context.select((WishVM vm) => vm.priceError);
    final isLoading = context.select((WishVM vm) => vm.isLoading);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          readOnly: isLoading,
          controller: controller,
          focusNode: focus,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Цена',
            error: error != null ? const SizedBox() : null,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Text(
              error,
              style: TextStyleBook.text12.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
