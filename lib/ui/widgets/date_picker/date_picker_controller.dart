import 'package:flutter/material.dart';

class DatePickerController extends ChangeNotifier {
  final TabController tabController;
  final DateTime? initDate;
  final DateTime startDate;
  final DateTime lastDate;
  final Function(DateTime) onSelectDate;
  final VoidCallback? onCancel;

  DatePickerController({
    required this.onSelectDate,
    required TickerProvider vsync,
    this.onCancel,
    this.initDate,
    DateTime? lastDate,
    DateTime? startDate,
  })  : tabController = TabController(length: 3, vsync: vsync),
        startDate = startDate ?? DateTime(1900),
        lastDate = lastDate ?? DateTime(3000) {
    _init();
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void _init() {
    _selectedDate = initDate ?? DateTime.now();
    notifyListeners();
  }

  setYear(int year) {
    if (year >= startDate.year && year <= lastDate.year && year != selectedDate.year) {
      _selectedDate = DateTime(year, selectedDate.month, selectedDate.day);
      notifyListeners();
    }
  }

  setMonth(int month) {
    _selectedDate = DateTime(selectedDate.year, month, selectedDate.day);
    notifyListeners();
  }

  setDay(int day) {
    _selectedDate = DateTime(selectedDate.year, selectedDate.month, day);
    notifyListeners();
  }

  showYears() {
    tabController.animateTo(0);
  }

  showMonths() {
    tabController.animateTo(1);
  }

  showDays() {
    tabController.animateTo(2);
  }

  onAcceptTap() {
    onSelectDate(selectedDate);
  }

  onCancelTap() {
    onCancel?.call();
  }

  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    tabController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
