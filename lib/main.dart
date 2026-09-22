import 'package:flutter/material.dart';

void main() => runApp(KolneApp());

class KolneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 110, height: 110,
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(child: Text("K", style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.purple))),
          ),
          SizedBox(height: 15),
          Text("KOLNE", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4)),
          SizedBox(height: 30),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextField(decoration: InputDecoration(hintText: "Mobile Number", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))),
          SizedBox(height: 15),
          ElevatedButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (_)=>HomeScreen())); },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD600), minimumSize: Size(250, 50)),
            child: Text("LOGIN / CONTINUE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
        ]),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("KOLNE"), backgroundColor: Colors.black),
      body: Center(child: Text("Video Feed Aayega Yahan\nHome + Tags + + + Chat + You", textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.black, selectedItemColor: Colors.yellow, unselectedItemColor: Colors.white, type: BottomNavigationBarType.fixed,
        items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), BottomNavigationBarItem(icon: Icon(Icons.tag), label: "Tags"), BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40, color: Colors.yellow), label: ""), BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"), BottomNavigationBarItem(icon: Icon(Icons.person), label: "You")]),
    );
  }
}
