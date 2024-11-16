import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myat_ecommerence/app/data/sendNotificationHandler.dart';
import 'package:myat_ecommerence/app/modules/auth-gate/bindings/auth_gate_binding.dart';
import 'package:myat_ecommerence/global_widgets/MyTranslations.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SendNotificationHandler.initialized();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    // Get the saved language from GetStorage
    String? savedLanguage = GetStorage().read('language') ?? 'ENG';

    runApp(
      GetMaterialApp(
        translations: MyTranslations(),
        // Set the locale dynamically based on the saved language
        locale: savedLanguage == 'ENG'
            ? const Locale('en', 'US')
            : const Locale('my', 'MM'),
        fallbackLocale:
            const Locale('en', 'US'), // Set a fallback language (e.g., English)
        title: "MyatEcommerce",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: AuthGateBinding(),
        debugShowCheckedModeBanner: false,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  });
}
