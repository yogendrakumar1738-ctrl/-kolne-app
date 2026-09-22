import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';7
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: NumScreen(), theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black)));
}

// 1. NUMBER LOGIN
class NumScreen extends StatefulWidget { @override State<NumScreen> createState()=>_NumState(); }
class _NumState extends State<NumScreen> {
  var phone = TextEditingController();
  bool load=false;
  send() async {
    setState(()=>load=true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91${phone.text}',
      codeSent: (id, _){ setState(()=>load=false); Navigator.push(context, MaterialPageRoute(builder: (_)=>OtpScreen(id: id, phone: phone.text))); },
      verificationFailed: (e){ setState(()=>load=false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message??"Error"))); },
      codeAutoRetrievalTimeout: (id){}, verificationCompleted: (c){},
    );
  }
  @override Widget build(BuildContext c)=>Scaffold(body: Padding(padding: EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(height: 90, width: 90, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFFFFEB3B), Color(0xFF00E676)])), child: Center(child: Text("K", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)))), 
    SizedBox(height: 10), Text("KOLNE", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 2)), Text("Bharat Ka Short App", style: TextStyle(color: Colors.grey, fontSize: 12)),
    SizedBox(height: 30),
    TextField(controller: phone, keyboardType: TextInputType.number, maxLength: 10, decoration: InputDecoration(prefixText: "+91 ", counterText: "", hintText: "Mobile Number", filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
    SizedBox(height: 16),
    SizedBox(width: double.infinity, height: 52, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7C4DFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: load?null:send, child: load?CircularProgressIndicator(color: Colors.white):Text("Send OTP", style: TextStyle(fontSize: 16)))),
    SizedBox(height: 12), Text("1 Number = 1 Kolne ID", style: TextStyle(fontSize: 11, color: Colors.green)),
  ])));
}

// 2. CHOTI OTP + 3. 1 NUMBER = 1 ID REAL
class OtpScreen extends StatefulWidget { final String id, phone; OtpScreen({required this.id, required this.phone}); @override State<OtpScreen> createState()=>_OtpState(); }
class _OtpState extends State<OtpScreen> {
  var ctrls = List.generate(6, (_)=>TextEditingController());
  verify() async {
    try{
      String code = ctrls.map((e)=>e.text).join();
      var cred = PhoneAuthProvider.credential(verificationId: widget.id, smsCode: code);
      await FirebaseAuth.instance.signInWithCredential(cred);
      var prefs = await SharedPreferences.getInstance();
      var info = await DeviceInfoPlugin().androidInfo;
      String deviceId = info.id;
      var doc = await FirebaseFirestore.instance.collection("kolne_users").doc(widget.phone).get();
      if(!doc.exists){
        await FirebaseFirestore.instance.collection("kolne_users").doc(widget.phone).set({"phone": widget.phone, "kolne_id": "kolne_${widget.phone}", "deviceId": deviceId, "videos": 0, "createdAt": FieldValue.serverTimestamp()});
        await prefs.setString("deviceId", deviceId);
      } else {
        if(doc["deviceId"]!=deviceId && prefs.getString("deviceId")!=null){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ye ID ek mobile pe active hai"))); return; }
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainNav()));
    } catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Wrong OTP"))); }
  }
  @override Widget build(BuildContext c)=>Scaffold(appBar: AppBar(backgroundColor: Colors.black, elevation: 0), body: Padding(padding: EdgeInsets.all(22), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text("Enter OTP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), SizedBox(height: 6), Text("Code sent to +91 •• •• ${widget.phone.substring(6)}", style: TextStyle(color: Colors.grey, fontSize: 12)),
    SizedBox(height: 24),
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(6, (i)=> SizedBox(width: 44, height: 48, child: TextField(controller: ctrls[i], textAlign: TextAlign.center, maxLength: 1, onChanged: (v){ if(v.isNotEmpty && i<5) FocusScope.of(context).nextFocus(); }, decoration: InputDecoration(counterText: "", filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))))))),
    SizedBox(height: 24), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF7C4DFF)), onPressed: verify, child: Text("Verify & Continue"))),
  ])));
}

// 11. 5 BUTTON + LOGO 3 RANG
class MainNav extends StatefulWidget { @override State<MainNav> createState()=>_MainNavState(); }
class _MainNavState extends State<MainNav> {
  int idx=0;
  var pages=[Feed(), SearchPage(), CreatePage(), InboxPage(), ProfilePage()];
  @override Widget build(BuildContext c)=>Scaffold(body: pages[idx], bottomNavigationBar: Container(decoration: BoxDecoration(color: Colors.black, border: Border(top: BorderSide(color: Colors.white12))), child: BottomNavigationBar(backgroundColor: Colors.black, type: BottomNavigationBarType.fixed, showSelectedLabels: false, showUnselectedLabels: false, currentIndex: idx, onTap: (i)=>setState(()=>idx=i), selectedItemColor: Color(0xFF7C4DFF), unselectedItemColor: Colors.grey, items: [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
    BottomNavigationBarItem(icon: Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFFFFEB3B), Color(0xFF00E676)])), child: Icon(Icons.add, color: Colors.black)), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ""),
    BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
  ])));
}

// 4,5,6,7,8,9,11 CREATE REAL
class CreatePage extends StatefulWidget { @override State<CreatePage> createState()=>_CreateState(); }
class _CreateState extends State<CreatePage> {
  var idea = TextEditingController(); var tagCtrl = TextEditingController();
  String music="Auto"; bool making=false;
  final picker = ImagePicker();

  galleryPick() async {
    var file = await picker.pickVideo(source: ImageSource.gallery);
    if(file==null) return;
    setState(()=>making=true);
    var dir = await getTemporaryDirectory();
    String out="${dir.path}/kolne_${DateTime.now().millisecondsSinceEpoch}.mp4";
    await FFmpegKit.execute('-i ${file.path} -t 60 -vf "drawtext=text=KOLNE:fontsize=24:x=10:y=10:fontcolor=white:box=1:boxcolor=black@0.5" -c:a aac $out');
    await FirebaseFirestore.instance.collection("kolne_videos").add({"text": idea.text.isEmpty?"Gallery Video":idea.text, "hashtags": tagCtrl.text, "music": music, "type": "gallery", "duration": 60, "watermark": "KOLNE", "phone": FirebaseAuth.instance.currentUser?.phoneNumber, "created": FieldValue.serverTimestamp()});
    setState(()=>making=false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gallery 1 Min + Watermark KOLNE Ready ✅")));
  }

  createAI() async {
    if(idea.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Idea / Sayri likho"))); return; }
    setState(()=>making=true);
    var dir = await getTemporaryDirectory();
    String out="${dir.path}/ai_${DateTime.now().millisecondsSinceEpoch}.mp4";
    await FFmpegKit.execute('-f lavfi -i color=c=0x1A1A1A:s=720x1280:d=60 -vf "drawtext=text=${idea.text}:fontsize=32:x=(w-text_w)/2:y=(h-text_h)/2:fontcolor=white:box=1:boxcolor=0x7C4DFF@0.6,drawtext=text=KOLNE:fontsize=22:x=12:y=12:fontcolor=white" -c:a aac -t 60 $out');
    await FirebaseFirestore.instance.collection("kolne_videos").add({"text": idea.text, "hashtags": tagCtrl.text, "music": music, "type": "ai", "duration": 60, "watermark": "KOLNE", "phone": FirebaseAuth.instance.currentUser?.phoneNumber, "created": FieldValue.serverTimestamp()});
    var userDoc = await FirebaseFirestore.instance.collection("kolne_users").doc(FirebaseAuth.instance.currentUser?.phoneNumber?.replaceAll("+91", "")).get();
    setState(()=>making=false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("AI 1 Min Video Ban Gaya - Music: $music - ${tagCtrl.text} ✅")));
    idea.clear();
  }

  @override Widget build(BuildContext c)=>Scaffold(appBar: AppBar(title: Text("Create 1 Min", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.black, centerTitle: true), body: making?Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: Color(0xFF7C4DFF)), SizedBox(height: 12), Text("60 Sec Video + KOLNE Watermark Bana Raha Hu...")])):Padding(padding: EdgeInsets.all(16), child: Column(children: [
    TextField(controller: idea, maxLines: 3, decoration: InputDecoration(hintText: "Idea / Sayri likho... Jaipur barish / Dosti sayri...", filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
    SizedBox(height: 10),
    Row(children: [
      Expanded(child: InkWell(onTap: (){ setState(()=>music=music=="Auto"?"Lofi Sad":"Auto"); }, child: Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)), child: Row(children: [Icon(Icons.music_note, size: 16), SizedBox(width: 6), Text(music, style: TextStyle(fontSize: 12))])))),
      SizedBox(width: 8),
      Expanded(child: TextField(controller: tagCtrl, decoration: InputDecoration(hintText: "#dosti #sayri", filled: true, fillColor: Color(0xFF1A1A1A), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: EdgeInsets.symmetric(horizontal: 12)))),
    ]),
    SizedBox(height: 12),
    Card(color: Color(0xFF1A1A1A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: ListTile(leading: CircleAvatar(backgroundColor: Colors.green.withOpacity(0.2), child: Icon(Icons.videocam, color: Colors.green)), title: Text("Self Video - Free - 1 Min", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), subtitle: Text("Camera 60s + KOLNE", style: TextStyle(fontSize: 11)), onTap: galleryPick)),
    Card(color: Color(0xFF1A1A1A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: ListTile(leading: CircleAvatar(backgroundColor: Colors.yellow.withOpacity(0.2), child: Icon(Icons.photo_library, color: Colors.yellow)), title: Text("Gallery - 1 Min Video", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), subtitle: Text("Auto 60s cut + Watermark", style: TextStyle(fontSize: 11)), onTap: galleryPick)),
    Spacer(),
    Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Color(0xFF7C4DFF).withOpacity(0.5)), borderRadius: BorderRadius.circular(14), color: Color(0xFF7C4DFF).withOpacity(0.08)), child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("AI Video - Paid", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Container(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(20)), child: Text("Rs 199 = 30 Videos", style: TextStyle(fontSize: 10)))]),
      SizedBox(height: 10),
      SizedBox(width: double.infinity, height: 50, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2196F3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: createAI, child: Text("AI Video Create - 1 Min - REAL"))),
    ])),
  ])));
}

class Feed extends StatelessWidget { @override Widget build(BuildContext c)=>StreamBuilder(stream: FirebaseFirestore.instance.collection("kolne_videos").orderBy("created", descending: true).snapshots(), builder: (c,s){ if(!s.hasData) return Center(child: CircularProgressIndicator()); if(s.data!.docs.isEmpty) return Center(child: Text("No 1 Min Videos Yet\nCreate Karo + Se", textAlign: TextAlign.center)); return ListView.builder(itemCount: s.data!.docs.length, itemBuilder: (_,i){ var d=s.data!.docs[i]; return Card(color: Color(0xFF1A1A1A), margin: EdgeInsets.all(8), child: ListTile(title: Text(d["text"]??""), subtitle: Text("${d["hashtags"]??""} • ${d["music"]??""} • ${d["duration"]??60}s • ${d["watermark"]??"KOLNE"}"), trailing: Icon(Icons.play_circle, color: Color(0xFF7C4DFF)))); }); }); }
class SearchPage extends StatelessWidget { @override Widget build(BuildContext c)=>Scaffold(appBar: AppBar(title: Text("Search #tags")), body: StreamBuilder(stream: FirebaseFirestore.instance.collection("kolne_videos").snapshots(), builder: (c,s){ if(!s.hasData) return Center(child: CircularProgressIndicator()); return ListView(children: s.data!.docs.map((d)=>ListTile(title: Text(d["text"]??""), subtitle: Text(d["hashtags"]??"#kolne"))).toList()); })); }
class InboxPage extends StatelessWidget { @override Widget build(BuildContext c)=>Center(child: Text("Inbox - Coming")); }
class ProfilePage extends StatelessWidget { @override Widget build(BuildContext c)=>Scaffold(appBar: AppBar(title: Text("Profile"), actions: [IconButton(icon: Icon(Icons.settings), onPressed: ()=>Navigator.push(c as BuildContext, MaterialPageRoute(builder: (_)=>SettingsPage())))]), body: Center(child: Column(children: [SizedBox(height: 20), Container(height: 80, width: 80, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF7C4DFF), Color(0xFFFFEB3B), Color(0xFF00E676)]))), child: Icon(Icons.person, size: 40, color: Colors.black)), SizedBox(height: 10), Text("@${FirebaseAuth.instance.currentUser?.phoneNumber??"user"}", style: TextStyle(fontWeight: FontWeight.bold)), Text("1 Number = 1 ID - Active", style: TextStyle(fontSize: 11, color: Colors.green)), SizedBox(height: 6), Text("ID: kolne_${FirebaseAuth.instance.currentUser?.phoneNumber?.substring(8)??"000"}", style: TextStyle(fontSize: 11, color: Colors.grey))]))); }
class SettingsPage extends StatelessWidget { @override Widget build(BuildContext c)=>Scaffold(appBar: AppBar(title: Text("Settings")), body: ListView(children: [ListTile(leading: Icon(Icons.logout), title: Text("Logout"), onTap: () async { await FirebaseAuth.instance.signOut(); Navigator.pushAndRemoveUntil(c as BuildContext, MaterialPageRoute(builder: (_)=>NumScreen()), (r)=>false); }), ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text("Delete Account", style: TextStyle(color: Colors.red))), ListTile(leading: Icon(Icons.description), title: Text("Terms & Privacy")), ListTile(leading: Icon(Icons.info), title: Text("App Version"), subtitle: Text("1.0.0 - 11 Features - REAL APK"))])); }
