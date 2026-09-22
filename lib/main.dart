import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'dart:async';

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
      title: 'Kolne',
      theme: ThemeData(
        primaryColor: Color(0xFF7C3AED),
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF7C3AED),
          secondary: Color(0xFF22C55E),
          tertiary: Color(0xFFFACC15),
        ),
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.hasData) return MainNavScreen();
        return LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF22C55E), Color(0xFF7C3AED), Color(0xFFFACC15)]),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Center(child: Text("K", style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))))),
              Text("KOLNE", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4)),
              Text("One Number = One ID", style: TextStyle(color: Colors.white70)),
              SizedBox(height: 40),
              TextField(controller: phoneController, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Mobile Number", filled: true, fillColor: Colors.black26, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFACC15), minimumSize: Size(double.infinity, 50)),
                onPressed: () async { await FirebaseAuth.instance.signInAnonymously(); },
                child: Text("LOGIN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class MainNavScreen extends StatefulWidget {
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}
class _MainNavScreenState extends State<MainNavScreen> {
  int current = 0;
  final screens = [FeedScreen(), SearchScreen(), CameraScreen(), InboxMutualScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[current],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, selectedItemColor: Color(0xFF22C55E), currentIndex: current, type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => current = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40, color: Color(0xFF7C3AED)), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('videos').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
        if (!snap.hasData) return Center(child: CircularProgressIndicator());
        if (snap.data!.docs.isEmpty) return Center(child: Text("No Kolne Yet", style: TextStyle(color: Colors.white)));
        return PageView.builder(scrollDirection: Axis.vertical, itemCount: snap.data!.docs.length, itemBuilder: (context, i) => VideoTile(data: snap.data!.docs[i]));
      },
    );
  }
}

class VideoTile extends StatefulWidget {
  final QueryDocumentSnapshot data;
  VideoTile({required this.data});
  @override
  State<VideoTile> createState() => _VideoTileState();
}
class _VideoTileState extends State<VideoTile> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.data['videoUrl']?? 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')..initialize().then((_) => setState(() {}))..setLooping(true)..play();
  }
  @override
  void dispose() { _controller?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _controller!= null && _controller!.value.isInitialized? SizedBox.expand(child: FittedBox(fit: BoxFit.cover, child: SizedBox(width: _controller!.value.size.width, height: _controller!.value.size.height, child: VideoPlayer(_controller!)))) : Container(color: Colors.black),
      Positioned(left: 10, bottom: 20, child: Text("${widget.data['caption']?? '#kolne'} - 1 Min", style: TextStyle(color: Colors.white))),
    ]);
  }
}

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}
class _CameraScreenState extends State<CameraScreen> {
  CameraController? camController;
  final picker = ImagePicker();
  Timer? timer;
  int seconds = 0;
  bool isRecording = false;
  @override
  void initState() { super.initState(); initCam(); }
  initCam() async {
    final cams = await availableCameras();
    camController = CameraController(cams[0], ResolutionPreset.high);
    await camController!.initialize();
    setState(() {});
  }
  startTimer() {
    seconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() => seconds++);
      if (seconds >= 60) { stopRecording(); }
    });
  }
  stopRecording() async {
    if (camController!.value.isRecordingVideo) {
      timer?.cancel();
      final f = await camController!.stopVideoRecording();
      setState(() { isRecording = false; });
      Navigator.push(context, MaterialPageRoute(builder: (_) => UploadScreen(videoFile: File(f.path), durationSec: seconds)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: camController == null ||!camController!.value.isInitialized? Center(child: CircularProgressIndicator())
          : Stack(children: [
              SizedBox.expand(child: CameraPreview(camController!)),
              if (isRecording) Positioned(top: 50, left: 0, right: 0, child: Center(child: Container(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: Text("${seconds}s / 60s", style: TextStyle(color: Colors.white))))),
              Positioned(bottom: 30, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                IconButton(icon: Icon(Icons.photo, color: Colors.white, size: 35), onPressed: () async {
                  final v = await picker.pickVideo(source: ImageSource.gallery);
                  if (v!= null) Navigator.push(context, MaterialPageRoute(builder: (_) => UploadScreen(videoFile: File(v.path), durationSec: 0)));
                }),
                GestureDetector(
                  onTap: () async {
                    if (isRecording) { await stopRecording(); }
                    else { await camController!.startVideoRecording(); setState(() => isRecording = true); startTimer(); }
                  },
                  child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xFFFACC15), width: 4), color: isRecording? Colors.red : Color(0xFF22C55E))),
                ),
                Icon(Icons.flip_camera_ios, color: Colors.white, size: 35),
              ])),
            ]),
    );
  }
}

class UploadScreen extends StatefulWidget {
  final File videoFile;
  final int durationSec;
  UploadScreen({required this.videoFile, required this.durationSec});
  @override
  State<UploadScreen> createState() => _UploadScreenState();
}
class _UploadScreenState extends State<UploadScreen> {
  final captionController = TextEditingController();
  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Kolne - 1 Min"), backgroundColor: Color(0xFF7C3AED)),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          Container(height: 200, color: Colors.grey[900], child: Center(child: Text("${widget.durationSec}s - Max 60s", style: TextStyle(color: Color(0xFFFACC15))))),
          SizedBox(height: 20),
          TextField(controller: captionController, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Add caption", border: OutlineInputBorder())),
          SizedBox(height: 20),
          uploading? CircularProgressIndicator() : ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF22C55E), minimumSize: Size(double.infinity, 50)),
            onPressed: () async {
              if (widget.durationSec > 60 && widget.durationSec!= 0) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("1 minute se zyada nahi!")));
                return;
              }
              List<String> badWords = ["sex", "xxx", "nude", "porn", "asleel", "gandi"];
              bool isBad = badWords.any((w) => captionController.text.toLowerCase().contains(w));
              if (isBad) {
                showDialog(context: context, builder: (_) => AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text("⚠️ Warning", style: TextStyle(color: Colors.red)),
                  content: Text("Asleel Content Allow Nahi Hai! Account Block Ho Jayega.", style: TextStyle(color: Colors.white)),
                  actions: [TextButton(onPressed: ()=> Navigator.pop(context), child: Text("OK"))],
                ));
                return;
              }
              setState(() => uploading = true);
              await FirebaseFirestore.instance.collection('videos').add({
                'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                'caption': captionController.text,
                'username': 'kolne_user',
                'likes': 0,
                'duration': widget.durationSec,
                'timestamp': FieldValue.serverTimestamp(),
              });
              setState(() => uploading = false);
              Navigator.pop(context); Navigator.pop(context);
            },
            child: Text("POST KOLNE"),
          ),
        ]),
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text("Search"), backgroundColor: Color(0xFF7C3AED)), body: Center(child: Text("Search", style: TextStyle(color: Colors.white))));
}

class InboxMutualScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Messages - Mutual Only"), backgroundColor: Color(0xFF7C3AED)),
      body: Center(child: Text("Sirf Mutual Follow wale hi message kar payenge", style: TextStyle(color: Colors.white))),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), backgroundColor: Color(0xFF7C3AED), actions: [IconButton(icon: Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen()))), IconButton(icon: Icon(Icons.logout), onPressed: () => FirebaseAuth.instance.signOut())]),
      body: Center(child: Text("Profile - One Number One ID", style: TextStyle(color: Colors.white))),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"), backgroundColor: Color(0xFF7C3AED)),
      body: ListView(children: [
        ListTile(title: Text("One Number One ID", style: TextStyle(color: Colors.white)), subtitle: Text("Active", style: TextStyle(color: Colors.white54))),
        ListTile(title: Text("Video Limit 1 Minute", style: TextStyle(color: Colors.white)), subtitle: Text("Max 60 sec", style: TextStyle(color: Colors.white54))),
        ListTile(title: Text("Asleel Block + Warning", style: TextStyle(color: Colors.white))),
        ListTile(title: Text("Mutual Chat Only", style: TextStyle(color: Colors.white))),
      ]),
    );
  }
}
