/// Represents a currency option in the Quick Add flow.
class CurrencyOption {
  final String code;
  final String name;
  final String symbol;

  const CurrencyOption({
    required this.code,
    required this.name,
    required this.symbol,
  });

  String get displayName => '$code - $name ($symbol)';

  static const List<CurrencyOption> defaults = [
    CurrencyOption(code: 'VND', name: 'Vietnamese Dong', symbol: '₫'),
    CurrencyOption(code: 'USD', name: 'US Dollar', symbol: '\$'),
    CurrencyOption(code: 'EUR', name: 'Euro', symbol: '€'),
  ];
}
