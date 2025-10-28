import 'package:cloud_firestore/cloud_firestore.dart';

class Percorso {
  final String id;
  final int percorsoID;
  final String nome;
  final String descrizione;
  final String abiti;
  final int distanza;
  final int dislivello;
  final String floraFauna;
  final String citta;
  final String mezzo;
  final int? durata; // può essere null
  final String autore;
  final Timestamp? timestampCreazione;
  final List<GeoPoint> coordinate;
  final double recensione;

  Percorso({
    this.id = '',
    this.percorsoID = 0,
    this.nome = '',
    this.descrizione = '',
    this.abiti = '',
    this.distanza = 0,
    this.dislivello = 0,
    this.floraFauna = '',
    this.citta = '',
    this.mezzo = '',
    this.durata,
    this.autore = '',
    this.timestampCreazione,
    List<GeoPoint>? coordinate,
    this.recensione = 0.0,
  }) : coordinate = coordinate ?? [];

  factory Percorso.fromMap(Map<String, dynamic> map) {
    return Percorso(
      percorsoID: map['percorsoID'] ?? 0,
      nome: map['nome'] ?? '',
      descrizione: map['descrizione'] ?? '',
      abiti: map['abiti'] ?? '',
      distanza: map['distanza'] ?? 0,
      dislivello: map['dislivello'] ?? 0,
      floraFauna: map['floraFauna'] ?? '',
      citta: map['citta'] ?? '',
      mezzo: map['mezzo'] ?? '',
      durata: map['durata'],
      autore: map['autore'] ?? '',
      timestampCreazione: map['timestampCreazione'] as Timestamp?,
      coordinate: (map['coordinate'] as List<dynamic>?)
          ?.map((e) => e as GeoPoint)
          .toList() ??
          [],
      recensione: (map['recensione'] ?? 0).toDouble(),
    );
  }

  Percorso copyWith({
    String? id,
    int? percorsoID,
    String? nome,
    String? descrizione,
    String? abiti,
    int? distanza,
    int? dislivello,
    String? floraFauna,
    String? citta,
    String? mezzo,
    int? durata,
    String? autore,
    Timestamp? timestampCreazione,
    List<GeoPoint>? coordinate,
    double? recensione,
  }) {
    return Percorso(
      id: id ?? this.id,
      percorsoID: percorsoID ?? this.percorsoID,
      nome: nome ?? this.nome,
      descrizione: descrizione ?? this.descrizione,
      abiti: abiti ?? this.abiti,
      distanza: distanza ?? this.distanza,
      dislivello: dislivello ?? this.dislivello,
      floraFauna: floraFauna ?? this.floraFauna,
      citta: citta ?? this.citta,
      mezzo: mezzo ?? this.mezzo,
      durata: durata ?? this.durata,
      autore: autore ?? this.autore,
      timestampCreazione: timestampCreazione ?? this.timestampCreazione,
      coordinate: coordinate ?? this.coordinate,
      recensione: recensione ?? this.recensione,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'percorsoID': percorsoID,
      'nome': nome,
      'descrizione': descrizione,
      'abiti': abiti,
      'distanza': distanza,
      'dislivello': dislivello,
      'floraFauna': floraFauna,
      'citta': citta,
      'mezzo': mezzo,
      'durata': durata,
      'autore': autore,
      'timestampCreazione': timestampCreazione,
      'coordinate': coordinate,
      'recensione': recensione,
    };
  }
}
