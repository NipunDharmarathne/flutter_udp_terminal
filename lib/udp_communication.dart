import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_handler.dart';

class UdpCommunication {
  bool isConnected = false; // Flag to check if listener is active
  RawDatagramSocket? socket;
  Datagram? d;

  // Start UDP listener
  Future<void> startUdpListener(BuildContext context, int port) async {
    // Create UDP socket and bind to the address and port
    try {
      socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
      print("Socket bound to port $port");
      isConnected = true;
      Provider.of<DataHandler>(context, listen: false).addMessage('Connected', 0);
    } catch (e) {
      print("Failed to bind socket: $e");
      return;
    }
    // Listen to incoming datagrams (UDP packets)
    socket!.listen((RawSocketEvent e) {
      if (e == RawSocketEvent.read) {
        // Receive data
        d = socket!.receive();
        if (d == null) {
          return;
        }
        try {
          String decodedData = utf8.decode(d!.data);
          print('Received data from ${d!.address.address}: $decodedData');
          Provider.of<DataHandler>(context, listen: false).addMessage('R: ${d!.address.address}: $decodedData', 1);
        } catch (e, stackTrace) {
          print('Received data from ${d!.address.address}: $d!.data');
          Provider.of<DataHandler>(context, listen: false).addMessage('R: ${d!.address.address}: $d!.data', 1);
          print('Error decoding data: $e');
          print(stackTrace);
        }
      }
    });
  }

  Future<String?> getIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4) {
          return addr.address; // Return the first IPv4 address found
        }
      }
    }
    return null; // Return null if no IPv4 address is found
  }

  // Function to send a message to a specific address and port
  Future<void> sendMessage(BuildContext context, String message, String targetAddress, int targetPort) async {
    if (socket == null) {
      print("Socket is not initialized. Cannot send message.");
      return;
    }
    try {
      // Encode the message as bytes
      List<int> messageBytes = utf8.encode(message);
      // Send the message to the target address and port
      socket!.send(messageBytes, InternetAddress(targetAddress), targetPort);
      final ipAddress = await getIpAddress();
      Provider.of<DataHandler>(context, listen: false).addMessage('S: $ipAddress: $message', 2);
      print("Message sent to $targetAddress:$targetPort");
    } catch (e) {
      print("Failed to send message: $e");
    }
  }

  // Function to broadcast a message to the network
  Future<void> broadcastMessage(BuildContext context, String message, int targetPort) async {
    if (socket == null) {
      print("Socket is not initialized. Cannot send broadcast message.");
      return;
    }
    try {
      // Ensure the socket supports broadcasting
      socket!.broadcastEnabled = true;
      // Encode the message as bytes
      List<int> messageBytes = utf8.encode(message);
      // Send the message to the broadcast address and target port
      socket!.send(messageBytes, InternetAddress("255.255.255.255"), targetPort);
      // Get the local IP address
      final ipAddress = await getIpAddress();
      // Update the data handler with the sent message
      Provider.of<DataHandler>(context, listen: false).addMessage('S: $ipAddress: $message', 2);
      print("Broadcast message sent to 255.255.255.255:$targetPort");
    } catch (e) {
      print("Failed to send broadcast message: $e");
    }
  }

  // Close UDP listener and socket
  void closeUdpListener(BuildContext context) {
    if (socket != null) {
      socket!.close();
      socket = null;
      print("Socket closed");
    }
    d = null;
    isConnected = false;
    Provider.of<DataHandler>(context, listen: false).addMessage('Disconnected', 0);
  }
}
