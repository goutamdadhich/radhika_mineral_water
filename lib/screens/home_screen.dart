import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/customer.dart';
import '../models/order.dart';
import '../models/bill.dart';
import '../widgets/metric_card.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Customer> customers = [];
  List<OrderModel> orders = [];
  List<Bill> bills = [];
  String role = 'unknown';

  @override
  void initState() {
    super.initState();
    _loadMock();
    _loadRole();
  }

  Future<void> _loadMock() async {
    final c = await rootBundle.loadString('assets/mock/customers.json');
    final o = await rootBundle.loadString('assets/mock/orders.json');
    final b = await rootBundle.loadString('assets/mock/bills.json');
    setState(() {
      customers = (jsonDecode(c) as List).map((e) => Customer.fromMap(e)).toList();
      orders = (jsonDecode(o) as List).map((e) => OrderModel.fromMap(e)).toList();
      bills = (jsonDecode(b) as List).map((e) => Bill.fromMap(e)).toList();
    });
  }

  Future<void> _loadRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() { role = 'guest'; });
      return;
    }
    final auth = AuthService();
    final r = await auth.getUserRole(user.uid);
    setState(() { role = r; });
  }

  @override
  Widget build(BuildContext context) {
    final totalCustomers = customers.length;
    final activeOrders = orders.where((o) => o.active).length;
    final revenue = bills.fold(0.0, (p, b) => p + b.total);

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset('assets/logo.png', height:32),
          SizedBox(width:8),
          Text('Radhika Mineral Water')
        ]),
        actions: [
          if (user != null) Padding(
            padding: const EdgeInsets.symmetric(horizontal:8.0),
            child: Center(child: Text('${user.email} (${role.toUpperCase()})', style: TextStyle(fontSize:12))),
          ),
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications)),
          IconButton(onPressed: () async { await AuthService().signOut(); }, icon: Icon(Icons.logout)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(child: MetricCard(title: 'Customers', value: totalCustomers.toString())),
            SizedBox(width:8),
            Expanded(child: MetricCard(title: 'Active Orders', value: activeOrders.toString())),
            SizedBox(width:8),
            Expanded(child: MetricCard(title: 'Revenue', value: '₹${revenue.toStringAsFixed(0)}')),
          ]),
          SizedBox(height:16),
          Row(children: [
            ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.person_add), label: Text('Add Customer')),
            SizedBox(width:8),
            ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.playlist_add_check), label: Text('Create Order')),
            SizedBox(width:8),
            ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.receipt_long), label: Text('Generate Bill')),
          ]),
          SizedBox(height:16),
          Expanded(
            child: GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width>800?4:2,
              crossAxisSpacing:12,
              mainAxisSpacing:12,
              children: [
                _navCard(Icons.people,'Customers'),
                _navCard(Icons.local_shipping,'Deliveries'),
                _navCard(Icons.calendar_today,'Schedules'),
                _navCard(Icons.receipt,'Bills'),
                _navCard(Icons.person,'Profile'),
                _navCard(Icons.settings,'Settings'),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _navCard(IconData icon, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: (){},
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon,size:40),
            SizedBox(height:8),
            Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}
