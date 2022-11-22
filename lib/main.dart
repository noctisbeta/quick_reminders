import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:functional/functional.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quick_reminders/firebase/firebase_options.dart';
import 'package:quick_reminders/initialization/dynamic_link_manager.dart';
import 'package:quick_reminders/routing/route_controller.dart';

Future<Unit> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/LICENSE.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  GoogleFonts.config.allowRuntimeFetching = false;

  final container = ProviderContainer();

  kIsWeb ? await webSetup() : container.read(DynamicLinkManager.provider);

  final routerConfig = container.read(RouteController.provider).router;

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        title: 'Quick Reminders',
        routerConfig: routerConfig,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );

  return unit;
}

/// Web setup.
Future<Unit> webSetup() async {
  usePathUrlStrategy();
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  return unit;
}
