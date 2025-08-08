class Customer {
  final String id, name, address, phone, email;
  final double ratePerCan;
  Customer({required this.id, required this.name, required this.address, required this.phone, required this.email, required this.ratePerCan});
  factory Customer.fromMap(Map m) => Customer(
    id: m['id'] ?? '',
    name: m['name'] ?? '',
    address: m['address'] ?? '',
    phone: m['phone'] ?? '',
    email: m['email'] ?? '',
    ratePerCan: (m['ratePerCan'] ?? 0).toDouble(),
  );
  Map toMap() => {'id':id,'name':name,'address':address,'phone':phone,'email':email,'ratePerCan':ratePerCan};
}
