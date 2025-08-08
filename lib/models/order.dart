class OrderModel {
  final String id, customerId, schedule;
  final int numCans;
  final List<String> days;
  final bool active;
  OrderModel({required this.id, required this.customerId, required this.schedule, required this.numCans, required this.days, required this.active});
  factory OrderModel.fromMap(Map m) => OrderModel(
    id: m['id'] ?? '',
    customerId: m['customerId'] ?? '',
    schedule: m['schedule'] ?? 'daily',
    numCans: (m['numCans'] ?? 0),
    days: List<String>.from(m['days'] ?? []),
    active: m['active'] ?? true,
  );
  Map toMap() => {'id':id,'customerId':customerId,'schedule':schedule,'numCans':numCans,'days':days,'active':active};
}
