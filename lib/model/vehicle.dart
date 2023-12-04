import 'dart:convert';

Vehicle technicianFromJson(String str) => Vehicle.fromJson(json.decode(str));

String technicianToJson(Vehicle data) => json.encode(data.toJson());

class Vehicle {
  // int? id;
  late String? id;
  late String brand;
  late String model;
  late String color;
  late String year;
  late String licensePlate;
  late String? photo;
  late String customerId;
  late List<Vehicle> toList = [];

  Vehicle({
    this.id,
    required this.brand,
    required this.model,
    required this.color,
    required this.year,
    required this.licensePlate,
    this.photo,
    required this.customerId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        brand: json["brand"],
        model: json["model"],
        color: json["color"],
        year: json["year"],
        licensePlate: json["license_plate"],
        photo: json["photo"],
        customerId: json["customer_id"] is int ? json["customer_id"].toString() : json["customer_id"],
      );
      
  Vehicle.fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      Vehicle vehicle = Vehicle.fromJson(item);
      toList.add(vehicle);
    }
  }
  
  Map<String, dynamic> toJson() => {
        "id": id,
        "brand": brand,
        "model": model,
        "color": color,
        "year": year,
        "license_plate": licensePlate,
        "photo": photo,
        "customer_id": customerId,
      };
}
