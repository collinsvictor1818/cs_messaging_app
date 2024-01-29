import 'package:cs_messaging_app/features/messaging/presentation/auth/log_in.dart';
import 'package:cs_messaging_app/features/messaging/presentation/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'features/messaging/data/auth/auth_service.dart';
import 'firebase_options.dart';
import 'styles/theme/dark_theme.dart';
import 'styles/theme/light_theme.dart';
import 'utils/user_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => UserController());
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: GetMaterialApp(
        color: Theme.of(context).colorScheme.background,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const LogInUser(),
        initialBinding: UserBindings(),
      ),
    );
  }
}

class UserBindings implements Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<UserController>(() => UserController());
  }
}
