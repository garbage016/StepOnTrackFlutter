import 'package:cloud_firestore/cloud_firestore.dart';

class Utente {
  final String username;
  final String email;
  final String nome;
  final String cognome;
  final String dataNascita;
  final Timestamp dataCreazione;
  final String? avatarUrl;

  Utente({
    this.username = '',
    this.email = '',
    this.nome = '',
    this.cognome = '',
    this.dataNascita = '',
    Timestamp? dataCreazione,
    this.avatarUrl,
  }) : dataCreazione = dataCreazione ?? Timestamp.now();

  factory Utente.fromMap(Map<String, dynamic> map) {
    return Utente(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      nome: map['nome'] ?? '',
      cognome: map['cognome'] ?? '',
      dataNascita: map['dataNascita'] ?? '',
      dataCreazione: map['dataCreazione'] ?? Timestamp.now(),
      avatarUrl: map['avatarUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'nome': nome,
      'cognome': cognome,
      'dataNascita': dataNascita,
      'dataCreazione': dataCreazione,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }
}
