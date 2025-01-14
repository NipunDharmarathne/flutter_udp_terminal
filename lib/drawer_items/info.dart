import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'App Overview:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'The UDP Terminal app enables users to send and receive UDP packets over a network. This tool is useful for communication with devices, testing network configurations or debugging networked applications.',
            ),
            SizedBox(height: 16),

            Text(
              'Key Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              '- Send and Receive UDP Packets\n'
              '- Unicast/Broadcast\n'
              '- Port Configuration\n'
              '- UTF8 Encode/Decode\n'
              '- Connection Status',
              
            ),
            SizedBox(height: 16),

            Text(
              'Version Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Current Version: 0.1.0\nRelease Date: January 2025',
            ),
          ],
        ),
      ),
    );
  }
}