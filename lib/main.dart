import 'package:dstorres_plataforma/pages/home_page.dart';
import 'package:dstorres_plataforma/pages/login_page.dart';
import 'package:dstorres_plataforma/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SocketService _socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSTorres Plataforma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthGate(socketService: _socketService),
    );
  }
}

class AuthGate extends StatelessWidget {
  final SocketService socketService;

  const AuthGate({required this.socketService, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Conectar ao Socket.IO se não estiver conectado
          final user = snapshot.data!;
          firebase_auth.FirebaseAuth.instance.currentUser?.getIdToken().then((token) {
            socketService.connect();
          });
          return HomePage(socketService: socketService); // Passa o SocketService
        } else {
          return const LoginPage();
        }
      },
    );
  }
}