import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Helpers {
  static String formatTimeAgo(DateTime time, [local = 'en']) {
    var diff = DateTime.now().millisecondsSinceEpoch - time.millisecondsSinceEpoch ?? 0;

    // since ago if interval less than 1 hour
    if (diff < 3600000) return timeago.format(time);

    return DateFormat.yMMMEd().add_jm().format(time);
  }
}
