import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_wash/controllers/language_controller.dart';

void main() {
  group('LanguageController', () {
    test('getLanguage sets language correctly!', () async {
      final languageController = LanguageController();
      languageController.language = 'ro';

      SharedPreferences.setMockInitialValues({'language': 'en'});

      await languageController.getLanguage(onSuccess: () {});

      expect(languageController.language, 'en');
    });

    test('setLanguage saves language correctly!', () async {
      final languageController = LanguageController();
      languageController.language = 'en';

      SharedPreferences.setMockInitialValues({'language': 'ro'});

      await languageController.setLanguage();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedLanguage = prefs.getString('language');
      expect(storedLanguage, 'en');
    });
  });
}
