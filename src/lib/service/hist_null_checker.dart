import 'package:uuid/uuid.dart';

class HistNullChecker {
  static String keyMaker() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
