import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/src/common/inline_calendar/monthy_selector.dart';
import 'package:flutter_riverpod_boilerplate/src/common/inline_calendar/weekly_selector.dart';
import 'package:flutter_riverpod_boilerplate/src/common/inline_calendar/calendar_helper.dart';

class InlineCalendar extends StatefulWidget {
  const InlineCalendar({super.key});

  @override
  State<InlineCalendar> createState() => _InlineCalendarState();
}

class _InlineCalendarState extends State<InlineCalendar> {
  DateTime _selectedDate = DateTime.now();
  DateTime _currentWeekTimeline = getMondayOfCurrentWeek();
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobileView = screenWidth < 900;

    void getPreviousWeek() {
      setState(() {
        final timelineMonth = _currentWeekTimeline.month;
        _currentWeekTimeline = _currentWeekTimeline.subtract(Duration(days: 7));
        if (_currentWeekTimeline.month != timelineMonth) {
          _currentMonth = _currentWeekTimeline;
        }
      });
    }

    void getNextWeek() {
      setState(() {
        final timelineMonth = _currentWeekTimeline.month;
        _currentWeekTimeline = _currentWeekTimeline.add(Duration(days: 7));
        if (_currentWeekTimeline.month != timelineMonth) {
          _currentMonth = _currentWeekTimeline;
        }
      });
    }

    void getToday() {
      setState(() {
        final timelineMonth = _currentWeekTimeline.month;
        _selectedDate = DateTime.now();
        _currentWeekTimeline = getMondayOfCurrentWeek();
        if (_currentWeekTimeline.month != timelineMonth) {
          _currentMonth = _currentWeekTimeline;
        }
      });
    }

    void getPreviousMonth() {
      setState(() {
        _currentWeekTimeline = getStartOfPreviousMonth(_currentMonth);
        _currentMonth = getStartOfPreviousMonth(_currentMonth);
      });
    }

    void getNextMonth() {
      setState(() {
        _currentWeekTimeline = getStartDayOfNextMonth(_currentMonth);
        _currentMonth = getStartDayOfNextMonth(_currentMonth);
      });
    }

    return Container(
      margin: EdgeInsets.all(0.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 416,
            child: EasyDateTimeLinePicker(
              firstDate: _currentWeekTimeline,
              lastDate: _currentWeekTimeline.add(Duration(days: 6)),
              headerOptions: HeaderOptions(headerType: HeaderType.viewOnly),
              focusedDate: _selectedDate,
              timelineOptions: TimelineOptions(padding: EdgeInsets.all(10)),
              selectionMode: SelectionMode.autoCenter(),
              itemExtent: 50,
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          Flexible(
            child: SizedBox(
              width: isMobileView ? null : 300,
              height: isMobileView ? null : 174,
              child: Column(
                mainAxisAlignment: isMobileView
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  MonthlySelector(
                    getPreviousMonth: getPreviousMonth,
                    getNextMonth: getNextMonth,
                    currentMonth: getMonthName(_currentMonth.month),
                  ),
                  WeeklySelector(
                    getPreviousWeek: getPreviousWeek,
                    getNextWeek: getNextWeek,
                    getToday: getToday,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
