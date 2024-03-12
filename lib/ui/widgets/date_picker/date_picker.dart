import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wishes_app/ui/styles/text_style_book.dart';
import 'package:wishes_app/ui/widgets/date_picker/date_picker_controller.dart';

part 'widgets/days.dart';
part 'widgets/months.dart';
part 'widgets/years.dart';

class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    required this.onSelectDate,
    this.onCancel,
    this.controller,
    this.initDate,
    this.startDate,
    this.lastDate,
    super.key,
  });
  final DatePickerController? controller;
  final DateTime? initDate;
  final DateTime? startDate;
  final DateTime? lastDate;
  final Function(DateTime) onSelectDate;
  final VoidCallback? onCancel;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.controller ??
          DatePickerController(
            onSelectDate: widget.onSelectDate,
            vsync: this,
            initDate: widget.initDate,
            startDate: widget.startDate,
            lastDate: widget.lastDate,
          ),
      child: const _DatePickerView(),
    );
  }
}

class _DatePickerView extends StatelessWidget {
  const _DatePickerView();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<DatePickerController>();
    final selectedDate = context.select((DatePickerController vm) => vm.selectedDate);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 500,
          ),
          child: Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    indicatorColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyleBook.title17.copyWith(color: Theme.of(context).primaryColor),
                    unselectedLabelStyle: TextStyleBook.title17.copyWith(color: Theme.of(context).iconTheme.color),
                    dividerColor: Theme.of(context).dividerColor,
                    controller: vm.tabController,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        text: selectedDate.year.toString(),
                      ),
                      Tab(
                        text: DateFormat('MMMM', 'ru').format(selectedDate).toUpperCase(),
                      ),
                      Tab(
                        text: selectedDate.day.toString(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: vm.tabController,
                    children: const [
                      _YearsView(),
                      _MonthsView(),
                      _DaysView(),
                    ],
                  ),
                ),
                ColoredBox(
                  color: Theme.of(context).dividerColor,
                  child: const SizedBox(
                    width: double.infinity,
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      vm.onCancel != null
                          ? OutlinedButton(
                              onPressed: vm.onCancelTap,
                              child: Text('Отмена'.toUpperCase()),
                            )
                          : const SizedBox(),
                      ElevatedButton(
                        onPressed: vm.onAcceptTap,
                        child: Text('Применить'.toUpperCase()),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
