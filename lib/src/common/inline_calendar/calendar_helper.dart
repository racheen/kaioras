import 'package:intl/intl.dart';

DateTime getMondayOfCurrentWeek() {
  DateTime now = DateTime.now();
  int daysToSubtract = now.weekday - DateTime.monday;
  DateTime mondayOfCurrentWeek = DateTime.now().subtract(
    Duration(days: daysToSubtract),
  );
  return mondayOfCurrentWeek;
}

DateTime getStartOfPreviousMonth(DateTime dateTime) {
  DateTime firstDayOfCurrentMonth = DateTime(dateTime.year, dateTime.month, 1);

  DateTime startOfPreviousMonth = DateTime(
    firstDayOfCurrentMonth.year,
    firstDayOfCurrentMonth.month - 1,
    1,
  );

  return startOfPreviousMonth;
}

DateTime getStartDayOfNextMonth(DateTime currentDate) {
  return DateTime(currentDate.year, currentDate.month + 1, 1);
}

DateTime getStartDayOfMonth(DateTime currentDate) {
  return DateTime(currentDate.year, currentDate.month, 1);
}

String getMonthName(int monthNumber) {
  if (monthNumber < 1 || monthNumber > 12) {
    throw ArgumentError('Month number must be between 1 and 12.');
  }
  final DateTime date = DateTime(2000, monthNumber, 1);
  return DateFormat('MMM').format(date);
}
