import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NicController extends GetxController {
  // Observable variables
  var nicType = ''.obs;
  var birthDate = ''.obs;
  var weekday = ''.obs;
  var age = 0.obs;
  var gender = ''.obs;
  var voteEligibility = ''.obs;
  var isValid = false.obs;
  var isOld = false.obs;

  void parseNic(String nic) {
    resetState();
    nic = nic.trim();

    if (nic.length == 10) {
      _processOldNic(nic);
    } else if (nic.length == 12 && isNumeric(nic)) {
      _processNewNic(nic);
    } else {
      isValid.value = false;
    }
  }

  void _processOldNic(String nic) {
    String numericPart = nic.substring(0, 9);
    String letter = nic[9].toUpperCase();

    if (isNumeric(numericPart) && (letter == 'V' || letter == 'X')) {
      int year = 1900 + int.parse(nic.substring(0, 2));
      int dayOfYear = int.parse(nic.substring(2, 5));
      _processCommon(year, dayOfYear);
      voteEligibility.value = letter == 'V' ? 'Can Vote' : 'Cannot Vote';
      isOld.value = true;
      nicType.value = 'Old NIC';
      isValid.value = true;
    }
  }

  void _processNewNic(String nic) {
    int year = int.parse(nic.substring(0, 4));
    int dayOfYear = int.parse(nic.substring(4, 7));
    _processCommon(year, dayOfYear);
    nicType.value = 'New NIC';
    isValid.value = true;
  }

  void _processCommon(int year, int dayOfYear) {
    gender.value = dayOfYear > 500 ? 'Female' : 'Male';

    // Adjust dayOfYear for females
    if (dayOfYear > 500) {
      dayOfYear -= 500;
    }

    DateTime? date = _calculateBirthDate(year, dayOfYear);
    if (date != null) {
      birthDate.value = DateFormat('yyyy-MM-dd').format(date);
      weekday.value = DateFormat('EEEE').format(date);
      age.value = _calculateAge(date);
    } else {
      isValid.value = false;
    }
  }

  DateTime? _calculateBirthDate(int year, int dayOfYear) {
    try {
      // Adjust to prevent off-by-one errors
      final date = DateTime(year, 1, 1).add(Duration(days: dayOfYear - 1));
      return date.year == year ? date : null;
    } catch (e) {
      return null;
    }
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  bool isNumeric(String s) {
    return s.isNotEmpty && int.tryParse(s) != null;
  }

  void resetState() {
    nicType.value = '';
    birthDate.value = '';
    weekday.value = '';
    age.value = 0;
    gender.value = '';
    voteEligibility.value = '';
    isValid.value = false;
    isOld.value = false;
  }
}
