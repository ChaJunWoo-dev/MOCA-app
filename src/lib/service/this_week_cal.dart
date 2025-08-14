class ThisWeekCal {
  static int countRemainingDaysInCurrentWeek(DateTime today) {
    // 오늘이 속한 주의 시작일(월요일) 계산
    DateTime weekStart =
        today.subtract(Duration(days: today.weekday - 1)); // 월요일
    DateTime weekEnd = weekStart.add(const Duration(days: 6)); // 일요일

    // 이번 달의 시작일과 종료일 계산
    // DateTime firstDayOfMonth = DateTime(today.year, today.month, 1);
    DateTime lastDayOfMonth =
        DateTime(today.year, today.month + 1, 0); // 다음 달 0일 => 이번 달 마지막 날

    // 이번 주의 날짜 수를 계산
    int remainingDays;

    if (weekStart.month == today.month && weekEnd.month == today.month) {
      // 이번 주가 이번 달에 모두 포함된 경우
      remainingDays = 7; // 이번 주는 7일
    } else if (weekStart.month == today.month) {
      // 주의 시작일이 이번 달에 있는 경우
      remainingDays = weekEnd.day - weekStart.day + 1;
    } else if (weekEnd.month == today.month) {
      // 주의 종료일이 이번 달에 있는 경우
      remainingDays = lastDayOfMonth.day - weekStart.day + 1;
    } else {
      // 이번 달에 포함되지 않는 경우
      remainingDays = 0;
    }

    return remainingDays;
  }
}
