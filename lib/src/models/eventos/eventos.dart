import 'dart:convert';

class Eventos {
  String id;
  DateTime assembleiaDataViajante;
  DateTime assembleiaDataRepresentante;
  DateTime congressoData;
  DateTime celebracaoData;
  DateTime visitaData;
  String conventionImage;
  Eventos({
    required this.id,
    required this.assembleiaDataViajante,
    required this.assembleiaDataRepresentante,
    required this.congressoData,
    required this.celebracaoData,
    required this.visitaData,
    required this.conventionImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'assembleiaDataViajante': assembleiaDataViajante.toIso8601String(),
      'assembleiaDataRepresentante':
          assembleiaDataRepresentante.toIso8601String(),
      'congressoData': congressoData.toIso8601String(),
      'celebracaoData': celebracaoData.toIso8601String(),
      'visitaData': visitaData.toIso8601String(),
    };
  }

  factory Eventos.fromMap(Map<String, dynamic> map) {
    return Eventos(
      id: map['id'] as String,
      assembleiaDataViajante: DateTime.parse(map['assembleiaDataViajante']),
      assembleiaDataRepresentante:
          DateTime.parse(map['assembleiaDataRepresentante']),
      congressoData: DateTime.parse(map['congressoData']),
      celebracaoData: DateTime.parse(map['celebracaoData']),
      visitaData: DateTime.parse(map['visitaData']),
      conventionImage: map['conventionImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Eventos.fromJson(String source) =>
      Eventos.fromMap(json.decode(source) as Map<String, dynamic>);

  Eventos copyWith({
    String? id,
    DateTime? assembleiaDataViajante,
    DateTime? assembleiaDataRepresentante,
    DateTime? congressoData,
    DateTime? celebracaoData,
    DateTime? visitaData,
    String? conventionImage,
  }) {
    return Eventos(
      id: id ?? this.id,
      assembleiaDataViajante:
          assembleiaDataViajante ?? this.assembleiaDataViajante,
      assembleiaDataRepresentante:
          assembleiaDataRepresentante ?? this.assembleiaDataRepresentante,
      congressoData: congressoData ?? this.congressoData,
      celebracaoData: celebracaoData ?? this.celebracaoData,
      visitaData: visitaData ?? this.visitaData,
      conventionImage: conventionImage ?? this.conventionImage,
    );
  }
}


// import 'dart:convert';

// class Eventos {
//   String id;
//   DateTime assembleiaDataViajante;
//   DateTime assembleiaDataRepresentante;
//   DateTime congressoData;
//   DateTime celebracaoData;
//   DateTime visitaData;
//   Eventos({
//     required this.id,
//     required this.assembleiaDataViajante,
//     required this.assembleiaDataRepresentante,
//     required this.congressoData,
//     required this.celebracaoData,
//     required this.visitaData,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'assembleiaDataViajante': assembleiaDataViajante.millisecondsSinceEpoch,
//       'assembleiaData_Representante':
//           assembleiaDataRepresentante.millisecondsSinceEpoch,
//       'congressoData': congressoData.millisecondsSinceEpoch,
//       'celebracaoData': celebracaoData.millisecondsSinceEpoch,
//       'visitaData': visitaData.millisecondsSinceEpoch,
//     };
//   }

//   factory Eventos.fromMap(Map<String, dynamic> map) {
//     return Eventos(
//       id: map['id'] as String,
//       assembleiaDataViajante: DateTime.fromMillisecondsSinceEpoch(
//           map['assembleiaDataViajante'] as int),
//       assembleiaDataRepresentante: DateTime.fromMillisecondsSinceEpoch(
//           map['assembleiaData_Representante'] as int),
//       congressoData:
//           DateTime.fromMillisecondsSinceEpoch(map['congressoData'] as int),
//       celebracaoData:
//           DateTime.fromMillisecondsSinceEpoch(map['celebracaoData'] as int),
//       visitaData: DateTime.fromMillisecondsSinceEpoch(map['visitaData'] as int),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Eventos.fromJson(String source) =>
//       Eventos.fromMap(json.decode(source) as Map<String, dynamic>);

//   Eventos copyWith({
//     String? id,
//     DateTime? assembleiaDataViajante,
//     DateTime? assembleiaDataRepresentante,
//     DateTime? congressoData,
//     DateTime? celebracaoData,
//     DateTime? visitaData,
//   }) {
//     return Eventos(
//       id: id ?? this.id,
//       assembleiaDataViajante:
//           assembleiaDataViajante ?? this.assembleiaDataViajante,
//       assembleiaDataRepresentante:
//           assembleiaDataRepresentante ?? this.assembleiaDataRepresentante,
//       congressoData: congressoData ?? this.congressoData,
//       celebracaoData: celebracaoData ?? this.celebracaoData,
//       visitaData: visitaData ?? this.visitaData,
//     );
//   }
// }




