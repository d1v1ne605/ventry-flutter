/// Represents a unit of measure for stock items.
class StorageUnit {
  final String id;
  final String name;

  const StorageUnit({required this.id, required this.name});

  static const List<StorageUnit> defaults = [
    StorageUnit(id: 'pcs', name: 'Piece (pcs)'),
    StorageUnit(id: 'kg', name: 'Kilogram (kg)'),
    StorageUnit(id: 'box', name: 'Box (box)'),
    StorageUnit(id: 'pack', name: 'Pack (pack)'),
    StorageUnit(id: 'l', name: 'Liter (l)'),
    StorageUnit(id: 'm', name: 'Meter (m)'),
  ];
}
