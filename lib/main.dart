import 'package:flutter/material.dart';

void main() => runApp(KolneApp());

class KolneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

// 1. LOGIN SCREEN - Clean (No Text)
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 110, height: 110, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.5), blurRadius: 20)]),
            child: Center(child: ShaderMask(shaderCallback: (b) => LinearGradient(colors: [Colors.purple, Colors.green, Colors.yellow]).createShader(b),
              child: Text("K", style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.white))))),
          SizedBox(height: 12), Text("KOLNE", style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 5)),
          SizedBox(height: 40),
          Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: TextField(decoration: InputDecoration(hintText: "Mobile Number", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: Icon(Icons.phone)))),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainNav())),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD600), minimumSize: Size(280, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            child: Text("LOGIN / CONTINUE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)))
        ]),
      ),
    );
  }
}

// MAIN NAVIGATION - 5 Buttons
class MainNav extends StatefulWidget { @override { _MainNavState createState() => _MainNavState(); } }
class _MainNavState extends State<MainNav> {
  int idx = 0;
  final screens = [HomeFeed(), TagsScreen(), CameraScreen(), ChatScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[idx],
      bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i){ if(i==2) Navigator.push(context, MaterialPageRoute(builder: (_)=>CameraScreen())); else setState(()=>idx=i); },
        backgroundColor: Colors.black, selectedItemColor: Color(0xFFFFD600), unselectedItemColor: Colors.white, type: BottomNavigationBarType.fixed,
        items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), BottomNavigationBarItem(icon: Icon(Icons.tag), label: "#Tags"), BottomNavigationBarItem(icon: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.green, Colors.purple, Colors.yellow]), shape: BoxShape.circle), padding: EdgeInsets.all(8), child: Icon(Icons.add, size: 32, color: Colors.white)), label: ""), BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Chat"), BottomNavigationBarItem(icon: Icon(Icons.person), label: "You")]),
    );
  }
}

// 2. HOME FEED - Video Scroll
class HomeFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("KOLNE FEED"), backgroundColor: Colors.black),
      body: PageView.builder(scrollDirection: Axis.vertical, itemCount: 5, itemBuilder: (c,i){
        return Stack(children: [
          Container(color: Colors.grey[900], child: Center(child: Icon(Icons.play_circle_fill, size: 80, color: Colors.white54))),
          Positioned(bottom: 20, left: 15, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("@user${i+1} • #dosti #sayri", style: TextStyle(color: Colors.white)), Text("KOLNE WATERMARK", style: TextStyle(color: Colors.white54, fontSize: 10))
          ])),
          Positioned(right: 10, bottom: 80, child: Column(children: [Icon(Icons.favorite, color: Colors.white, size: 30), SizedBox(height: 15), Icon(Icons.comment, color: Colors.white), SizedBox(height: 15), Icon(Icons.share, color: Colors.white)]))
        ]);
      }));
  }
}

// 3. TAGS SCREEN
class TagsScreen extends StatelessWidget {
  final tags = ["#dosti", "#sayri", "#jaipur", "#love", "#funny", "#bhai"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("#Tags Search"), backgroundColor: Colors.black),
      body: GridView.builder(padding: EdgeInsets.all(15), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: tags.length, itemBuilder: (c,i)=> Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.purple, Colors.green]), borderRadius: BorderRadius.circular(15)), child: Center(child: Text(tags[i], style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))))));
  }
}

// 4. CAMERA SCREEN - 4 TABS (SELF, AI, SAYRI, MUSIC)
class CameraScreen extends StatefulWidget { @override { _CameraScreenState createState() => _CameraScreenState(); } }
class _CameraScreenState extends State<CameraScreen> with SingleTickerProviderStateMixin {
  late TabController tab; int timer = 60; bool isRec = false;
  @override
  void initState(){ super.initState(); tab = TabController(length: 4, vsync: this); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(backgroundColor: Colors.black, title: Text("KOLNE CAMERA"), bottom: TabBar(controller: tab, labelColor: Color(0xFFFFD600), tabs: [Tab(text: "SELF"), Tab(text: "AI VIDEO"), Tab(text: "SAYRI"), Tab(text: "MUSIC")])),
      body: TabBarView(controller: tab, children: [
        // SELF - 60 sec
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("$timer sec", style: TextStyle(color: Colors.white, fontSize: 40)), SizedBox(height: 20),
          GestureDetector(onTap: (){ setState(()=>isRec=!isRec); }, child: Container(width: 80, height: 80, decoration: BoxDecoration(color: isRec?Colors.grey:Colors.red, shape: BoxShape.circle), child: Icon(isRec?Icons.stop:Icons.videocam, color: Colors.white, size: 40))),
          SizedBox(height: 10), Text(isRec?"Recording... Auto Stop 60sec":"Tap to Record", style: TextStyle(color: Colors.white70))
        ])),
        // AI VIDEO
        Padding(padding: EdgeInsets.all(20), child: Column(children: [
          TextField(decoration: InputDecoration(hintText: "AI ke liye likho: Jaipur barish", filled: true, fillColor: Colors.white, border: OutlineInputBorder())), SizedBox(height: 20),
          ElevatedButton(onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("AI Video Ban Raha Hai..."))); }, child: Text("AI VIDEO BANAO"))
        ])),
        // SAYRI
        Padding(padding: EdgeInsets.all(20), child: Column(children: [
          TextField(maxLines: 4, decoration: InputDecoration(hintText: "Sayri likho...", filled: true, fillColor: Colors.white, border: OutlineInputBorder())), SizedBox(height: 20),
          ElevatedButton(onPressed: (){}, child: Text("SAYRI VIDEO BANAO - Lofi Music"))
        ])),
        // MUSIC
        ListView(children: [ListTile(title: Text("Auto Music", style: TextStyle(color: Colors.white)), leading: Icon(Icons.music_note, color: Colors.yellow)), ListTile(title: Text("Phone Se Music", style: TextStyle(color: Colors.white)), leading: Icon(Icons.phone_android, color: Colors.green)), ListTile(title: Text("Trending", style: TextStyle(color: Colors.white)), leading: Icon(Icons.trending_up, color: Colors.purple))])
      ]),
      bottomSheet: Container(color: Colors.black, padding: EdgeInsets.all(15), child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(decoration: InputDecoration(hintText: "Caption + #hashtags likho... asleel warning!", filled: true, fillColor: Colors.white, border: OutlineInputBorder())), SizedBox(height: 10),
        ElevatedButton(onPressed: (){
          // 5. ASLEEL WARNING + 6. WATERMARK + 7. PAYWALL CHECK
          showDialog(context: context, builder: (_)=>AlertDialog(title: Text("KOLNE"), content: Text("Video Post Ho Gaya! KOLNE Watermark ke saath. 2 video free ke baad Rs 199 = 30 Video")), );
        }, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD600), minimumSize: Size(double.infinity, 50)), child: Text("POST KARO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
      ])),
    );
  }
}

// 8. CHAT - Mutual Follow
class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("Chat - Mutual Only"), backgroundColor: Colors.black),
      body: ListView.builder(itemCount: 5, itemBuilder: (c,i){
        bool mutual = i%2==0;
        return ListTile(leading: CircleAvatar(child: Text("U${i+1}")), title: Text("User ${i+1}", style: TextStyle(color: Colors.white)), subtitle: Text(mutual?"Message kar sakte ho":"Follow back karo tab chat khulega", style: TextStyle(color: Colors.white54)), trailing: Icon(mutual?Icons.lock_open:Icons.lock, color: mutual?Colors.green:Colors.red), onTap: (){ if(!mutual) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mutual Follow = Tabhi Message"))); });
      }));
  }
}

// 9. PROFILE + 10. SETTINGS + 11. LOGOUT/DELETE
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("You - Profile"), backgroundColor: Colors.black, actions: [IconButton(icon: Icon(Icons.settings), onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>SettingsScreen())))]),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircleAvatar(radius: 50, backgroundColor: Colors.white, child: Text("K", style: TextStyle(fontSize: 50, color: Colors.purple))), SizedBox(height: 10),
        Text("Yogendra Kumar", style: TextStyle(color: Colors.white, fontSize: 20)), Text("@yk_kolne | 2 Videos | 1 Mobile Active", style: TextStyle(color: Colors.white54)),
        SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.center, children: [ElevatedButton(onPressed: (){}, child: Text("Edit Profile")), SizedBox(width: 10), ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFFD600)), child: Text("Share Profile", style: TextStyle(color: Colors.black)))])
      ])));
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("Settings"), backgroundColor: Colors.black),
      body: ListView(children: [
        ListTile(title: Text("1 Mobile Active - Logout from all", style: TextStyle(color: Colors.white)), leading: Icon(Icons.phone_android, color: Colors.white), onTap: (){}),
        ListTile(title: Text("Delete Account", style: TextStyle(color: Colors.red)), leading: Icon(Icons.delete, color: Colors.red), onTap: (){ showDialog(context: context, builder: (_)=>AlertDialog(title: Text("Delete?"), content: Text("Sab data delete ho jayega")) ); }),
        ListTile(title: Text("Terms & Privacy", style: TextStyle(color: Colors.white)), leading: Icon(Icons.description, color: Colors.white)),
        ListTile(title: Text("Version 1.0.0 - KOLNE", style: TextStyle(color: Colors.white54)), leading: Icon(Icons.info, color: Colors.white54)),
        ListTile(title: Text("Logout", style: TextStyle(color: Colors.yellow)), leading: Icon(Icons.logout, color: Colors.yellow), onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen())))
      ]));
  }
}
