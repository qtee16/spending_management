import 'package:intl/intl.dart' as intl;

class Constants {

  static String urlImage = 'https://scontent.fsgn5-9.fna.fbcdn.net/v/t39.30808-6/272970922_3073219432940445_3711955370304684567_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=eSrAF8m37VEAX_RjiXP&_nc_ht=scontent.fsgn5-9.fna&oh=00_AT-vp2ysujmUQnQSe3QQrD_-1aBEgqWvHd1XG35PtnqVxw&oe=6340DC36';

  static List<int> monthKeys = List<int>.generate(12, (index) => index + 1);

  static Map<String, String> months = {
    'jan': 'Tháng 1',
    'feb': 'Tháng 2',
    'mar': 'Tháng 3',
    'apr': 'Tháng 4',
    'may': 'Tháng 5',
    'jun': 'Tháng 6',
    'jul': 'Tháng 7',
    'aug': 'Tháng 8',
    'sep': 'Tháng 9',
    'oct': 'Tháng 10',
    'nov': 'Tháng 11',
    'dec': 'Tháng 12',
  };

  static List<int> years = List<int>.generate(100, (index) => DateTime.now().year - index);

  static final formatter = intl.NumberFormat.decimalPattern();

}