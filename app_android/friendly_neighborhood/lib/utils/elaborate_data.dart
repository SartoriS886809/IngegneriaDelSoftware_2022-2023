/*
La funzione calcola l'età in base alla stringa passata per parametro
birthDate deve essere nel formato dd-mm-yyyy
*/
int calculateAge(String birthDate) {
  DateTime currentDate = DateTime.now();
  var inputData = birthDate.split('-');
  int age = currentDate.year - int.parse(inputData[2]);
  int month1 = currentDate.month;
  int month2 = int.parse(inputData[1]);
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = int.parse(inputData[0]);
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

class Pair<E, F> {
  E first;
  F last;
  Pair({required this.first, required this.last});

  @override
  String toString() {
    return "First: $first Last: $last";
  }
}

String convertDateTimeToDate(DateTime d) {
  return '${d.day}/${d.month}/${d.year}';
}

const months = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
String extractDataFromDBString(String s) {
  List<String> ls = s.split(' ');
  return '${ls[1]}-${months.indexOf(ls[2]) + 1}-${ls[3]}';
}
