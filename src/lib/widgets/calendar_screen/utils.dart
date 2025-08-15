import 'dart:collection';

import 'package:prob/model/expense.dart';
import 'package:table_calendar/table_calendar.dart';

final kEvents = LinkedHashMap<DateTime, List<Expense>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final Map<DateTime, List<Expense>> _kEventSource = {}..addAll(
    {
      kToday: [
        Expense(
            id: 1,
            date: DateTime.now(),
            amount: 4500,
            title: '아메리카노',
            category: '카페',
            memo: 'ICE',
            account: '현대카드'),
        Expense(
            id: 2,
            date: DateTime.now(),
            amount: 8200,
            title: '점심-김치찌개',
            category: '식비',
            account: '카카오뱅크'),
        Expense(
            id: 3,
            date: DateTime.now(),
            amount: 1350,
            title: '버스',
            category: '교통'),
      ],
    },
  );

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
