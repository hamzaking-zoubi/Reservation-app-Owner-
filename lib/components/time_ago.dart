import 'package:intl/intl.dart';

class TimeAgo {

  static bool isSameDay(dataString) {
    DateTime sdate = DateTime.parse(dataString);
    int stimestamp = sdate.microsecondsSinceEpoch;
    DateTime notificationDate = DateTime.fromMicrosecondsSinceEpoch(stimestamp);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);
    if (diff.inDays > 0)
      return true;
    else
      return false;
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    print(dateString);
    DateTime sdate = DateTime.parse(dateString);
    int stimestamp = sdate.microsecondsSinceEpoch;
    DateTime notificationDate = DateTime.fromMicrosecondsSinceEpoch(stimestamp);
    print(notificationDate);
   // DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}
