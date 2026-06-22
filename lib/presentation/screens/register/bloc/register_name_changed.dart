import 'register_event.dart';

class RegisterNameChanged extends RegisterEvent {
  final String name;

  const RegisterNameChanged(this.name);

  @override
  List<Object> get props => [name];
}
