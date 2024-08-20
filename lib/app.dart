import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/generated/l10n.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LanguageController extends GetxController {
  var locale = const Locale('en').obs;
  var currentLanguage = 'en'.obs;

  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
    locale.value = Locale(languageCode);
    Get.updateLocale(locale.value);
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.put(LanguageController());
    return GetMaterialApp(
      locale: languageController.locale.value,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      themeMode: ThemeMode.system,
      theme: RAppTheme.lightTheme,
      darkTheme: RAppTheme.darkTheme,
      home: const Scaffold(
        backgroundColor: RColors.primary,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
