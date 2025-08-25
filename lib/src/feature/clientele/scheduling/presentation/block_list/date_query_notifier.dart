import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateQueryNotifier extends AutoDisposeNotifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void setDateQuery(DateTime dateQuery) {
    state = dateQuery;
  }

  DateTime getDateQuery() {
    return state;
  }
}

final dateQueryNotifierProvider =
    NotifierProvider.autoDispose<DateQueryNotifier, DateTime>(() {
      return DateQueryNotifier();
    });
