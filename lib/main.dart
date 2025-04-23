import 'package:cobros/firebase_options.dart';
import 'package:cobros/pages/admin-pages/add_user.dart';
import 'package:cobros/pages/admin-pages/pagos_page.dart';
import 'package:cobros/pages/admin-pages/usuarios_page.dart';
import 'package:cobros/pages/admin_page.dart';
import 'package:cobros/pages/cliente-pages/cliente_info.dart';
import 'package:cobros/pages/cliente-pages/cliente_payments.dart';
import 'package:cobros/pages/cliente_page.dart';
import 'package:cobros/pages/cobrador-pages/payments.dart';
import 'package:cobros/pages/cobrador-pages/scanner_page.dart';
import 'package:cobros/pages/cobrador_page.dart';
import 'package:cobros/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFA83F50),
        scaffoldBackgroundColor: Color(0xFFF5E6CA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA83F50),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFA83F50),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        // rama del administrador
        '/admin': (context) => const AdminPage(),
        '/manageUsers': (context) => const ManageUserPage(),
        '/addUser': (context) => AddUser(),
        '/registPayments': (context) => const RegisterPaymentsPage(),
        // rama del cobrador
        '/cobro': (context) => const CobroPage(),
        '/scanQR': (context) => ScanQRPage(cameras: cameras),
        '/payments': (context) => const PaymentsMadePage(),
        // rama del cliente del local
        '/client': (context) => const ClientePage(),
        '/clientInfo': (context) => const ClientInfo(),
        '/clientPayments': (context) => const ClientPaymentsPage(),
      },
    );
  }
}
