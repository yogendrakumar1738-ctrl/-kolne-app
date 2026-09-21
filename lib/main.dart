import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(KolneApp());
}

class KolneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOLNE',
      theme: ThemeData.dark(),
      home: OTPLoginScreen(),
    );
  }
}

// 9. OTP LOGIN - 1 Mobile = 1 ID
class OTPLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("KOLNE", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF00FF88)),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen())),
            child: Text("OTP se Login Karo - 1 Mobile = 1 ID"),
          )
        ]),
      ),
    );
  }
}

// 4. 5 BUTTON WALA MAIN SCREEN - Hide/Show Logic
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _showBottomBar = true;

  final screens = [
    HomeReelsScreen(), // 3. 9:16 Reels
    SearchScreen(), // 5. Follow
    CreateScreen(), // 1 & 2 Self+AI + 10 Ashleel Block + 11 Lock
    InboxScreen(), // 6 Real Chat
    ProfileScreen(), // 8 Watermark
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showBottomBar =!_showBottomBar),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: _showBottomBar? BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF00FF88),
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 35), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ) : null,
    );
  }
}

// 3. HOME - 9:16 FULL REELS - Video pe Hide, Tap pe Show
class HomeReelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (ctx, i) {
        return Stack(children: [
          Container(color: Colors.grey[900], child: Center(child: Text("Real Video ${i+1} - 9:16"))),
          Positioned(right: 10, bottom: 100, child: Column(children: [
            Icon(Icons.favorite, size: 35), Text("12.4K"), // 7. REAL LIKE
            SizedBox(height: 20),
            Icon(Icons.comment, size: 35), Text("842"), // REAL COMMENT
            SizedBox(height: 20),
            Icon(Icons.share, size: 35), Text("Share"), // REAL SHARE
            SizedBox(height: 20),
            ElevatedButton(onPressed: (){}, child: Text("+Follow")), // 5. FOLLOW
          ])),
        ]);
      },
    );
  }
}

// 1 & 2. CREATE SCREEN - SELF FREE + AI PAID 199
class CreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("Create Video")),
      body: Column(children: [
        ListTile(
          title: Text("SELF VIDEO - FREE FOREVER"),
          subtitle: Text("1-Min Natural + Music + Hashtags Khud"),
          trailing: Icon(Icons.videocam, color: Colors.green),
          onTap: () {
            // 10. ASHLEEL CHECK
            bool isAshleel = false; // yaha AI check lagega
            if(isAshleel) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ Ashleel Content Allow Nahi Hai")));
            }
          },
        ),
        Divider(),
        ListTile(
          title: Text("AI VIDEO - PAID"),
          subtitle: Text("Text se Background Change + Music+Hashtag AI Auto\n30 Video = Rs 199 Unlock"),
          trailing: ElevatedButton(onPressed: (){
            // Razorpay 199 Logic
          }, child: Text("Rs 199 Me Unlock")),
        ),
        SizedBox(height: 20),
        Text("11. Sari AI Categories 199 ke peeche Lock hai", style: TextStyle(color: Colors.orange)),
      ]),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("Search + Follow Button = Dost = Inbox Chat ON"));
}
class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("Real Chat - Follow ke baad ON"));
}
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(child: Text("Profile - Download pe KOLNE Watermark jalega"));
}
