
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(KolneApp(cameras: cameras));
}

class KolneApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const KolneApp({super.key, required this.cameras});
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
  int idx = 0;
  bool showBar = true;
  bool daily = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!daily) {
        daily = true;
        showDialog(context: context, builder: (_) => AlertDialog(
          backgroundColor: Color(0xFF1B4D3E),
          title: Text("🌿 Roj Welcome YK"),
          content: Text("+10 Coins | Self + AI One Min Video", style: TextStyle(color: Colors.white70)),
          actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("OK", style: TextStyle(color: Colors.white)))],
        ));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (n){
          if(n is ScrollStartNotification && showBar) setState(()=>showBar=false);
          if(n is ScrollEndNotification) Future.delayed(Duration(seconds: 2), ()=> setState(()=>showBar=true));
          return false;
        },
        child: idx==0? FeedPage(cameras: widget.cameras) : idx==4? ProfilePage() : Center(child: Text("Coming Soon", style: TextStyle(color: Colors.white))),
      ),
      bottomNavigationBar: AnimatedContainer(duration: Duration(milliseconds: 300), height: showBar?70:0, child: showBar? BottomNavigationBar(
        backgroundColor: Color(0xFF0A1F16), type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white, unselectedItemColor: Colors.white54, currentIndex: idx,
        onTap: (i){ if(i==2){ showModalBottomSheet(context: context, backgroundColor: Color(0xFF1B4D3E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (_)=> SheetPage(cameras: widget.cameras)); } else setState(()=>idx=i); },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1B4D3E), Color(0xFF6A1B9A)]), shape: BoxShape.circle), child: Icon(Icons.add, color: Colors.white)), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Color(0xFF6A1B9A)), label: "Like"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ): SizedBox()),
    );
  }
}

class FeedPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const FeedPage({super.key, required this.cameras});
  @override
  State<FeedPage> createState()=> _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<bool> liked = List.generate(20, (_)=>false);
  @override
  Widget build(BuildContext context){
    return PageView.builder(scrollDirection: Axis.vertical, itemCount: 20, itemBuilder: (c,i){
      return Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1F16), Color(0xFF2D1B4E)])), child: Stack(children: [
        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.play_circle, size: 70, color: Colors.white24), Text("Natural Reel ${i+1}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), Text("Self + AI One Min - Dark Green Purple White", style: TextStyle(color: Colors.white54, fontSize: 12))])),
        Positioned(right: 10, bottom: 30, child: Column(children: [
          InkWell(onTap:(){setState(()=>liked[i]=!liked[i]);}, child: Column(children: [Icon(liked[i]?Icons.favorite:Icons.favorite_border, color: liked[i]?Colors.red:Colors.white, size: 34), Text("Like", style: TextStyle(fontSize: 10, color: Colors.white))])),
          SizedBox(height: 18),
          InkWell(onTap:()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Comment - Gaali *** Hide"))), child: Column(children: [Icon(Icons.comment, color: Colors.white, size: 34), Text("Hide", style: TextStyle(fontSize: 10, color: Colors.white))])),
          SizedBox(height: 18),
          InkWell(onTap:()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Share"))), child: Column(children: [Icon(Icons.share, color: Colors.white, size: 34), Text("Share", style: TextStyle(fontSize: 10, color: Colors.white))])),
          SizedBox(height: 18),
          InkWell(onTap:()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Music Add"))), child: Column(children: [Icon(Icons.music_note, color: Color(0xFF00FF9D), size: 34), Text("Music", style: TextStyle(fontSize: 10, color: Colors.white))])),
          SizedBox(height: 18),
          InkWell(onTap:()=>ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Chat - Mutual"))), child: Column(children: [Icon(Icons.message, color: Colors.white, size: 34), Text("Chat", style: TextStyle(fontSize: 10, color: Colors.white))])),
        ])),
      ]));
    });
  }
}

class SheetPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  const SheetPage({super.key, required this.cameras});
  @override
  Widget build(BuildContext context){
    return Padding(padding: EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("Create - Self + AI One Min", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ListTile(leading: Icon(Icons.videocam, color: Colors.orange), title: Text("1. Self Vedio - USER BANA SAKTA HAI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), onTap: (){Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_)=>CamPage(cameras: cameras)));}),
      ListTile(leading: Icon(Icons.smart_toy, color: Colors.purpleAccent), title: Text("2. AI One Min Created - Natural", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), subtitle: Text("1 Min AI Video Auto", style: TextStyle(color: Colors.white70)), onTap: (){Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("AI One Min Video - Creating Natural Vedio...")));}),
      ListTile(leading: Icon(Icons.photo, color: Colors.blue), title: Text("3. Photo Post", style: TextStyle(color: Colors.white))),
      ListTile(leading: Icon(Icons.text_fields, color: Colors.yellow), title: Text("4. Shayari / Text", style: TextStyle(color: Colors.white))),
      ListTile(leading: Icon(Icons.park, color: Colors.green), title: Text("5. Natural 1-Min", style: TextStyle(color: Colors.white))),
      ListTile(leading: Icon(Icons.mic, color: Colors.red), title: Text("6. Audio / Podcast", style: TextStyle(color: Colors.white))),
      ListTile(leading: Icon(Icons.live_tv, color: Colors.pink), title: Text("7. Live - Family Safe", style: TextStyle(color: Colors.white))),
    ]));
  }
}

class CamPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CamPage({super.key, required this.cameras});
  @override
  State<CamPage> createState()=> _CamPageState();
}

class _CamPageState extends State<CamPage> {
  CameraController? con;
  bool ready=false; bool rec=false;
  @override
  void initState(){super.initState(); init();}
  Future<void> init() async {
    if(widget.cameras.isEmpty) return;
    con=CameraController(widget.cameras.first, ResolutionPreset.high, enableAudio: true);
    await con!.initialize();
    setState(()=>ready=true);
  }
  @override
  void dispose(){con?.dispose(); super.dispose();}
  Future<void> toggle() async {
    if(!rec){ await con!.startVideoRecording(); setState(()=>rec=true); }
    else{ final f=await con!.stopVideoRecording(); setState(()=>rec=false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video Save: ${f.path}"))); Navigator.pop(context); }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Self Vedio + AI One Min"), backgroundColor: Color(0xFF0A1F16)), backgroundColor: Colors.black,
      body: ready && con!=null? Stack(children: [CameraPreview(con!), if(rec) Positioned(top: 20, left: 20, child: Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)), child: Text("● REC")))]): Center(child: Text("Camera Allow Karo", style: TextStyle(color: Colors.white))),
      floatingActionButton: ready? FloatingActionButton.large(backgroundColor: rec?Colors.red:Colors.white, onPressed: toggle, child: Icon(rec?Icons.stop:Icons.videocam, color: rec?Colors.white:Colors.black, size: 35)):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1F16), Color(0xFF6A1B9A)])), child: Scaffold(backgroundColor: Colors.transparent, appBar: AppBar(title: Text("Profile"), backgroundColor: Colors.transparent), body: Center(child: Text("YK - Face Verify ✅ | Self + AI One Min", style: TextStyle(color: Colors.white, fontSize: 18)))));
  }
}
