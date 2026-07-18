import 'register_event.dart';

class RegisterUsernameChanged extends RegisterEvent {
  final String username;

  const RegisterUsernameChanged(this.username);

  @override
  List<Object> get props => [username];
}
