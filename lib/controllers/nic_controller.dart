import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NicController extends GetxController {
  final nicNumber = ''.obs;
  final isOldFormat = true.obs;
  final dateOfBirth = DateTime.now().obs;
  final gender = ''.obs;
  final weekDay = ''.obs;
  final age = 0.obs;
  final canVote = ''.obs;
  final serialNumber = ''.obs;

  void decodeNIC(String nic) {
    try {
      nicNumber.value = nic.trim().toUpperCase();
      
      // Validate NIC format
      if (!_isValidNICFormat(nic)) {
        throw Exception('Invalid NIC format');
      }
      
      isOldFormat.value = nic.length == 10;
      _processNIC(nic);
      
    } catch (e) {
      print('Error processing NIC: $e');
      Get.snackbar(
        'Error',
        'Invalid NIC format: Please check the number',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _isValidNICFormat(String nic) {
    if (nic.length == 10) {
      // Old format validation: 9 digits + V/X
      return RegExp(r'^\d{9}[VvXx]$').hasMatch(nic);
    } else if (nic.length == 12) {
      // New format validation: 12 digits
      return RegExp(r'^\d{12}$').hasMatch(nic);
    }
    return false;
  }

  void _processNIC(String nic) {
    int year;
    int dayOfYear;
    
    if (isOldFormat.value) {
      // Process old format (e.g., 853400937V)
      year = 1900 + int.parse(nic.substring(0, 2));
      dayOfYear = int.parse(nic.substring(2, 5));
      serialNumber.value = nic.substring(5, 9);
      canVote.value = nic[9].toUpperCase() == 'V' ? 'Can Vote' : 'Cannot Vote';
    } else {
      // Process new format (e.g., 198534000937)
      year = int.parse(nic.substring(0, 4));
      dayOfYear = int.parse(nic.substring(4, 7));
      serialNumber.value = nic.substring(7, 11);
      canVote.value = 'Not Applicable';
    }

    // Gender determination
    gender.value = dayOfYear > 500 ? 'Female' : 'Male';
    
    // Adjust day for females
    if (dayOfYear > 500) {
      dayOfYear -= 500;
    }

    // Calculate birth date
    DateTime birthDate = _calculateDateFromDayOfYear(year, dayOfYear);
    dateOfBirth.value = birthDate;
    weekDay.value = DateFormat('EEEE').format(birthDate);
    _calculateAge(birthDate);
  }

  DateTime _calculateDateFromDayOfYear(int year, int dayOfYear) {
    if (dayOfYear < 1 || dayOfYear > (_isLeapYear(year) ? 366 : 365)) {
      throw Exception('Invalid day of year');
    }

    DateTime date = DateTime(year, 1, 1);
    return date.add(Duration(days: dayOfYear - 1));
  }

  bool _isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  void _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int calculatedAge = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      calculatedAge--;
    }
    age.value = calculatedAge;
  }

  String formatDate() {
    return DateFormat('yyyy-MM-dd').format(dateOfBirth.value);
  }
}
