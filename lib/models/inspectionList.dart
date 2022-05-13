class InspectionList {
  final String name;
  final String dateVIR;
  final String location;

  InspectionList(this.name, this.dateVIR, this.location);

  InspectionList.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        dateVIR = json['dateVIR'],
        location = json['location'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'dateVIR': dateVIR, 'location': location};
}
