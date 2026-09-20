import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
void main() async { WidgetsFlutterBinding.ensureInitialized(); final cams = await availableCameras(); runApp(KolneApp(cameras: cams)); }
class KolneApp extends StatelessWidget { final List<CameraDescription> cameras; const KolneApp({super.key, required this.cameras}); @override Widget build(BuildContext c) => MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: HomeScreen(cameras: cameras)); }
class HomeScreen extends StatefulWidget { final List<CameraDescription> cameras; const HomeScreen({super.key, required this.cameras}); @override State<HomeScreen> createState() => _HomeScreenState(); }
class _HomeScreenState extends State<HomeScreen> {
 bool isShort = true; CameraController? controller; List<String> cats = ["All","Natural","Bhakti","Motivational","Knowledge","Fact","Shayari"]; List<String> badWords = ["mc","bc","bkl"];
 @override void initState(){ super.initState(); initCam(); }
 void initCam() async { if(widget.cameras.isEmpty) return; controller = CameraController(widget.cameras[0], ResolutionPreset.high); await controller!.initialize(); if(mounted) setState((){}); }
 @override void dispose(){ controller?.dispose(); super.dispose(); }
 String filterComment(String t){ for(var b in badWords){ if(t.toLowerCase().contains(b)) return "*** hidden - gaali filter ***"; } return t; }
 void openCreate(){ showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Color(0xFF1a1a1a), builder: (_) => Container(padding: EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
   Container(width:40,height:4,decoration:BoxDecoration(color:Colors.white24,borderRadius: BorderRadius.circular(10))), SizedBox(height:12),
   Text("Create - 7 Format", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)), SizedBox(height:10),
   ListTile(leading: Icon(Icons.videocam, color: Colors.orange), title: Text("1. Self Vedio", style: TextStyle(color: Colors.white)), subtitle: Text("Camera clear - No black", style: TextStyle(color: Colors.white54))),
   ListTile(leading: Icon(Icons.smart_toy, color: Colors.purple), title: Text("2. AI Vedio Creat 1 Min Natural", style: TextStyle(color: Colors.white))),
   ListTile(leading: Icon(Icons.photo, color: Colors.blue), title: Text("3. Photo Post", style: TextStyle(color: Colors.white))),
   ListTile(leading: Icon(Icons.text_fields, color: Colors.yellow), title: Text("4. Shayari / Text Thought", style: TextStyle(color: Colors.white))),
   ListTile(leading: Icon(Icons.park, color: Colors.green), title: Text("5. Natural 1-Min", style: TextStyle(color: Colors.white))),
   ListTile(leading: Icon(Icons.mic, color: Colors.red), title: Text("6. Audio / Podcast", style: TextStyle(color: Colors.white))),
   ListTile(leading: Icon(Icons.live_tv, color: Colors.pink), title: Text("7. Live Family Safe", style: TextStyle(color: Colors.white)), subtitle: Text("Comment Hide ON", style: TextStyle(color: Colors.white54))),
   SizedBox(height:8), Text("Features: Like/Comment Hide/Share/Music/Self Message Mutual", style: TextStyle(color: Colors.white38, fontSize: 10)),
 ]))); }
 @override Widget build(BuildContext context){ return Scaffold(backgroundColor: Colors.black, body: Stack(children: [
   PageView.builder(scrollDirection: Axis.vertical, itemCount: 10, itemBuilder: (c,i) => Container(color: Colors.grey[900], child: Stack(children: [
     Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(isShort?"Short Reel ${i+1}":"Long Reel ${i+1}", style: TextStyle(color: Colors.white, fontSize: 22)), Text(isShort?"15-60 sec":"2-5 min", style: TextStyle(color: Colors.white54)), SizedBox(height:20), Container(padding: EdgeInsets.all(8), color: Colors.black54, child: Text(filterComment(i%3==0?"nice vedio mc":"mast hai bhai"), style: TextStyle(color: Colors.white70, fontSize: 12)))])),
     Positioned(right:12, bottom:130, child: Column(children: [Icon(Icons.favorite, color: Colors.white, size: 32), Text("Like", style: TextStyle(color: Colors.white, fontSize:10)), SizedBox(height:18), Icon(Icons.comment, color: Colors.white, size: 32), Text("Hide ON", style: TextStyle(color: Colors.green, fontSize:8)), SizedBox(height:18), Icon(Icons.share, color: Colors.white, size: 32), SizedBox(height:18), Icon(Icons.music_note, color: Colors.white, size: 32), SizedBox(height:18), Icon(Icons.message, color: Colors.white, size: 32), Text("Chat\nMutual", style: TextStyle(color: Colors.white, fontSize:8))])),
   ]))),
   Positioned(top:50, left:10, right:10, child: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [ChoiceChip(label: Text("Short"), selected: isShort, onSelected: (v)=>setState(()=>isShort=true)), SizedBox(width:10), ChoiceChip(label: Text("Long"), selected:!isShort, onSelected: (v)=>setState(()=>isShort=false))]), SizedBox(height:12), SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: cats.map((e)=> Container(margin: EdgeInsets.only(right:8), padding: EdgeInsets.symmetric(horizontal:14, vertical:6), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)), child: Text(e, style: TextStyle(color: Colors.white, fontSize:12)))).toList()))])),
   Positioned(top:48, right:14, child: Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)), child: Text("Face Verify: 1 Mobile=1 ID", style: TextStyle(fontSize:8, color: Colors.white)))),
 ]), floatingActionButton: FloatingActionButton(onPressed: openCreate, backgroundColor: Colors.white, child: Icon(Icons.add, color: Colors.black, size: 32)), ); }
}
class CameraPage extends StatelessWidget{ final List<CameraDescription> cameras; final CameraController? controller; const CameraPage({super.key, required this.cameras, this.controller}); @override Widget build(BuildContext context){ return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: Text("Self Vedio - Camera"), backgroundColor: Colors.black), body: controller==null ||!controller!.value.isInitialized? Center(child: CircularProgressIndicator()): CameraPreview(controller!), floatingActionButton: FloatingActionButton(onPressed: (){}, child: Icon(Icons.camera_alt)), ); } }
