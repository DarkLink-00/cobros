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
//import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        '/scanQR': (context) => const ScanQRPage(),
        '/payments': (context) => const PaymentsMadePage(),
        // rama del cliente del local
        '/client': (context) => const ClientePage(),
        '/clientInfo': (context) => const ClientInfo(),
        '/clientPayments': (context) => const ClientPaymentsPage(),
      },
    );
    //MultiProvider(providers: [ChangeNotifierProvider(create: (_)=> AuthService())],);
  }
}
