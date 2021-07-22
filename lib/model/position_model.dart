import 'dart:convert';

class PositionModel {
  final String id;
  final String idRecord;
  final String name;
  final String type;
  final String lat;
  final String lng;
  PositionModel({
    this.id,
    this.idRecord,
    this.name,
    this.type,
    this.lat,
    this.lng,
  });

  PositionModel copyWith({
    String id,
    String idRecord,
    String name,
    String type,
    String lat,
    String lng,
  }) {
    return PositionModel(
      id: id ?? this.id,
      idRecord: idRecord ?? this.idRecord,
      name: name ?? this.name,
      type: type ?? this.type,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idRecord': idRecord,
      'name': name,
      'type': type,
      'lat': lat,
      'lng': lng,
    };
  }

  factory PositionModel.fromMap(Map<String, dynamic> map) {
    return PositionModel(
      id: map['id'],
      idRecord: map['idRecord'],
      name: map['name'],
      type: map['type'],
      lat: map['lat'],
      lng: map['lng'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PositionModel.fromJson(String source) => PositionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PositionModel(id: $id, idRecord: $idRecord, name: $name, type: $type, lat: $lat, lng: $lng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PositionModel &&
      other.id == id &&
      other.idRecord == idRecord &&
      other.name == name &&
      other.type == type &&
      other.lat == lat &&
      other.lng == lng;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idRecord.hashCode ^
      name.hashCode ^
      type.hashCode ^
      lat.hashCode ^
      lng.hashCode;
  }
}
