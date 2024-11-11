class RegionModel {
  final int id;
  final String name;
  final String cod;

  RegionModel({
    required this.id,
    required this.name,
    required this.cod,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'],
      name: json['name'],
      cod: json['cod'],
    );
  }
}

class DeliFeeModel {
  final int id;
  final int regionId;
  final String city;
  final String fee;
  final RegionModel region;

  DeliFeeModel({
    required this.id,
    required this.regionId,
    required this.city,
    required this.fee,
    required this.region,
  });

  factory DeliFeeModel.fromJson(Map<String, dynamic> json) {
    return DeliFeeModel(
      id: json['id'],
      regionId: json['region_id'],
      city: json['city'],
      fee: json['fee'],
      region: RegionModel.fromJson(json['region']),
    );
  }
}
