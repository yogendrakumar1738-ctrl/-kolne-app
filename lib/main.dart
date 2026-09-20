import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF0A1F16)), home: MainNav(cameras: cameras));
  }
}

class MainNav extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainNav({super.key, required this.cameras});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _index = 0;
  Map<String,bool> following = {};
  List<Map<String,String>> reels = [
    {"user":"natural_lover","title":"Reel 7 - Self+AI 1Min","emoji":"🍃"},
    {"user":"prakriti_boy","title":"Natural 1-Min Valley","emoji":"🌿"},
    {"user":"shayari_king","title":"Shayari One Min","emoji":"🌊"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _index==0?AppBar(
        backgroundColor: Color(0xFF0A1F16),
        title: Text("Kolne 🍃", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.send_rounded, color: Colors.white), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatListPage()))),
          SizedBox(width: 8),
        ],
      ):null,
      body: _index==0?feed() : _index==2?CameraScreen(cameras: widget.cameras) : _index==4?ProfilePage() : Center(child: Text("Coming Soon", style: TextStyle(color: Colors.white))),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0A1F16), selectedItemColor: Colors.greenAccent, unselectedItemColor: Colors.white54,
        currentIndex: _index, onTap: (i)=>setState(()=>_index=i), type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 32, color: Colors.purpleAccent), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Like"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Pro"),
        ],
      ),
    );
  }

  Widget feed(){
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: reels.length,
      itemBuilder: (context,i){
        var r=reels[i]; bool isF=following[r["user"]!]??false;
        return Stack(children: [
          Container(color: Colors.black87, child: Center(child: Text(r["title"]!, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)))),
          Positioned(left: 12, bottom: 20, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(backgroundColor: Colors.green, child: Text(r["emoji"]!)),
              SizedBox(width: 8),
              Text("@${r["user"]}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              GestureDetector(onTap: ()=>setState(()=>following[r["user"]!]=!isF), child: Container(padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4), decoration: BoxDecoration(border: Border.all(color: Colors.greenAccent), borderRadius: BorderRadius.circular(6), color: isF?Colors.greenAccent:Colors.transparent), child: Text(isF?"Following":"Follow", style: TextStyle(color: isF?Colors.black:Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)))),
            ]),
            SizedBox(height: 5),
            Text(r["title"]!, style: TextStyle(color: Colors.white70)),
          ])),
          Positioned(right: 12, bottom: 90, child: Column(children: [
            Icon(Icons.favorite_border, color: Colors.white, size: 30), Text("1.2K", style: TextStyle(color: Colors.white, fontSize: 11)),
            SizedBox(height: 18),
            Icon(Icons.mode_comment_outlined, color: Colors.white, size: 28), Text("89", style: TextStyle(color: Colors.white, fontSize: 11)),
            SizedBox(height: 18),
            Icon(Icons.share, color: Colors.white, size: 26),
          ])),
        ]);
      },
    );
  }
}

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  @override
  void initState(){super.initState(); _controller=CameraController(widget.cameras[0], ResolutionPreset.medium); _controller.initialize().then((_)=>setState((){}));}
  @override
  void dispose(){_controller.dispose(); super.dispose();}
  @override
  Widget build(BuildContext context){return Scaffold(backgroundColor: Colors.black, body: _controller.value.isInitialized?CameraPreview(_controller):Center(child: CircularProgressIndicator()), floatingActionButton: FloatingActionButton(backgroundColor: Colors.greenAccent, onPressed: (){}, child: Icon(Icons.videocam, color: Colors.black)));}
}

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Messages ✈️"), backgroundColor: Color(0xFF0A1F16)), backgroundColor: Color(0xFF0A1F16), body: ListView(children: [
      ListTile(leading: CircleAvatar(child: Text("🍃")), title: Text("natural_lover", style: TextStyle(color: Colors.white)), subtitle: Text("Video mast tha!", style: TextStyle(color: Colors.white54)), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatDetail(user: "natural_lover")))),
      ListTile(leading: CircleAvatar(child: Text("🌿")), title: Text("prakriti_boy", style: TextStyle(color: Colors.white)), subtitle: Text("Follow back kiya", style: TextStyle(color: Colors.white54)), onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatDetail(user: "prakriti_boy")))),
    ]));
  }
}
class ChatDetail extends StatelessWidget {
  final String user; const ChatDetail({super.key, required this.user});
  @override
  Widget build(BuildContext context){return Scaffold(appBar: AppBar(title: Text(user), backgroundColor: Color(0xFF0A1F16)), body: Column(children: [Expanded(child: Center(child: Text("Chat with $user", style: TextStyle(color: Colors.white54)))), Padding(padding: EdgeInsets.all(10), child: TextField(style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Message...", hintStyle: TextStyle(color: Colors.white54), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)))))]));}
}
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.all(16), child: Column(children: [
      Row(children: [
        CircleAvatar(radius: 38, backgroundColor: Colors.greenAccent, child: Text("YK", style: TextStyle(fontSize: 28, color: Colors.black))),
        SizedBox(width: 18),
        Column(children: [Text("12", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text("Posts", style: TextStyle(color: Colors.white54, fontSize: 12))]),
        SizedBox(width: 18),
        Column(children: [Text("1.2K", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text("Followers", style: TextStyle(color: Colors.white54, fontSize: 12))]),
        SizedBox(width: 18),
        Column(children: [Text("180", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text("Following", style: TextStyle(color: Colors.white54, fontSize: 12))]),
      ]),
      SizedBox(height: 14),
      Row(children: [
        Expanded(child: Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(8)), child: Center(child: Text("Follow", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))))),
        SizedBox(width: 8),
        Expanded(child: Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: Colors.white54), borderRadius: BorderRadius.circular(8)), child: Center(child: Text("Message", style: TextStyle(color: Colors.white))))),
      ]),
      SizedBox(height: 14),
      Expanded(child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2), itemCount: 9, itemBuilder: (c,i)=>Container(color: Colors.white12, child: Center(child: Text("Post ${i+1}", style: TextStyle(color: Colors.white38)))))),
    ]));
  }
}
