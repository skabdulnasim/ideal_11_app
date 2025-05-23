import 'package:intl/intl.dart';

class Helpers {
  // Public method to format the date and time
  String formatToIST(String date, String time) {
    try {
      final utcDateTime = DateTime.parse('$date $time');
      final istDateTime = utcDateTime.toUtc().add(
        Duration(hours: 5, minutes: 30),
      );

      // Get today's and tomorrow's date
      final now = DateTime.now();
      final tomorrow = now.add(Duration(days: 1));

      // Compare only the date parts (year, month, day)
      final isToday =
          now.year == istDateTime.year &&
          now.month == istDateTime.month &&
          now.day == istDateTime.day;
      final isTomorrow =
          tomorrow.year == istDateTime.year &&
          tomorrow.month == istDateTime.month &&
          tomorrow.day == istDateTime.day;

      if (isToday) {
        // If the date matches today, format as "Today, hh:mm a"
        return "Today, ${DateFormat('h:mm a').format(istDateTime)}";
      } else if (isTomorrow) {
        // If the date matches tomorrow, format as "Tomorrow, hh:mm a"
        return "Tomorrow, ${DateFormat('h:mm a').format(istDateTime)}";
      } else {
        // Else return in the format "dd MMM yyyy, hh:mm a"
        return DateFormat('dd MMM yyyy, h:mm a').format(istDateTime);
      }
    } catch (e) {
      return "$date $time"; // Fallback if parsing fails
    }
  }
}
