import 'package:intl/intl.dart' as intl;

class Constants {

  static String urlImage = 'https://firebasestorage.googleapis.com/v0/b/spendingmanagement-3cf53.appspot.com/o/images%2Favatar%2Fdefault.png?alt=media&token=2fe716f6-534c-4889-a0d3-4c842e4add68';

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