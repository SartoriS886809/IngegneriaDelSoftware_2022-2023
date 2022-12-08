class Neighborhood {
  late int id;
  late double area;
  late String name;
  Neighborhood({required this.id, required this.area, required this.name});

  Neighborhood.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    area = json["area"];
    name = json["name"];
  }

  @override
  String toString() {
    return '{id:$id,area:$area,name:$name}';
  }
}
