import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import 'input_screen.dart';
import 'result_screen.dart';

class HomeScreen extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());

  final List<Widget> pages = [
    InputScreen(),
    ResultScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[navigationController.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade600],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: navigationController.selectedIndex.value,
            onTap: navigationController.changePage,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.input),
                label: 'Input NIC',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics),
                label: 'Results',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
