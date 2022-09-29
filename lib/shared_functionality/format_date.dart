import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  final oneWeekLaterEnd = DateTime(
    DateTime.now().add(const Duration(days: 8)).year,
    DateTime.now().add(const Duration(days: 8)).month,
    DateTime.now().add(const Duration(days: 8)).day,
  );

  final tomorrowEnd = DateTime(
    DateTime.now().add(const Duration(days: 2)).year,
    DateTime.now().add(const Duration(days: 2)).month,
    DateTime.now().add(const Duration(days: 2)).day,
  );

  final todayEnd = DateTime(
    DateTime.now().add(const Duration(days: 1)).year,
    DateTime.now().add(const Duration(days: 1)).month,
    DateTime.now().add(const Duration(days: 1)).day,
  );

  final todayStart = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final yesterdayStart = DateTime(
    DateTime.now().subtract(const Duration(days: 1)).year,
    DateTime.now().subtract(const Duration(days: 1)).month,
    DateTime.now().subtract(const Duration(days: 1)).day,
  );

  final oneWeekAgoStart = DateTime(
    DateTime.now().subtract(const Duration(days: 7)).year,
    DateTime.now().subtract(const Duration(days: 7)).month,
    DateTime.now().subtract(const Duration(days: 7)).day,
  );

  if (dateTime.isAfter(tomorrowEnd) && dateTime.isBefore(oneWeekLaterEnd)) {
    return "After ${dateTime.difference(DateTime.now()).inDays + 1} days";
  }

  if (dateTime.isAfter(todayEnd) && dateTime.isBefore(tomorrowEnd)) {
    return "Tomorrow";
  }

  if (dateTime.isAfter(todayStart) && dateTime.isBefore(todayEnd)) {
    return "Today";
  }

  if (dateTime.isAfter(yesterdayStart) && dateTime.isBefore(todayStart)) {
    return "Yesterday";
  }

  if (dateTime.isAfter(oneWeekAgoStart) && dateTime.isBefore(yesterdayStart)) {
    return "${DateTime.now().difference(dateTime).inDays} days ago";
  }

  return DateFormat.MMMEd().format(dateTime);
}
