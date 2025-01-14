import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'alerts.dart';
import 'data_handler.dart';
import 'drawer_items/info.dart';
import 'drawer_items/terminal.dart';
import 'main.dart';

class DrawerExample extends StatefulWidget {
  const DrawerExample({super.key});

  @override
  State<DrawerExample> createState() => _DrawerExampleState();
}

class _DrawerExampleState extends State<DrawerExample> {
  String selectedPage = 'Terminal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600], // Sets the AppBar color to blue
        title: Text(_getAppBarTitle(selectedPage)), // Set the AppBar title dynamically
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blue[800], // Sets the notch (status bar) color 
          statusBarIconBrightness: Brightness.light, // Adjusts icon brightness for better visibility
        ),

        actions: _getAppBarActions(selectedPage), // Get actions dynamically based on selected page
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the left
                mainAxisAlignment: MainAxisAlignment.start, // Aligns content to the top
                children: [
                  const Text(
                    'UDP Terminal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10), // Adds some spacing between the text and the icon
                  Image.asset(
                    'assets/icons/app_logo.png', // Path to your custom icon
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.terminal),
              title: const Text('Terminal'),
              onTap: () {
                setState(() {
                  selectedPage = 'Terminal';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Info'),
              onTap: () {
                setState(() {
                  selectedPage = 'Info';
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
      body: _getSelectedPage(selectedPage),
    );
  }

  Widget _getSelectedPage(String selectedPage) {
    switch (selectedPage) {
      case 'Terminal':
        return const Terminal();
      case 'Info':
        return const Info();
      default:
        return const Center(child: Text('Unknown page'));
    }
  }

  String _getAppBarTitle(String selectedPage) {
    switch (selectedPage) {
      case 'Terminal':
        return 'Terminal';
      case 'Info':
        return 'Info';
      default:
        return 'Unknown Page';
    }
  }

  // Dynamically return actions based on selected page
  List<Widget> _getAppBarActions(String selectedPage) {
    switch (selectedPage) {
      case 'Terminal':
        return [
          IconButton(
            icon: Icon(
              udpCommunication.isConnected ? Icons.power_off : Icons.power,
            ),
            onPressed: () {
              if (udpCommunication.isConnected) {
                udpCommunication.closeUdpListener(context);
                Provider.of<DataHandler>(context, listen: false).updaterConnectionStatus(false);
              } else {
                udpCommunication.startUdpListener(context, int.parse(controller3.text));
                Provider.of<DataHandler>(context, listen: false).updaterConnectionStatus(true);
              }
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<DataHandler>(context, listen: false).removeAll();
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showInfoDialog(context);
            },
          ),
        ];
      case 'Info':
        return []; // No actions for Info page
      default:
        return []; // Default empty actions
    }
  }
}
