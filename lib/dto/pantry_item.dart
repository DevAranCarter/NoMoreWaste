class PantryItem {
  final String id;
  final String name;
  final DateTime expiredate;
  final DateTime addeddate;
  final int quantity;

  const PantryItem({
    required this.id,
    required this.name,
    required this.expiredate,
    required this.addeddate,
    required this.quantity,
  });

  factory PantryItem.fromJson(Map<String, dynamic> json) {
    return PantryItem(
        id: json['id'],
        name: json['name'],
        expiredate: json['expiredate'],
        addeddate: json['addeddate'],
        quantity: json['quantity']
    );
  }
}