import 'package:flutter/material.dart';
import 'drawer.dart';
import 'data_handler.dart';
import 'drawer_items/terminal.dart';
import 'udp_communication.dart';
import 'package:provider/provider.dart';

final UdpCommunication udpCommunication = UdpCommunication(); // Instantiate the listener
const Terminal terminal = Terminal(); // Instantiate the terminal

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataHandler(),
      child: const DrawerApp(),
    ),
  );
}

class DrawerApp extends StatelessWidget {
  const DrawerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF2D2D2D), // Set custom background color
      ),
      home: const DrawerExample(),
    );
  }
}