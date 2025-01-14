import 'package:flutter/material.dart';

class Message {
  final String text;
  final int number;

  Message(this.text, this.number);
}

class DataHandler with ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addMessage(String newMessage, int number) {
    _messages.add(Message(newMessage, number));
    notifyListeners();
  }

  void removeMessage(int index) {
    _messages.removeAt(index);
    notifyListeners();
  }

  void removeAll() {
    _messages.clear();
    notifyListeners();
  }

  //////////////////////////////
  
  bool isConnected = false;
  void updaterConnectionStatus(bool b){
    isConnected = b;
    notifyListeners(); // Notify listeners when data changes
  }

}