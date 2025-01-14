import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_handler.dart';
import '../main.dart';

// Declare controllers for each TextField
final TextEditingController controller1 = TextEditingController();
final TextEditingController controller2 = TextEditingController();
final TextEditingController controller3 = TextEditingController();
final TextEditingController controller4 = TextEditingController();

class Terminal extends StatefulWidget {
  const Terminal({super.key});

  @override
  State<Terminal> createState() => _TerminalState();
}

class _TerminalState extends State<Terminal> {
  int selectedValueRadioBtn = 1; // Define selectedValueRadioBtn

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (controller1.text.isEmpty) controller1.text = '192.168.1.1';
    if (controller2.text.isEmpty) controller2.text = '12345';
    if (controller3.text.isEmpty) controller3.text = '12345';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), // Adjust padding as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<DataHandler>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start, // Align items to start
                children: [
                  Expanded(
                    flex: 2, // Adjust the flex as needed for layout proportions
                    child: Row(
                      children: [
                        Text('IP:',
                          style: TextStyle(
                            fontSize: 11,
                            color: !udpCommunication.isConnected
                                ? Colors.white
                                : Colors.white.withOpacity(0.4), // Faded color when not connected
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Radio<int>(
                            value: 1, // Unique value for this radio button
                            groupValue: selectedValueRadioBtn, // The shared value for the group
                            onChanged: !udpCommunication.isConnected
                              ? (value) {
                                  setState(() {
                                    selectedValueRadioBtn = value!;
                                  });
                                }
                              : null, // Disable onChanged when not connected
                          ),
                        ),
                        Text('Uni.',
                          style: TextStyle(
                            fontSize: 10,
                            color: !udpCommunication.isConnected
                                ? Colors.white
                                : Colors.white.withOpacity(0.4), // Faded color when not connected
                          ),
                        ),
                        Theme(
                          data: Theme.of(context).copyWith(
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Radio<int>(
                            value: 2, // Unique value for this radio button
                            groupValue: selectedValueRadioBtn, // The shared value for the group
                            onChanged: !udpCommunication.isConnected
                              ? (value) {
                                  setState(() {
                                    selectedValueRadioBtn = value!;
                                  });
                                }
                              : null, // Disable onChanged when not connected
                          ),
                        ),
                        Text('Broad.',
                          style: TextStyle(
                            fontSize: 10,
                            color: !udpCommunication.isConnected
                                ? Colors.white
                                : Colors.white.withOpacity(0.4), // Faded color when not connected
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Space between the columns
                  Expanded(
                    child: Text('Send Port:',
                      style: TextStyle(
                        fontSize: 11,
                        color: !udpCommunication.isConnected
                            ? Colors.white
                            : Colors.white.withOpacity(0.4), // Faded color when not connected
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Space between the columns
                  Expanded(
                    child: Text('Receive Port:',
                      style: TextStyle(
                        fontSize: 11,
                        color: !udpCommunication.isConnected
                            ? Colors.white
                            : Colors.white.withOpacity(0.4), // Faded color when not connected
                      ),
                    ),
                  )
                ],
              );
            },
          ),

          Consumer<DataHandler>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      enabled: selectedValueRadioBtn != 2 && !udpCommunication.isConnected, // Disable if broadcast or connected
                      controller: controller1,  // Assign controller to first TextField
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12),  // Set the text size here
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      enabled: !udpCommunication.isConnected,  // Disable if connected
                      controller: controller2,  // Assign controller to second TextField
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12),  // Set the text size here
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      enabled: !udpCommunication.isConnected,  // Disable if connected
                      controller: controller3,  // Assign controller to third TextField
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 12),  // Set the text size here
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 15), // Space between TextFields and Button

          Consumer<DataHandler>(
            builder: (context, itemData, child) {
              // Scroll to the bottom when new messages are added
              if (itemData.messages.isNotEmpty) {
                Future.delayed(const Duration(milliseconds: 100), () {
                  _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                });
              }
              return Expanded(
                child: Scrollbar( // Wrap the ListView with Scrollbar
                  child: ListView.builder(
                    controller: _scrollController, // Attach the controller
                    itemCount: itemData.messages.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (itemData.messages[index].number == 0) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(itemData.messages[index].text,
                                  style: const TextStyle(fontSize: 11, color: Colors.red)),
                            ),
                            const Divider(), // Add a divider after the message
                          ] else if (itemData.messages[index].number == 1) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(itemData.messages[index].text,
                                  style: const TextStyle(fontSize: 11, color: Colors.green)),
                            ),
                            const Divider(), // Add a divider after the message
                          ] else if (itemData.messages[index].number == 2) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(itemData.messages[index].text,
                                  style: const TextStyle(fontSize: 11, color: Colors.yellow)),
                            ),
                            const Divider(), // Add a divider after the message
                          ],
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),

          Consumer<DataHandler>(
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      enabled: udpCommunication.isConnected,  // Disable if not connected
                      controller: controller4,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        isDense: true, 
                        labelText: 'Enter message',
                        labelStyle: TextStyle(fontSize: 12),  // Set label text size here
                      ),
                      style: const TextStyle(fontSize: 12),  // Set the text size here
                    ),
                  ),
                  const SizedBox(width: 8), // Space between the TextField and the Button
                  ElevatedButton(
                    onPressed: udpCommunication.isConnected
                      ? () {
                        // Handle the send action
                        if (selectedValueRadioBtn==1) {
                          if (controller4.text.isEmpty) {
                            udpCommunication.sendMessage(context, 'Empty Text', controller1.text, int.parse(controller2.text));
                          } else {
                            udpCommunication.sendMessage(context, controller4.text, controller1.text, int.parse(controller2.text));
                          }
                          controller4.clear();  // Clears the text in the TextEditingController
                          // udpCommunication.sendMessage(context, "hii win 11", "192.168.0.130", 14555);
                        } else if (selectedValueRadioBtn==2) {
                          if (controller4.text.isEmpty) {
                            udpCommunication.broadcastMessage(context, 'Empty Text', int.parse(controller2.text));
                          } else {
                            udpCommunication.broadcastMessage(context, controller4.text, int.parse(controller2.text));
                          }                          
                          controller4.clear();  // Clears the text in the TextEditingController
                          print('broadcast');
                        }
                        print('Send button pressed');
                      } 
                      : null,  // Disable button if not connected
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Green background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // Rounded corners
                        // side: BorderSide(color: Colors.green, width: 2), // Border color and thickness
                      ),
                    ),
                    child: const Icon(Icons.send, color: Colors.white), // Send icon
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }
}