import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _currency = NumberFormat.currency(locale: 'de_DE', symbol: '€');
  static final _decimal =
      NumberFormat.decimalPattern('de_DE')..minimumFractionDigits = 2;
  static final _shortDecimal =
      NumberFormat.decimalPattern('de_DE')..minimumFractionDigits = 1;
  static final _date = DateFormat.yMMMd('de_DE');

  static String currency(num value) => _currency.format(value);
  static String decimal(num value) => _decimal.format(value);
  static String shortDecimal(num value) => _shortDecimal.format(value);
  static String date(DateTime value) => _date.format(value);
}
