part of '../date_picker.dart';

class _MonthsView extends StatelessWidget {
  const _MonthsView();

  static const _monthCardHeight = 50.0;
  static const _monthCardPadding = 10.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<DatePickerController>();
    final selectedDate = context.select((DatePickerController vm) => vm.selectedDate);

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: _monthCardPadding,
        crossAxisSpacing: 10,
        mainAxisExtent: _monthCardHeight,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final date = DateTime(selectedDate.year, index + 1);
        return InkWell(
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          hoverColor: Colors.transparent,
          onTap: () {
            vm.setMonth(date.month);
            vm.showDays();
          },
          child: Card(
            color: selectedDate.month == date.month ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
            child: Center(
              child: Text(
                DateFormat('MMMM', 'ru').format(date).toUpperCase(),
                style: TextStyleBook.text14,
              ),
            ),
          ),
        );
      },
    );
  }
}
