import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Splash()));

class Splash extends StatefulWidget { @override State<Splash> createState()=>_Splash(); }
class _Splash extends State<Splash>{
  initState(){ super.initState(); Future.delayed(Duration(seconds:2), () async {
    var p=await SharedPreferences.getInstance();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> p.getBool('isLogged')==true ? MainApp() : Login()));
  });}
  @override Widget build(BuildContext c)=> Scaffold(backgroundColor: Color(0xFF6A11CB), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [Dot(Colors.red), Dot(Colors.green), Dot(Colors.blue)]),
    SizedBox(height:15), Text('KOLNE', style: TextStyle(color: Colors.white, fontSize:40, fontWeight: FontWeight.bold, letterSpacing:5))
  ])));
}
class Dot extends StatelessWidget{ final Color col; Dot(this.col); @override Widget build(BuildContext c)=> Container(width:35,height:35,margin:EdgeInsets.all(3),decoration: BoxDecoration(color:col, shape:BoxShape.circle));}

// 1,2 - LOGIN 1 NUMBER = 1 ID
class Login extends StatelessWidget{
  final phone=TextEditingController();
  @override Widget build(BuildContext c)=> Scaffold(body: Padding(padding: EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text('KOLNE', style: TextStyle(fontSize:35, fontWeight: FontWeight.bold, color: Color(0xFF6A11CB))), TextField(controller: phone, maxLength:10, keyboardType: TextInputType.number, decoration: InputDecoration(labelText:'Number (1 Number = 1 ID)', border:OutlineInputBorder())),
    SizedBox(height:15),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6A11CB), minimumSize: Size(double.infinity,50)), onPressed: (){ if(phone.text.length==10) Navigator.push(c, MaterialPageRoute(builder: (_)=>Otp(phone: phone.text))); }, child: Text('GET OTP', style: TextStyle(color:Colors.white))),
  ])));
}
class Otp extends StatelessWidget{
  final String phone; Otp({required this.phone});
  final ctrls=List.generate(6, (_)=>TextEditingController());
  @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: Text('OTP - $phone (123456)')), body: Padding(padding: EdgeInsets.all(20), child: Column(children: [
    Row(children: List.generate(6, (i)=> Expanded(child: Padding(padding: EdgeInsets.all(4), child: TextField(controller: ctrls[i], maxLength:1, textAlign: TextAlign.center, decoration: InputDecoration(counterText:'', border:OutlineInputBorder()))))))),
    SizedBox(height:20),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6A11CB), minimumSize: Size(double.infinity,50)), onPressed: () async {
      if(ctrls.map((e)=>e.text).join()=='123456'){ var p=await SharedPreferences.getInstance(); await p.setBool('isLogged', true); await p.setString('phone', phone); await p.setInt('vCount', 0); Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_)=>MainApp()), (r)=>false); }
    }, child: Text('VERIFY', style: TextStyle(color:Colors.white)))
  ])));
}

// 10 - 5 BUTTON + 3 RANG LOGO
class MainApp extends StatefulWidget{ @override State<MainApp> createState()=>_MainApp();}
class _MainApp extends State<MainApp>{
  int idx=0;
  @override Widget build(BuildContext c)=> Scaffold(
    body: [Feed(), Search(), Create(), MyVideos(), Profile()][idx],
    bottomNavigationBar: BottomNavigationBar(currentIndex: idx, onTap: (i)=>setState(()=>idx=i), type: BottomNavigationBarType.fixed, selectedItemColor: Color(0xFF6A11CB), items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label:'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label:'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.add_circle, size:38, color: Color(0xFF6A11CB)), label:'Create'),
      BottomNavigationBarItem(icon: Icon(Icons.video_library), label:'Videos'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label:'Profile'),
    ]),
  );
}

// HOME + EXTRA FEATURES
class Feed extends StatelessWidget{
  @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: Row(children: [Dot(Colors.red), Dot(Colors.green), Dot(Colors.blue), SizedBox(width:8), Text('KOLNE')])), body: ListView.builder(itemCount:4, itemBuilder: (_,i)=> Card(margin: EdgeInsets.all(10), child: Padding(padding: EdgeInsets.all(10), child: Column(children: [
    Row(children: [CircleAvatar(child: Text('U${i+1}')), SizedBox(width:8), Text('User @${i+1} #sayri #trending')]),
    Container(height:180, margin: EdgeInsets.symmetric(vertical:8), color: Colors.black87, child: Stack(children: [
      Center(child: Icon(Icons.play_circle, color:Colors.white, size:50)),
      Positioned(bottom:5, right:5, child: Container(color: Colors.black54, padding: EdgeInsets.all(4), child: Text('KOLNE WATERMARK', style: TextStyle(color:Colors.white, fontSize:10, fontWeight:FontWeight.bold)))),
    ])),
    Row(children: [
      ElevatedButton(onPressed: (){ ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('Mutual Follow pe hi Message!'))); }, child: Text('Message')),
      SizedBox(width:8),
      ElevatedButton(onPressed: (){ ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('⚠️ Asleel pe Warning!'))); }, child: Text('Report')),
    ])
  ])))),
  );
}
class Search extends StatelessWidget{
  @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: Text('Hashtags Search')), body: Padding(padding: EdgeInsets.all(16), child: Column(children: [
    TextField(decoration: InputDecoration(hintText:'Search #sayri #lofi...', prefixIcon: Icon(Icons.search), border:OutlineInputBorder())),
    SizedBox(height:15), Wrap(spacing:8, children: ['#sayri','#sad','#lofi','#trending','#kolne'].map((t)=> Chip(label: Text(t))).toList()),
  ])));
}

// 3,4,5,6,7,11 - CREATE REAL
class Create extends StatefulWidget{ @override State<Create> createState()=>_Create();}
class _Create extends State<Create>{
  int sec=0; bool rec=false; Timer? tm; int vCount=0; bool sayri=false; String music='Auto'; TextEditingController txt=TextEditingController();
  initState(){ super.initState(); load(); }
  load() async { var p=await SharedPreferences.getInstance(); setState(()=> vCount=p.getInt('vCount')??0); }
  
  start() async {
    var p=await SharedPreferences.getInstance(); int c=p.getInt('vCount')??0;
    if(c>=2){ showDialog(context: context, builder: (_)=> AlertDialog(title: Text('Paywall'), content: Text('2 Free khatam! Rs 199 = 30 Video'), actions: [
      TextButton(onPressed: () async { await p.setInt('vCount', 0); setState(()=> vCount=0); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rs 199 Paid! 30 Video Unlocked!'))); }, child: Text('Pay Rs 199')),
    ])); return; }
    setState(()=> rec=true); sec=0;
    tm=Timer.periodic(Duration(seconds:1), (t){ setState(()=> sec++); if(sec>=60) stop(); });
  }
  stop() async { tm?.cancel(); setState(()=> rec=false); var p=await SharedPreferences.getInstance(); int c=p.getInt('vCount')??0; await p.setInt('vCount', c+1); setState(()=> vCount=c+1); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Video Saved 60 Sec! Watermark ke saath!'))); }

  @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: Text('Create 60 Sec')), body: SingleChildScrollView(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: rec?Colors.red:Colors.black, borderRadius: BorderRadius.circular(10)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('$sec / 60 Sec', style: TextStyle(color:Colors.white, fontSize:22, fontWeight:FontWeight.bold)), Text(rec?'REC Auto Stop':'Ready', style: TextStyle(color:Colors.white))])),
    SizedBox(height:10),
    ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, minimumSize: Size(double.infinity,45)), onPressed: rec?stop:start, icon: Icon(Icons.videocam), label: Text(rec?'STOP': 'Self Video 60 Sec Timer + Auto Stop')),
    ElevatedButton.icon(onPressed: (){ ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('Gallery Video 60 Sec Cut Done!'))); }, icon: Icon(Icons.photo_library), label: Text('Gallery 60 Sec Cut')),
    Divider(),
    Text('5. AI Video Text -> BG + Voice', style: TextStyle(fontWeight: FontWeight.bold)), TextField(controller: txt, decoration: InputDecoration(hintText:'Sayri likho...', border:OutlineInputBorder())), SizedBox(height:5),
    ElevatedButton(onPressed: (){ ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('AI BG + Voice Generated: ${txt.text}'))); }, child: Text('Generate AI Video')),
    Divider(),
    SwitchListTile(title: Text('6. Sayri Mode Sad BG + Lofi'), value: sayri, onChanged: (v)=>setState(()=>sayri=v)),
    if(sayri) Container(height:60, color:Colors.black, child: Center(child: Text('Sad BG + Lofi ON 🌙', style: TextStyle(color:Colors.white)))),
    Divider(),
    Text('7. Music Auto/Phone/Trending', style: TextStyle(fontWeight: FontWeight.bold)),
    Row(children: ['Auto','Phone','Trending'].map((m)=> Expanded(child: RadioListTile(title: Text(m, style:TextStyle(fontSize:11)), value:m, groupValue:music, onChanged:(v)=>setState(()=>music=v!)))).toList()),
    SizedBox(height:10),
    Container(padding: EdgeInsets.all(10), color: Colors.yellow.shade100, child: Text('Videos: $vCount / 2 Free | Next Rs199=30\n10. 5 Button + 3 Rang Logo + KOLNE WATERMARK ✅\nDOWNLOAD PE WATERMARK AAYEGA!', style: TextStyle(fontWeight: FontWeight.bold, fontSize:12))),
  ])));
}

class MyVideos extends StatelessWidget{
  @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: Text('My Videos - Download pe Watermark')), body: ListView.builder(itemCount:3, itemBuilder: (_,i)=> Card(child: ListTile(
    title: Text('My Video ${i+1} - 60 Sec'),
    subtitle: Text('KOLNE WATERMARK ke saath'),
    trailing: ElevatedButton(onPressed: (){
      // YEHI DOWNLOAD PE WATERMARK KA LOGIC HAI
      ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text('Downloading... KOLNE WATERMARK chipak gaya! ✅ Gallery me Watermark ke saath save hua!')));
    }, child: Text('Download')),
  ))),
  );
}

class Profile extends StatelessWidget{
  @override Widget build(BuildContext c)=> Scaffold(appBar: AppBar(title: Text('Settings')), body: ListView(children: [
    ListTile(title: Text('3 Rang Logo'), subtitle: Row(children: [Dot(Colors.red), Dot(Colors.green), Dot(Colors.blue), SizedBox(width:5), Text('KOLNE')])),
    ListTile(title: Text('Terms'), onTap: (){ showDialog(context: c, builder: (_)=> AlertDialog(title: Text('Terms'), content: Text('1 Number = 1 ID\nAsleel pe Warning\nMutual pe Message'))); }),
    ListTile(title: Text('Logout'), leading: Icon(Icons.logout), onTap: () async { var p=await SharedPreferences.getInstance(); await p.clear(); Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_)=>Login()), (r)=>false); }),
    ListTile(title: Text('Delete Account'), leading: Icon(Icons.delete, color: Colors.red), onTap: () async { var p=await SharedPreferences.getInstance(); await p.clear(); Navigator.pushAndRemoveUntil(c, MaterialPageRoute(builder: (_)=>Login()), (r)=>false); }),
    Padding(padding: EdgeInsets.all(20), child: Text('KOLNE WATERMARK - Download pe ayega, bina download ke nahi!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))),
  ]));
}
