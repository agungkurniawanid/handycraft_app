import 'package:intl/intl.dart';

extension DateStringExtension on String {
  DateTime toDate() {
    return DateTime.parse(this);
  }

  String toDisplayFormat() {
    try {
      final date = DateTime.parse(this);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return this;
    }
  }
}
