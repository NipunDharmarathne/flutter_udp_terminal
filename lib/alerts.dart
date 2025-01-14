import 'package:flutter/material.dart';

void showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[800], // Set background color to grey
        title: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue), // Info icon
            SizedBox(width: 10), // Space between icon and text
            Text('Info'),
          ],
        ),
        content: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Enter Destination IP & Send Port to Send UDP Datagram:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '• Unicast (Uni): Enter the destination IP (e.g., 192.168.1.1) and send port (e.g., 12345) to send data to a specific device.\n',
              ),
              TextSpan(
                text: '• Broadcast (Broad): Use destination IP 255.255.255.255 and a send port (e.g., 12345) to broadcast data to all devices on the network.\n\n',
              ),

              TextSpan(
                text: 'Enter Receive Port to Listen for Incoming UDP Datagrams:\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '• Specify the receive port (e.g., 12345) to receive incoming UDP datagrams.\n\n',
              ),
              
              TextSpan(
                text: 'Enter your current IP address and the same port number for both send and receive to set up a UDP echo server.\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
