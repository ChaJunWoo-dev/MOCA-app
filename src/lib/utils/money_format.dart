import 'package:intl/intl.dart';

final moneyFormat = NumberFormat('###,###,###,###');

String money(int money) => moneyFormat.format(money);
int parseMoney(String str) => int.parse(str.replaceAll(',', ''));
