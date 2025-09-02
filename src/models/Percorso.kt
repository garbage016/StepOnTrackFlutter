package models

import 'package:cloud_firestore/cloud_firestore.dart';

class Percorso {
    final String id;
    final String nome;
    final double recensione;
    final int durataMinuti;
    final String descrizione;
    final int distanzaKm;
    final List<GeoPoint> coordinate;
    final String autore;
    final String abiti;
    final String mezzo;
    final String dataCreazione;
    final String floraFauna;
    final String citta;
    final int dislivello;

    Percorso({
        this.id = '',
        this.nome = '',
        this.recensione = 0.0,
        this.durataMinuti = 0,
        this.descrizione = '',
        this.distanzaKm = 0,
        this.coordinate = const [],
        this.autore = '',
        this.abiti = '',
        this.mezzo = '',
        this.dataCreazione = '',
        this.floraFauna = '',
        this.citta = '',
        this.dislivello = 0,
    });
}
