import 'package:flutter/foundation.dart';
import '../repository/AuthRepository.dart';
import '../models/UserState.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository repo;

  UserState _userState = const Idle();
  UserState get userState => _userState;

  AuthViewModel({AuthRepository? repository})
      : repo = repository ?? AuthRepository();

  // LOGIN
  Future<void> login(String email, String password) async {
    _userState = const Loading();
    notifyListeners();

    final result = await repo.login(email, password);

    if (result.success) {
      _userState = const Authenticated();
    } else {
      _userState = ErrorState(result.error ?? "Errore login");
    }
    notifyListeners();
  }

  // REGISTRAZIONE
  Future<void> register({
    required String email,
    required String password,
    required String nome,
    required String cognome,
    required String username,
    required String dataNascita,
  }) async {
    _userState = const Loading();
    notifyListeners();

    final result = await repo.register(email, password);

    if (result.success) {
      // Salva dati aggiuntivi dell'utente
      await repo.saveUserData(
        nome: nome,
        cognome: cognome,
        username: username,
        dataNascita: dataNascita,
        email: email,
        password: password,
      );
      _userState = const Authenticated();
    } else {
      _userState = ErrorState(result.error ?? "Errore registrazione");
    }
    notifyListeners();
  }

  // CONTROLLO USERNAME
  Future<bool> checkUsername(String username) async {
    return await repo.controlloUsername(username);
  }

  // LOGOUT
  Future<void> logout() async {
    await repo.logout();
    _userState = const Idle();
    notifyListeners();
  }
}
