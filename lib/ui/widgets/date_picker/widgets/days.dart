part of '../date_picker.dart';

class _DaysView extends StatelessWidget {
  const _DaysView();

  static const _dayCardHeight = 50.0;
  static const _dayCardPadding = 5.0;

  int lastDayOfMonth(DateTime date) => DateTime(date.year, date.month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<DatePickerController>();
    final selectedDate = context.select((DatePickerController vm) => vm.selectedDate);

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: _dayCardPadding,
        crossAxisSpacing: 5,
        mainAxisExtent: _dayCardHeight,
      ),
      itemCount: lastDayOfMonth(selectedDate),
      itemBuilder: (context, index) {
        final date = DateTime(selectedDate.year, selectedDate.month, index + 1);
        return InkWell(
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          hoverColor: Colors.transparent,
          onTap: () {
            vm.setDay(date.day);
          },
          child: Card(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            color: selectedDate.day == date.day ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.background,
            child: Center(
              child: Text(
                date.day.toString(),
                style: TextStyleBook.title17,
              ),
            ),
          ),
        );
      },
    );
  }
}
