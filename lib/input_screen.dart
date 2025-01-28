import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'nic_controller.dart';

class InputScreen extends StatelessWidget {
  final NicController controller = Get.put(NicController());
  final TextEditingController nicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NIC Decoder')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nicController,
              decoration: InputDecoration(
                labelText: 'Enter NIC',
                hintText: 'e.g., 853400937V or 198534000937'
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.parseNic(nicController.text.trim());
                if (controller.isValid.value) {
                  Get.toNamed('/result');
                } else {
                  Get.snackbar('Error', 'Invalid NIC number');
                }
              },
              child: Text('Decode NIC'),
            ),
          ],
        ),
      ),
    );
  }
}