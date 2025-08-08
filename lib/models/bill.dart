class Bill {
  final String id, billNo, customerId;
  final int year, month, seq;
  final double total;
  final List<Map<String,dynamic>> items;
  Bill({required this.id,required this.billNo,required this.customerId,required this.year,required this.month,required this.seq,required this.total,required this.items});
  factory Bill.fromMap(Map m) => Bill(
    id: m['id'] ?? '',
    billNo: m['billNo'] ?? '',
    customerId: m['customerId'] ?? '',
    year: m['year'] ?? 0,
    month: m['month'] ?? 0,
    seq: m['seq'] ?? 0,
    total: (m['total'] ?? 0).toDouble(),
    items: List<Map<String,dynamic>>.from(m['items'] ?? []),
  );
  Map toMap()=>{'id':id,'billNo':billNo,'customerId':customerId,'year':year,'month':month,'seq':seq,'total':total,'items':items};
}
