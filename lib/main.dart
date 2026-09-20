
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try { cameras = await availableCameras(); } catch(e){}
  runApp(const KolneApp());
}

class KolneApp extends StatelessWidget {
  const KolneApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const HomeScreen(),
    );
  }
}

class Post { String type; String text; File? file; int likes; bool liked; Post({required this.type, required this.text, this.file, this.likes=0, this.liked=false}); }

List<Post> allPosts = [
  Post(type: "Shayari", text: "Zindagi Natural Jiyo - Kolne Pe Aao 🌿", likes: 12),
  Post(type: "Natural", text: "Pahadon ki hawa me sukoon hai...", likes: 45),
];

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=> _HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen>{
  String filter = "All";
  void openSheet(){
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1E1E1E), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (c)=> Wrap(children: [
        const SizedBox(height:10), Center(child: Container(width:40,height:4,decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)))),
        ListTile(leading: const Icon(Icons.videocam, color: Colors.red), title: const Text("1. Self Vedio - Camera"), onTap: ()=> _openCam("Self Vedio")),
        ListTile(leading: const Icon(Icons.smart_toy, color: Colors.purple), title: const Text("2. AI Vedio Creat - 1 Min"), onTap: ()=> _openText("AI Vedio")),
        ListTile(leading: const Icon(Icons.photo, color: Colors.blue), title: const Text("3. Photo Post - Gallery"), onTap: pickPhoto),
        ListTile(leading: const Icon(Icons.text_fields, color: Colors.orange), title: const Text("4. Shayari / Thought"), onTap: ()=> _openText("Shayari")),
        ListTile(leading: const Icon(Icons.eco, color: Colors.green), title: const Text("5. Natural 1-Min"), onTap: ()=> _openCam("Natural 1-Min")),
        ListTile(leading: const Icon(Icons.mic, color: Colors.yellow), title: const Text("6. Audio / Podcast"), onTap: openAudio),
        ListTile(leading: const Icon(Icons.live_tv, color: Colors.redAccent), title: const Text("7. Live - Family Safe"), onTap: (){Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Live Kal Backend ke sath ayega!")));}),
        const SizedBox(height:20),
      ]));
  }
  void _openCam(String t){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_)=> CamPage(type: t, onPost: (p){setState(()=> allPosts.insert(0,p));}))); }
  void _openText(String t){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_)=> TextPage(type: t, onPost: (p){setState(()=> allPosts.insert(0,p));}))); }
  Future<void> pickPhoto() async { Navigator.pop(context); final picker=ImagePicker(); final XFile? img=await picker.pickImage(source: ImageSource.gallery); if(img!=null){ setState(()=> allPosts.insert(0, Post(type:"Photo", text:"Meri Photo Post 📸", file: File(img.path)))); } }
  void openAudio(){ Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_)=> AudioPage(onPost: (p){setState(()=> allPosts.insert(0,p));}))); }

  @override Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text("KOLNE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2))),
      body: Column(children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ["All","Natural","Bhakti","Motivational","Knowledge","Shayari"].map((e)=> Padding(padding: const EdgeInsets.all(6), child: ChoiceChip(label: Text(e), selected: filter==e, onSelected: (_){setState(()=> filter=e);}))).toList())),
        Expanded(child: PageView.builder(scrollDirection: Axis.vertical, itemCount: allPosts.length, itemBuilder: (c,i){
          final post=allPosts[i];
          return Stack(children: [
            Container(color: Colors.grey[900], width: double.infinity, height: double.infinity, child: post.file!=null? (post.type=="Photo"? Image.file(post.file!, fit: BoxFit.cover): Container(color: Colors.black, child: Center(child: Icon(Icons.videocam, size: 80)))) : Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(post.text, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center)))),
            Positioned(bottom: 90, left: 12, right: 80, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("@yk_kolne - ${post.type}", style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 6), Text(post.text, maxLines: 2)])),
            Positioned(right: 10, bottom: 90, child: Column(children: [
              IconButton(icon: Icon(post.liked? Icons.favorite: Icons.favorite_border, color: post.liked? Colors.red: Colors.white, size: 32), onPressed: (){setState(()=> {post.liked=!post.liked, post.likes+= post.liked?1:-1});}),
              Text("${post.likes}"),
              const SizedBox(height: 18), const Icon(Icons.comment, size: 26), const Text("Hide", style: TextStyle(fontSize:10)),
              const SizedBox(height: 18), const Icon(Icons.share, size: 26),
              const SizedBox(height: 18), const Icon(Icons.music_note, size: 26),
            ]))
          ]);
        }))
      ]),
      bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.black, selectedItemColor: Colors.white, unselectedItemColor: Colors.white54, currentIndex: 0, onTap: (i){ if(i==1) openSheet(); }, items: const [BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 36), label: "+"), BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")]),
    );
  }
}

class CamPage extends StatefulWidget { final String type; final Function(Post) onPost; const CamPage({super.key, required this.type, required this.onPost}); @override State<CamPage> createState()=> _CamPageState(); }
class _CamPageState extends State<CamPage>{
  CameraController? ctrl; bool rec=false; bool init=false;
  @override void initState(){ super.initState(); initCam(); }
  Future<void> initCam() async { if(cameras.isEmpty) return; ctrl=CameraController(cameras[0], ResolutionPreset.medium); await ctrl!.initialize(); setState(()=> init=true); }
  @override void dispose(){ ctrl?.dispose(); super.dispose();}
  @override Widget build(BuildContext context){
    if(!init) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(body: Stack(children: [
      CameraPreview(ctrl!),
      Positioned(bottom: 30, left:0, right:0, child: Center(child: GestureDetector(onTap: () async { if(!rec){ await ctrl!.startVideoRecording(); setState(()=> rec=true);} else { final f=await ctrl!.stopVideoRecording(); widget.onPost(Post(type: widget.type, text: "${widget.type} - Real Record", file: File(f.path))); if(mounted) Navigator.pop(context); } }, child: Container(width:80,height:80,decoration: BoxDecoration(color: rec? Colors.red: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.white, width:4)))))),
      Positioned(top:40, left:12, child: IconButton(icon: const Icon(Icons.close, size:30), onPressed: ()=> Navigator.pop(context))),
      Positioned(top:40, right:12, child: Container(color: Colors.black54, padding: const EdgeInsets.all(6), child: Text(widget.type))),
    ]));
  }
}

class TextPage extends StatefulWidget { final String type; final Function(Post) onPost; const TextPage({super.key, required this.type, required this.onPost}); @override State<TextPage> createState()=> _TextPageState(); }
class _TextPageState extends State<TextPage>{ final t=TextEditingController(); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: Text(widget.type)), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [ TextField(controller: t, maxLines: 8, decoration: InputDecoration(hintText: widget.type=="Shayari"?"Apni shayari likho...": "AI Topic likho - Kal se auto video banega", border: const OutlineInputBorder()), style: const TextStyle(fontSize:18)), const SizedBox(height:20), ElevatedButton(onPressed: (){ if(t.text.isEmpty) return; widget.onPost(Post(type: widget.type, text: t.text)); Navigator.pop(context); }, style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity,50)), child: const Text("POST KARO")), if(widget.type=="AI Vedio") const Padding(padding: EdgeInsets.only(top:12), child: Text("Note: Kal backend judne ke baad ye text se 1-min video auto banayega. Abhi text post hoga.", style: TextStyle(color: Colors.white54, fontSize:12))) ]))); } }

class AudioPage extends StatefulWidget { final Function(Post) onPost; const AudioPage({super.key, required this.onPost}); @override State<AudioPage> createState()=> _AudioPageState(); }
class _AudioPageState extends State<AudioPage>{ final rec=AudioRecorder(); bool isRec=false; String? path; @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text("Audio / Podcast")), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(Icons.mic, size:100, color: isRec? Colors.red: Colors.white), const SizedBox(height:20), Text(isRec? "Recording...": "Tap to Record"), const SizedBox(height:30), ElevatedButton(onPressed: () async { if(!isRec){ if(await rec.hasPermission()){ final dir=await getTemporaryDirectory(); path="${dir.path}/kolne_${DateTime.now().millisecondsSinceEpoch}.m4a"; await rec.start(const RecordConfig(), path: path!); setState(()=> isRec=true);} } else { await rec.stop(); setState(()=> isRec=false); widget.onPost(Post(type:"Audio", text:"Mera Podcast 🎙️")); if(mounted) Navigator.pop(context); } }, child: Text(isRec? "STOP & POST": "RECORD START")), ]))); } }
