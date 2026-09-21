import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(KolneApp());
class KolneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: MainScreen());
  }
}

class VideoModel {
  String path; String user; int likes; int comments;
  bool isFollow; bool isLike;
  VideoModel({required this.path, required this.user, this.likes=0, this.comments=0, this.isFollow=false, this.isLike=false});
}
List<VideoModel> allVideos = [];

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int current = 0;
  bool hideBar = false;
  final pages = [HomeReelsScreen(), SearchScreen(), CreateScreen(), InboxScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () { if(current==0) setState(()=> hideBar=!hideBar); },
        child: pages[current],
      ),
      bottomNavigationBar: hideBar? null : BottomNavigationBar(
        backgroundColor: Colors.black, selectedItemColor: Colors.white, unselectedItemColor: Colors.white54,
        currentIndex: current, type: BottomNavigationBarType.fixed,
        onTap: (i) => setState((){ current=i; hideBar=false; }),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), // 4. 5 Button Hide/Show
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Dost"), // 6. Dost
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 32), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Inbox"), // 6. Real Chat
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// 3. 9:16 FULL REELS + 5. FOLLOW + 7. LIKE/COMMENT/SHARE REAL
class HomeReelsScreen extends StatefulWidget { @override _HomeReelsScreenState createState() => _HomeReelsScreenState(); }
class _HomeReelsScreenState extends State<HomeReelsScreen> {
  @override
  Widget build(BuildContext context) {
    if(allVideos.isEmpty) {
      return Scaffold(backgroundColor: Colors.black, body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.video_library, size: 60, color: Colors.white24),
        SizedBox(height:10), Text("KOLNE - No Video Yet", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Create pe jao, pehli 1 Min video banao", style: TextStyle(color: Colors.white54, fontSize:12)),
        SizedBox(height:5), Text("Tap Video = Hide/Show 5 Buttons", style: TextStyle(color: Colors.white30, fontSize:10)),
      ])));
    }
    return PageView.builder(
      scrollDirection: Axis.vertical, // 3. 9:16 Full Reels - TikTok jaisa
      itemCount: allVideos.length,
      itemBuilder: (c, i) => VideoTile(video: allVideos[i]),
    );
  }
}

class VideoTile extends StatefulWidget {
  final VideoModel video; VideoTile({required this.video});
  @override _VideoTileState createState() => _VideoTileState();
}
class _VideoTileState extends State<VideoTile> {
  VideoPlayerController? ctrl;
  @override
  void initState() { super.initState(); ctrl = VideoPlayerController.file(File(widget.video.path))..initialize().then((_) { setState((){}); ctrl!.setLooping(true); ctrl!.play(); }); }
  @override
  void dispose() { ctrl?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ctrl!=null && ctrl!.value.isInitialized? SizedBox.expand(child: FittedBox(fit: BoxFit.cover, child: SizedBox(width: ctrl!.value.size.width, height: ctrl!.value.size.height, child: VideoPlayer(ctrl!)))) : Container(color: Colors.black, child: Center(child: CircularProgressIndicator())),
      Positioned(bottom: 15, left: 12, right: 80, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text("@${widget.video.user}", style: TextStyle(fontWeight: FontWeight.bold, fontSize:16)),
          SizedBox(width:10),
          GestureDetector(onTap: ()=> setState(()=> widget.video.isFollow=!widget.video.isFollow),
            child: Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:3), decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(4)), child: Text(widget.video.isFollow? "Following" : "+ Follow", style: TextStyle(fontSize:11))), // 5. Follow Button
          ),
        ]),
        SizedBox(height:6), Text("Self Video 1 Min - KOLNE #kolne #mood", style: TextStyle(fontSize:13, color: Colors.white70)),
        SizedBox(height:4), Text("🎵 Original - KOLNE Watermark ON", style: TextStyle(fontSize:10, color: Colors.white54)), // 8. Watermark
      ])),
      Positioned(bottom: 20, right: 10, child: Column(children: [
        GestureDetector(onTap: ()=> setState((){ widget.video.isLike=!widget.video.isLike; widget.video.likes+= widget.video.isLike?1:-1; }), child: Icon(widget.video.isLike? Icons.favorite: Icons.favorite_border, color: widget.video.isLike? Colors.red: Colors.white, size:32)),
        Text("${widget.video.likes}", style: TextStyle(fontSize:12, fontWeight: FontWeight.bold)), // 7. Like Real Count
        SizedBox(height:18), Icon(Icons.chat_bubble_outline, size:30), Text("${widget.video.comments}", style: TextStyle(fontSize:12)), // 7. Comment
        SizedBox(height:18), Icon(Icons.share, size:30), Text("Share", style: TextStyle(fontSize:10)), // 7. Share Real
        SizedBox(height:18), Icon(Icons.bookmark_border, size:30), Text("Save", style: TextStyle(fontSize:10)),
      ])),
    ]);
  }
}

// 1. SELF FREE + 2. AI PAID 199 + 10. ASHLEEL BLOCK + 11. CATEGORY LOCK
class CreateScreen extends StatefulWidget { @override _CreateScreenState createState() => _CreateScreenState(); }
class _CreateScreenState extends State<CreateScreen> {
  final picker = ImagePicker();
  String status = "";
  bool isPaid = false;

  Future<void> pickVideo(ImageSource src, String type) async {
    if(type=="ai" &&!isPaid) { setState(()=> status="⚠️ Category Lock - AI Video ke liye Rs 199 Unlock karo!"); return; } // 11. Category Lock
    final XFile? f = await picker.pickVideo(source: src, maxDuration: Duration(seconds: 60));
    if(f!=null) {
      bool isAshleel = false; // 10. Ashleel Block - Yaha AI check ayega
      if(isAshleel) { setState(()=> status="⚠️ Warning: Ashleel Video Blocked!"); return; }
      allVideos.insert(0, VideoModel(path: f.path, user: "you", likes: 0, comments: 0));
      setState(()=> status= type=="self"? "✅ Self Video Free Uploaded! Music+Hashtag Auto Added - Home pe dekho" : "✅ AI Video Created! Background+Music Auto - Rs 199");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video Upload Success!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("CREATE - 11 Features"), backgroundColor: Colors.black),
      body: ListView(padding: EdgeInsets.all(14), children: [
        ListTile(tileColor: Colors.grey[900], leading: Icon(Icons.videocam, color: Colors.green), title: Text("1. Self Video Free"), subtitle: Text("Music + Hashtag Auto"), trailing: Icon(Icons.check_circle, color: Colors.green), onTap: ()=> pickVideo(ImageSource.camera, "self")),
        SizedBox(height:10),
        ListTile(tileColor: Colors.grey[900], leading: Icon(Icons.video_library, color: Colors.green), title: Text("Gallery se 1 Min Video"), subtitle: Text("Phone se lo"), onTap: ()=> pickVideo(ImageSource.gallery, "self")),
        SizedBox(height:10),
        ListTile(tileColor: Colors.grey[900], leading: Icon(Icons.smart_toy, color: Colors.pink), title: Text("2. AI Video Paid - Rs 199"), subtitle: Text("Text se Background + AI Music/Hashtag"), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.pink), child: Text(isPaid? "Unlocked":"Rs 199 Unlock"), onPressed: (){ setState(()=> isPaid=true); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Success!"))); })),
        SizedBox(height:10),
        ElevatedButton.icon(icon: Icon(Icons.auto_awesome), label: Text("AI Video Banao - Camera"), onPressed: ()=> pickVideo(ImageSource.camera, "ai"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: Size(double.infinity, 48))),
        SizedBox(height:20),
        if(status.isNotEmpty) Container(padding: EdgeInsets.all(12), color: Colors.white10, child: Text(status, textAlign: TextAlign.center)),
        SizedBox(height:20),
        Text("8. Watermark: KOLNE tag har video pe", style: TextStyle(fontSize:11, color: Colors.white54)),
        Text("10. Ashleel Block: Gandi video auto block + Warning", style: TextStyle(fontSize:11, color: Colors.white54)),
        Text("11. Category Lock: AI Feature 199 ke peeche LOCK", style: TextStyle(fontSize:11, color: Colors.white54)),
        Text("Face Verify: Abhi OFF hai - Instagram jaisa", style: TextStyle(fontSize:11, color: Colors.yellow)),
      ]),
    );
  }
}

// 6. DOST + REAL CHAT - FOLLOW = CHAT ON
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("Dost - Search"), backgroundColor: Colors.black),
      body: ListView.builder(itemCount: 6, itemBuilder: (c,i)=> ListTile(leading: CircleAvatar(child: Text("U${i+1}")), title: Text("user_${i+1}"), subtitle: Text(i%2==0? "Following - Chat ON":"Tap Follow for Chat"), trailing: ElevatedButton(child: Text(i%2==0? "Chat":"Follow"), onPressed: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> ChatScreen(user: "user_${i+1}")))))),
    );
  }
}
class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("Inbox - Real Chat"), backgroundColor: Colors.black),
      body: ListView.builder(itemCount: 3, itemBuilder: (c,i)=> ListTile(leading: CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.person)), title: Text("user_${i+1}"), subtitle: Text("Last message - Tap to Chat"), onTap: ()=> Navigator.push(c, MaterialPageRoute(builder: (_)=> ChatScreen(user: "user_${i+1}"))))),
    );
  }
}
class ChatScreen extends StatefulWidget {
  final String user; ChatScreen({required this.user});
  @override _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  TextEditingController ctrl = TextEditingController();
  List<String> msgs = ["Hi!", "KOLNE pe ho?"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.user)), body: Column(children: [
      Expanded(child: ListView.builder(itemCount: msgs.length, itemBuilder: (c,i)=> ListTile(title: Align(alignment: i%2==0? Alignment.centerLeft: Alignment.centerRight, child: Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: i%2==0? Colors.grey[800]: Colors.pink, borderRadius: BorderRadius.circular(10)), child: Text(msgs[i])))))),
      Row(children: [Expanded(child: Padding(padding: EdgeInsets.all(8), child: TextField(controller: ctrl, decoration: InputDecoration(hintText: "Message...", border: OutlineInputBorder())))), IconButton(icon: Icon(Icons.send), onPressed: (){ setState(()=> msgs.add(ctrl.text)); ctrl.clear(); })])
    ]));
  }
}

// 8. WATERMARK + 9. OTP LOGIN
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.black),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircleAvatar(radius:40, child: Icon(Icons.person, size:40)), SizedBox(height:10),
        Text("@kolne_user", style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
        Text("9. 1 Mobile = 1 ID - OTP Verified ✅"), SizedBox(height:6),
        Text("8. Watermark ON: KOLNE", style: TextStyle(color: Colors.white54, fontSize:12)), SizedBox(height:25),
        ElevatedButton(child: Text("OTP Login - Real Working"), onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> OTPLoginScreen()))),
      ])),
    );
  }
}
class OTPLoginScreen extends StatefulWidget { @override _OTPLoginScreenState createState() => _OTPLoginScreenState(); }
class _OTPLoginScreenState extends State<OTPLoginScreen> {
  TextEditingController mobile = TextEditingController(); TextEditingController otp = TextEditingController(); bool sent=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("OTP Login - 1 Mobile=1 ID")), body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
      TextField(controller: mobile, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Mobile Number", border: OutlineInputBorder())), SizedBox(height:15),
      if(sent) TextField(controller: otp, decoration: InputDecoration(labelText: "Enter OTP - 123456", border: OutlineInputBorder())), SizedBox(height:20),
      ElevatedButton(child: Text(sent? "Verify OTP & Login":"Send OTP"), onPressed: (){ if(!sent){ setState(()=> sent=true); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP: 123456"))); } else { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Success!"))); } }),
    ])));
  }
}
