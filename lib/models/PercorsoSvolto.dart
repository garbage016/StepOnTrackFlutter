class PercorsoSvolto {
  final String nomePercorso;
  final String email;
  final int tempoImpiegato;
  final String idPercorso;
  final String dataSvolgimento;

  PercorsoSvolto({
    this.nomePercorso = '',
    this.email = '',
    this.tempoImpiegato = 0,
    this.idPercorso = '',
    this.dataSvolgimento = '',
  });

  factory PercorsoSvolto.fromMap(Map<String, dynamic> map) {
    return PercorsoSvolto(
      nomePercorso: map['nomePercorso'] ?? '',
      email: map['email'] ?? '',
      tempoImpiegato: map['tempoImpiegato'] ?? 0,
      idPercorso: map['idPercorso'] ?? '',
      dataSvolgimento: map['dataSvolgimento'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nomePercorso': nomePercorso,
      'email': email,
      'tempoImpiegato': tempoImpiegato,
      'idPercorso': idPercorso,
      'dataSvolgimento': dataSvolgimento,
    };
  }
}
