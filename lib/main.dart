import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'dart:io';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try { cameras = await availableCameras(); } catch(e){}
  runApp(KolneApp());
}

class KolneApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget { @override _LoginScreenState createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController(); bool otpSent = false; final otpCtrl = TextEditingController();
  @override Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Padding(padding: EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("KOLNE", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)), SizedBox(height: 20),
      TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: "Mobile Number", border: OutlineInputBorder())),
      SizedBox(height: 10),
      if(otpSent) TextField(controller: otpCtrl, decoration: InputDecoration(labelText: "Enter OTP 123456", border: OutlineInputBorder())),
      SizedBox(height: 20),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: Size(double.infinity, 50)), onPressed: (){
        if(!otpSent){ setState(()=>otpSent=true); } else { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>MainApp())); }
      }, child: Text(otpSent? "VERIFY & ENTER" : "SEND OTP", style: TextStyle(color: Colors.white)))
    ]))));
  }
}

class MainApp extends StatefulWidget { @override _MainAppState createState() => _MainAppState(); }
class _MainAppState extends State<MainApp> {
  int index = 2; List<Map<String,dynamic>> videos = [];
  @override Widget build(BuildContext context) {
    return Scaffold(
      body: [FeedScreen(videos: videos), Center(child: Text("Search")), CreateScreen(onUpload: (data){ setState((){ videos.insert(0, data); index=0; }); }), Center(child: Text("Chat")), Center(child: Text("Profile"))][index],
      bottomNavigationBar: BottomNavigationBar(currentIndex: index, onTap: (i)=>setState(()=>index=i), type: BottomNavigationBarType.fixed, selectedItemColor: Colors.orange, items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40, color: Colors.orange), label: "Create"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ]),
    );
  }
}

class CreateScreen extends StatefulWidget {
  final Function(Map<String,dynamic>) onUpload; CreateScreen({required this.onUpload});
  @override _CreateScreenState createState() => _CreateScreenState();
}
class _CreateScreenState extends State<CreateScreen> {
  CameraController? camCtrl; bool isRecording = false; int sec = 0;
  String selectedMusic = "Original"; String hashtags = "";
  @override void initState(){ super.initState(); initCam(); }
  initCam() async { if(cameras.isNotEmpty){ camCtrl = CameraController(cameras[0], ResolutionPreset.high, enableAudio: true); await camCtrl!.initialize(); if(mounted) setState((){}); } }
  @override void dispose(){ camCtrl?.dispose(); super.dispose(); }
  startTimer(){ sec=0; Stream.periodic(Duration(seconds: 1), (i)=>i).take(60).listen((i){ if(!isRecording) return; setState(()=>sec=i+1); if(sec>=60) stopRec(); }); }
  startRec() async { await camCtrl?.startVideoRecording(); setState(()=>isRecording=true); startTimer(); }
  stopRec() async { var file = await camCtrl?.stopVideoRecording(); setState(()=>isRecording=false); if(file!=null) openCaption(file.path); }
  openCaption(String path){ showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.white, builder: (_)=>CaptionSheet(videoPath: path, music: selectedMusic, onPost: (data){ widget.onUpload(data); Navigator.pop(context); })); }
  pickGallery() async { var picked = await ImagePicker().pickVideo(source: ImageSource.gallery); if(picked!=null) openCaption(picked.path); }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("$sec / 60 Sec ${isRecording? '● REC' : ''}"), actions: [IconButton(icon: Icon(Icons.video_library), onPressed: pickGallery)]),
      body: Column(children: [
        Expanded(child: camCtrl==null ||!camCtrl!.value.isInitialized? Center(child: Icon(Icons.videocam_off, size: 80)) : CameraPreview(camCtrl!)),
        Container(color: Colors.black12, padding: EdgeInsets.all(10), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: ["Original","Lofi","Trending","Sayari"].map((m)=>ChoiceChip(label: Text(m), selected: selectedMusic==m, onSelected: (_)=>setState(()=>selectedMusic=m))).toList()),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(onTap: isRecording? stopRec : startRec, child: Container(width: 80, height: 80, decoration: BoxDecoration(color: isRecording?Colors.red:Colors.orange, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)), child: Icon(isRecording?Icons.stop:Icons.videocam, color: Colors.white, size: 40))),
          ])
        ]))
      ]),
    );
  }
}

class CaptionSheet extends StatefulWidget {
  final String videoPath; final String music; final Function(Map<String,dynamic>) onPost;
  CaptionSheet({required this.videoPath, required this.music, required this.onPost});
  @override _CaptionSheetState createState() => _CaptionSheetState();
}
class _CaptionSheetState extends State<CaptionSheet> {
  final capCtrl = TextEditingController();
  final hashCtrl = TextEditingController(text: "#kolne ");
  final musicSearchCtrl = TextEditingController();
  String selectedMusic = ""; String? customMusicPath; bool isMixing = false;

  List<String> allMusics = ["Original Audio","Lofi Beat - Slow","Trending - Viral 2024","Sayari - Dard","Arijit Singh - Channa","Punjabi - Sidhu Moose","Haryanvi - Masoom","Bhojpuri - Khesari","DJ Remix - Bass","Romantic Piano"];
  List<String> filteredMusics = [];
  List<String> trendingHashtags = ["#kolne","#trending","#viral","#foryou","#sayari","#lofi","#punjabi","#haryanvi","#bhojpuri","#love","#ganganagar"];

  @override void initState(){
    super.initState();
    selectedMusic = widget.music; filteredMusics = allMusics;
    musicSearchCtrl.addListener((){
      setState(()=> filteredMusics = allMusics.where((m)=>m.toLowerCase().contains(musicSearchCtrl.text.toLowerCase())).toList());
    });
  }

  pickCustomMusic() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if(result!= null){ setState((){ customMusicPath = result.files.single.path; selectedMusic = result.files.single.name; }); }
  }

  uploadNow() async {
    setState(()=>isMixing=true);
    String finalVideoPath = widget.videoPath;
    if(customMusicPath!= null){
      String outPath = "/data/data/com.example.kolne/cache/final_${DateTime.now().millisecondsSinceEpoch}.mp4";
      await FFmpegKit.execute("-i ${widget.videoPath} -i $customMusicPath -c:v copy -map 0:v:0 -map 1:a:0 -shortest $outPath").then((s) async {
        var state = await s.getState(); if(state.toString().contains("COMPLETED")) finalVideoPath = outPath;
      });
    }
    String finalCaption = "${capCtrl.text}\n${hashCtrl.text}\n🎵 $selectedMusic";
    widget.onPost({"path": finalVideoPath, "caption": finalCaption, "hashtags": hashCtrl.text, "music": selectedMusic});
    setState(()=>isMixing=false);
  }

  @override Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), child: DraggableScrollableSheet(initialChildSize: 0.9, expand: false, builder: (_, controller)=>Padding(padding: EdgeInsets.all(15), child: ListView(controller: controller, children: [
      Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)))), SizedBox(height: 10),
      Text("Add Caption + Music + Hashtag", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), SizedBox(height: 10),
      TextField(controller: capCtrl, decoration: InputDecoration(labelText: "Caption likho...", border: OutlineInputBorder(), prefixIcon: Icon(Icons.edit))),
      SizedBox(height: 10),
      TextField(controller: musicSearchCtrl, decoration: InputDecoration(hintText: "Search Music - Lofi, Arijit...", border: OutlineInputBorder(), prefixIcon: Icon(Icons.search))),
      Container(height: 100, margin: EdgeInsets.only(top:5), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)), child: ListView.builder(itemCount: filteredMusics.length, itemBuilder: (_, i)=>ListTile(dense:true, title: Text(filteredMusics[i]), trailing: selectedMusic==filteredMusics[i]? Icon(Icons.check, color: Colors.orange):null, onTap: ()=>setState(()=>selectedMusic=filteredMusics[i])))),
      SizedBox(height: 8),
      ElevatedButton.icon(icon: Icon(Icons.music_note), label: Text(customMusicPath==null? "Apna Gaana Chuno (MP3)" : "Selected: $selectedMusic"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white), onPressed: pickCustomMusic),
      SizedBox(height: 10),
      TextField(controller: hashCtrl, maxLines: 2, decoration: InputDecoration(labelText: "Hashtags", border: OutlineInputBorder(), prefixIcon: Icon(Icons.tag))),
      Wrap(spacing: 5, children: trendingHashtags.map((h)=>ActionChip(label: Text(h), onPressed: (){ if(!hashCtrl.text.contains(h)) setState(()=>hashCtrl.text=hashCtrl.text+" "+h); })).toList()),
      SizedBox(height: 20),
      isMixing? Center(child: Column(children:[CircularProgressIndicator(), Text("Music mix ho raha hai...")])) :
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, minimumSize: Size(double.infinity, 50)), onPressed: uploadNow, child: Text("UPLOAD TO PUBLIC FEED 🚀", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
    ]))));
  }
}

class FeedScreen extends StatelessWidget {
  final List<Map<String,dynamic>> videos; FeedScreen({required this.videos});
  @override Widget build(BuildContext context) {
    if(videos.isEmpty) return Center(child: Text("Koi video nahi! Create se banao 🎥"));
    return ListView.builder(itemCount: videos.length, itemBuilder: (_, i){
      var v = videos[i];
      return Card(margin: EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 400, color: Colors.black, child: Center(child: Icon(Icons.play_circle, size: 60, color: Colors.white))),
        Padding(padding: EdgeInsets.all(10), child: Text(v["caption"]?? "", style: TextStyle(fontWeight: FontWeight.w500))),
      ]));
    });
  }
}
