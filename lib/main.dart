import 'package:flutter/material.dart';

void main() {
  runApp(KolneApp());
}

class KolneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOLNE',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> features = [
    "1. Chat", "2. Post", "3. Story", "4. Video Call",
    "5. Voice Call", "6. Groups", "7. Friends", "8. Notifications",
    "9. Profile", "10. Settings", "11. Search"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KOLNE - 11 Features"), centerTitle: true),
      body: ListView.builder(
        itemCount: features.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text(features[index], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${features[index]} Opening..."))
                );
              },
            ),
          );
        },
      ),
    );
  }
}
