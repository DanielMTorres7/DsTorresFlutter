import 'package:dstorres_plataforma/pages/services/chats/chat_list_page.dart';
import 'package:dstorres_plataforma/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final SocketService socketService;

  const HomePage({required this.socketService, super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Obtém o usuário atual
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Abre o Drawer
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Abre o endDrawer à direita
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'Guest'),
              accountEmail: Text(user?.email ?? 'No Email'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(user?.photoURL ?? 'https://via.placeholder.com/150'),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await signOut();
                // Navega para a página de login após o logout
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      drawer: const Drawer(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Games'),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            
            ListTile(
              title: const Text('ChatBot'),
              onTap: () {
                // Passa o SocketService para o ChatListPage
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatListPage(socketService: widget.socketService),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Comparar prescrições'),
              onTap: () {
                // Handle navigation to help
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    // Faz o logout do Firebase e do Google
    await firebase_auth.FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}