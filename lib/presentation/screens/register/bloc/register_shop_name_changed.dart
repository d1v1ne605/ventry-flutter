import 'register_event.dart';

class RegisterShopNameChanged extends RegisterEvent {
  final String shopName;

  const RegisterShopNameChanged(this.shopName);

  @override
  List<Object> get props => [shopName];
}
