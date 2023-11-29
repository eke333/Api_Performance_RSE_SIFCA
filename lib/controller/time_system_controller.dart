import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TimeSystemController {
  static List<int> years = [];
  static DateTime date = DateTime(0);

  static Future initDateTime() async {
    const storage = FlutterSecureStorage();
    DateTime dateNow = DateTime.now();
    date = dateNow;
    final yearsList = [dateNow.year-2,dateNow.year-1,dateNow.year];
    years = yearsList;
    await storage.write(key: "isInitTime", value: "true");
  }

}