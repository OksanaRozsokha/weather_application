import 'package:flutter_test/flutter_test.dart';
import 'package:weather_application/common/utils/dates_operations.dart';

void main() {
  group('Test dates operations:', () {
    group('Transform weekday int to weekday name:', () {
      List<String> weekdaysNamesList = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
        ''
      ];

      for (int i = 1; i <= 8; i++) {
        int weekdayIndex = i - 1;

        test(weekdaysNamesList[weekdayIndex], () {
          expect(DatesOperations.weekDayIntToWeekDayName(i),
              weekdaysNamesList[weekdayIndex]);
        });
      }
    });

    group('Transform month int to month name:', () {
      List<String> monthNamesList = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
        '',
      ];

      for (int i = 1; i <= 13; i++) {
        int monthIndex = i - 1;

        test(monthNamesList[monthIndex], () {
          expect(DatesOperations.monthIntToMonthName(i),
              monthNamesList[monthIndex]);
        });
      }
    });
  });
}
