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
  final province = ''.obs;

  void decodeNIC(String nic) {
    try {
      nicNumber.value = nic.trim().toUpperCase();
      isOldFormat.value = nic.length == 10;

      int year;
      int dayOfYear;

      if (isOldFormat.value) {
        // Old format (e.g., 911042754V)
        int yearPrefix = int.parse(nic.substring(0, 2));
        year = yearPrefix >= 0 && yearPrefix <= 30 ? 2000 + yearPrefix : 1900 + yearPrefix;
        dayOfYear = int.parse(nic.substring(2, 5));
        
        // Check voting eligibility (last letter)
        String lastLetter = nic[9].toUpperCase();
        canVote.value = lastLetter == 'V' ? 'Can Vote' : 'Cannot Vote';
      } else {
        // New format (e.g., 200668803138)
        year = int.parse(nic.substring(0, 4));
        dayOfYear = int.parse(nic.substring(4, 7));
        canVote.value = 'Information not available';
      }

      // Gender determination
      gender.value = dayOfYear > 500 ? 'Female' : 'Male';

      // Adjust day for females
      if (dayOfYear > 500) {
        dayOfYear -= 500;
      }

      if (!_isValidDayOfYear(year, dayOfYear)) {
        throw Exception('Invalid day of year');
      }

      DateTime birthDate = _calculateDateFromDayOfYear(year, dayOfYear);
      dateOfBirth.value = birthDate;
      weekDay.value = DateFormat('EEEE').format(birthDate);
      _calculateAge(birthDate);

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

  DateTime _calculateDateFromDayOfYear(int year, int dayOfYear) {
    // Handle edge cases
    if (dayOfYear < 1) {
      throw Exception('Day of year cannot be less than 1');
    }

    // Define cumulative days for each month (non-leap year)
    final List<int> monthDays = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];
    
    // Adjust February for leap year
    if (_isLeapYear(year)) {
      for (int i = 2; i < monthDays.length; i++) {
        monthDays[i]++;
      }
    }

    // Find the month
    int month = 1;
    for (int i = 0; i < monthDays.length - 1; i++) {
      if (dayOfYear > monthDays[i] && dayOfYear <= monthDays[i + 1]) {
        month = i + 1;
        break;
      }
    }

    // Calculate the day
    int day = dayOfYear - monthDays[month - 1];

    try {
      DateTime result = DateTime(year, month, day);
      
      // Verify the calculation
      if (_getDayOfYear(result) != dayOfYear) {
        throw Exception('Date calculation error');
      }
      
      return result;
    } catch (e) {
      throw Exception('Invalid date: Year: $year, Month: $month, Day: $day');
    }
  }

  int _getDayOfYear(DateTime date) {
    // Define cumulative days for each month (non-leap year)
    final List<int> monthDays = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    
    int dayOfYear = monthDays[date.month - 1] + date.day;
    
    // Add leap day if it's a leap year and after February
    if (_isLeapYear(date.year) && date.month > 2) {
      dayOfYear++;
    }
    
    return dayOfYear;
  }

  bool _isValidDayOfYear(int year, int dayOfYear) {
    int maxDays = _isLeapYear(year) ? 366 : 365;
    return dayOfYear >= 1 && dayOfYear <= maxDays;
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