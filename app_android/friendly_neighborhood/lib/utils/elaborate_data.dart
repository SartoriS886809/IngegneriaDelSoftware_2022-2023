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
