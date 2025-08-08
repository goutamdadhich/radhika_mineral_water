import 'package:flutter/material.dart';
class MetricCard extends StatelessWidget {
  final String title, value;
  const MetricCard({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:2,
      shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(12)),
      child:Padding(
        padding:EdgeInsets.all(12),
        child:Column(mainAxisAlignment:MainAxisAlignment.center, children:[
          Text(title, style: TextStyle(fontSize:14, color:Colors.grey[700])),
          SizedBox(height:8),
          Text(value, style: TextStyle(fontSize:20, fontWeight: FontWeight.bold))
        ]),
      ),
    );
  }
}
