import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

void main() => runApp(KolneApp());

class KolneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kolne - Real Profiles',
      theme: ThemeData.dark(),
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  XFile? naturalPhoto;
  XFile? oneMinVideo;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  TextEditingController hashtagController = TextEditingController();
  String selectedMusic = "No Music";

  List<String> trendingMusic = [
    "No Music",
    "🎵 Trending - Punjabi Beat",
    "🎵 Arijit Singh - Love Song",
    "🎵 Badshah - Party",
    "🎵 Slow Motion - Romantic",
    "🎵 Jaipur Local - Rajasthani"
  ];

  Future<void> pickNaturalPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if(photo!= null) setState(() => naturalPhoto = photo);
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery, maxDuration: Duration(seconds: 60));
    if(video!= null){
      _videoController = VideoPlayerController.file(File(video.path))..initialize().then((_) => setState((){}))..setLooping(true)..play();
      setState(() => oneMinVideo = video);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kolne - 1 Min Real Profile"), backgroundColor: Colors.pink),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Natural Photo
            GestureDetector(onTap: pickNaturalPhoto,
              child: Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.pink)),
                child: naturalPhoto == null? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, size: 50), Text("Natural Bala Photo (No Filter)")]) : ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.file(File(naturalPhoto!.path), fit: BoxFit.cover)),
              ),
            ),
            SizedBox(height: 15),
            // 1 Min Video
            GestureDetector(onTap: pickVideo,
              child: Container(height: 200, width: double.infinity, decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.pink)),
                child: oneMinVideo == null? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.videocam, size: 50), Text("1 Minute Video (Gallery)")]) : _videoController!= null && _videoController!.value.isInitialized? AspectRatio(aspectRatio: _videoController!.value.aspectRatio, child: VideoPlayer(_videoController!)) : CircularProgressIndicator(),
              ),
            ),
            SizedBox(height: 15),
            // Music Select
            Container(padding: EdgeInsets.symmetric(horizontal: 12), decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(value: selectedMusic, isExpanded: true, dropdownColor: Colors.black, underline: SizedBox(),
                items: trendingMusic.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => selectedMusic = v!),
              ),
            ),
            SizedBox(height: 15),
            // Hashtags
            TextField(controller: hashtagController, decoration: InputDecoration(hintText: "#Hashtags likho ex: #Natural #Jaipur #Single", filled: true, fillColor: Colors.grey[900], border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: Icon(Icons.tag, color: Colors.pink))),
            SizedBox(height: 25),
            // Upload Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, minimumSize: Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: (){
                if(naturalPhoto!= null && oneMinVideo!= null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Profile Ready! Photo + ${selectedMusic} + ${hashtagController.text}")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pehle Natural Photo + 1 Min Video dono select karo!")));
                }
              },
              child: Text("🚀 UPLOAD REAL PROFILE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Text("User ko milega: Natural Photo + 1 Min Video + Music 🎵 + Hashtags #️⃣", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
