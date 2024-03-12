part of '../date_picker.dart';

class _YearsView extends StatefulWidget {
  const _YearsView();

  @override
  State<_YearsView> createState() => _YearsViewState();
}

class _YearsViewState extends State<_YearsView> with WidgetsBindingObserver {
  final scrollController = ScrollController();
  static const _yearCardHeight = 50.0;
  static const _yearCardPadding = 10.0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final vm = context.read<DatePickerController>();
      final indexSelectedDate = vm.selectedDate.year - vm.startDate.year;
      if (indexSelectedDate > 0) {
        final positionSelectedDate = (_yearCardHeight + _yearCardPadding) * (indexSelectedDate ~/ 3) - 30;
        scrollController.jumpTo(positionSelectedDate);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<DatePickerController>();
    final selectedDate = context.select((DatePickerController vm) => vm.selectedDate);

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: _yearCardPadding,
        crossAxisSpacing: 10,
        mainAxisExtent: _yearCardHeight,
      ),
      itemCount: vm.lastDate.year - vm.startDate.year,
      itemBuilder: (context, index) {
        final data = vm.startDate.year + index;
        return InkWell(
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          hoverColor: Colors.transparent,
          onTap: () {
            vm.setYear(data);
            vm.showMonths();
          },
          child: Card(
            color: selectedDate.year == data ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
            child: Center(
              child: Text(
                data.toString(),
                style: TextStyleBook.text14,
              ),
            ),
          ),
        );
      },
    );
  }
}
