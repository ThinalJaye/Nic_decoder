import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'nic_controller.dart';

class ResultScreen extends StatelessWidget {
  final NicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NIC Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('NIC Type: ${controller.nicType.value}'),
            Text('Birth Date: ${controller.birthDate.value}'),
            Text('Weekday: ${controller.weekday.value}'),
            Text('Age: ${controller.age.value}'),
            Text('Gender: ${controller.gender.value}'),
            if (controller.isOld.value)
              Text('Vote Eligibility: ${controller.voteEligibility.value}'),
          ],
        )),
      ),
    );
  }
}