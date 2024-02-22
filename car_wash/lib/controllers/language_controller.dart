import 'package:shared_preferences/shared_preferences.dart';

class LanguageController {
  String language = 'en';

  Future<void> setLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  Future<void> getLanguage({required Function() onSuccess}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language') != null) {
      language = prefs.getString('language')!;
      onSuccess();
      print(language);
    }
  }
}
