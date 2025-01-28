import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nic_controller.dart';
import '../controllers/navigation_controller.dart';

class ResultScreen extends StatelessWidget {
  final controller = Get.find<NicController>();

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.blue.shade800),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NIC Details'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade400],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Obx(() => Column(
              children: [
                _buildInfoCard(
                  'NIC Format',
                  controller.isOldFormat.value ? "Old Format" : "New Format",
                  Icons.credit_card,
                ),
                SizedBox(height: 10),
                _buildInfoCard(
                  'Date of Birth',
                  controller.formatDate(),
                  Icons.calendar_today,
                ),
                SizedBox(height: 10),
                _buildInfoCard(
                  'Week Day',
                  controller.weekDay.value,
                  Icons.view_week,
                ),
                SizedBox(height: 10),
                _buildInfoCard(
                  'Age',
                  '${controller.age.value} years',
                  Icons.person_outline,
                ),
                SizedBox(height: 10),
                _buildInfoCard(
                  'Gender',
                  controller.gender.value,
                  Icons.wc,
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                   onPressed: () => Get.find<NavigationController>().changePage(0),
                  icon: Icon(Icons.arrow_back),
                  label: Text('Check Another NIC'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade800,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
