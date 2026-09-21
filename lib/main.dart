import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  )
);

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A2215),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 80, color: Color(0xFF4ADE80)),
            Text("Kolne 🍃", 
              style: TextStyle(
                color: Color(0xFF4ADE80), 
                fontSize: 40, 
                fontWeight: FontWeight.bold
              )
            ),
            Text("All Country + All Age Welcome",
              style: TextStyle(color: Colors.white70)
            ),
            SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                hintText: "+91 Phone - Any Country",
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4ADE80)
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainScreen())
                  );
                },
                child: Text("Login OTP",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => MainScreen())
                  );
                },
                child: Text("Continue with Google",
                  style: TextStyle(color: Colors.white)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showBottom = true;
  int currentIndex = 0;
  bool isFollowing = false;
  bool isMutual = false;

  void showLockDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text("🔒 LOCKED", style: TextStyle(color: Colors.orange)),
        content: Text(
          "AI Feature Lock Hai\nJaldi Unlock Hoga\n\n₹199 = 30 Video",
          style: TextStyle(color: Colors.white)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(color: Color(0xFF4ADE80)))
          )
        ],
      )
    );
  }

  void showWarnDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text("⚠️ Warning", style: TextStyle(color: Colors.red)),
        content: Text(
          "Ashlil Content Allow Nahi Hai!\nOnly Natural Content 🍃",
          style: TextStyle(color: Colors.white)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Samajh Gaya")
          )
        ],
      )
    );
  }

  void showDownloadDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF0A2215),
        title: Text("Kolne 🍃 Watermark", 
          style: TextStyle(color: Color(0xFF4ADE80))
        ),
        content: Text(
          "Video Download Hoga\nKolne Logo Ke Saath\n@username + Kolne App",
          style: TextStyle(color: Colors.white)
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4ADE80)
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Downloaded with Kolne 🍃 Watermark!"))
              );
            },
            child: Text("Download", style: TextStyle(color: Colors.black)),
          )
        ],
      )
    );
  }

  void showUploadSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF0A2215),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (_) => Container(
        padding: EdgeInsets.all(20),
        height: 260,
        child: Column(
          children: [
            Text("Video Banao",
              style: TextStyle(
                color: Colors.white, 
                fontSize: 20, 
                fontWeight: FontWeight.bold
              )
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.videocam, color: Color(0xFF4ADE80)),
              title: Text("SELF - FREE ✅", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
              subtitle: Text("Gallery se 1 Min Video",
                style: TextStyle(color: Colors.white54)
              ),
              tileColor: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("SELF: Gallery Open - FREE"))
                );
              },
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.lock, color: Colors.orange),
              title: Text("AI TEXT - LOCKED 🔒",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
              subtitle: Text("₹199 = 30 Video - Baad Me Unlock",
                style: TextStyle(color: Colors.white54)
              ),
              tileColor: Colors.white10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              onTap: () {
                Navigator.pop(context);
                showLockDialog();
              },
            ),
          ],
        ),
      )
    );
  }

  Widget buildFeed() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showBottom = !
