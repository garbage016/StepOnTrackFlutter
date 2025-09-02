abstract class UserState {
  const UserState();
}

class Idle extends UserState {
  const Idle();
}

class Loading extends UserState {
  const Loading();
}

class Authenticated extends UserState {
  const Authenticated();
}

class ErrorState extends UserState {
  final String message;
  const ErrorState(this.message);
}
