import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NicController extends GetxController {
  final nicNumber = ''.obs;
  final isOldFormat = true.obs;
  final dateOfBirth = DateTime.now().obs;
  final gender = ''.obs;
  final weekDay = ''.obs;
  final age = 0.obs;

  void decodeNIC(String nic) {
    nicNumber.value = nic;
    isOldFormat.value = nic.length == 10;
    
    int year;
    int dayOfYear;
    
    if (isOldFormat.value) {
      // Old format: 853400937v
      year = int.parse('19${nic.substring(0, 2)}');
      dayOfYear = int.parse(nic.substring(2, 5));
    } else {
      // New format: 198534000937
      year = int.parse(nic.substring(0, 4));
      dayOfYear = int.parse(nic.substring(4, 7));
    }

    // Gender determination
    gender.value = dayOfYear > 500 
        ? 'Female' 
        : 'Male';
    
    // Adjust day number for females
    if (dayOfYear > 500) {
      dayOfYear -= 500;
    }

    // Improved date calculation
    try {
      DateTime date = _calculateDateFromDayOfYear(year, dayOfYear);
      dateOfBirth.value = date;
      weekDay.value = DateFormat('EEEE').format(date);
      _calculateAge(date);
    } catch (e) {
      print('Error calculating date: $e');
      // Handle invalid date
      dateOfBirth.value = DateTime(year);
    }
  }

  DateTime _calculateDateFromDayOfYear(int year, int dayOfYear) {
    // Create a map of cumulative days up to each month
    final List<int> daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    
    // Adjust for leap year
    if (isLeapYear(year)) {
      daysInMonth[1] = 29;
    }

    // Find the correct month and day
    int month = 1;
    int remainingDays = dayOfYear;
    
    for (int i = 0; i < daysInMonth.length; i++) {
      if (remainingDays <= daysInMonth[i]) {
        month = i + 1;
        break;
      }
      remainingDays -= daysInMonth[i];
    }

    return DateTime(year, month, remainingDays);
  }

  bool isLeapYear(int year) {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }

  void _calculateAge(DateTime birthDate) {
    DateTime now = DateTime.now();
    int years = now.year - birthDate.year;
    
    // Adjust age if birthday hasn't occurred this year
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      years--;
    }
    
    age.value = years;
  }

  String formatDate() {
    return DateFormat('yyyy-MM-dd').format(dateOfBirth.value);
  }
}
