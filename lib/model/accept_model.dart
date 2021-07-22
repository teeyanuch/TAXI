import 'dart:convert';

class AcceptModel {
  final String id;
  final String name;
  final String type;
  final String lat;
  final String lng;
  AcceptModel({
    this.id,
    this.name,
    this.type,
    this.lat,
    this.lng,
  });

  AcceptModel copyWith({
    String id,
    String name,
    String type,
    String lat,
    String lng,
  }) {
    return AcceptModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'lat': lat,
      'lng': lng,
    };
  }

  factory AcceptModel.fromMap(Map<String, dynamic> map) {
    return AcceptModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      lat: map['lat'],
      lng: map['lng'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AcceptModel.fromJson(String source) =>
      AcceptModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AcceptModel(id: $id, name: $name, type: $type, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AcceptModel &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        lat.hashCode ^
        lng.hashCode;
  }
}
