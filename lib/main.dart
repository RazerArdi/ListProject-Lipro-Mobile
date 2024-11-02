import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core
import 'package:lipro_mobile/app/routes/app_pages.dart';
import 'package:lipro_mobile/app/modules/home/bindings/initial_bindings.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: "assets/.env");

  // Ensure widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(); // Add this line to initialize Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UpTodo',
      initialRoute: '/splash',
      getPages: AppPages.routes,
      initialBinding: InitialBindings(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}
