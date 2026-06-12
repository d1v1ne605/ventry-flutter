/// Represents a supplier option in the Quick Add flow.
class SupplierOption {
  final String id;
  final String name;

  const SupplierOption({required this.id, required this.name});

  static const List<SupplierOption> defaults = [
    SupplierOption(id: 'supplier_a', name: 'Supplier A'),
    SupplierOption(id: 'supplier_b', name: 'Supplier B'),
    SupplierOption(id: 'global_logistics', name: 'Global Logistics Ltd.'),
    SupplierOption(id: 'acme_corp', name: 'Acme Corp'),
  ];
}
