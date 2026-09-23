import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try { cameras = await availableCameras(); } catch(e){}
  runApp(KolneApp());
}

class KolneApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomePage());
  }
}

class HomePage extends StatefulWidget { @override _HomePageState createState() => _HomePageState(); }

class _HomePageState extends State<HomePage> {
  CameraController? controller;
  XFile? videoFile;
  String? musicFile;
  String caption = "";
  String hashtag = "";
  bool isRecording = false;

  @override void initState() { super.initState(); initCam(); }
  initCam() async {
    if(cameras.isEmpty) return;
    controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: true);
    await controller!.initialize();
    setState(() {});
  }

  startRecord() async {
    await controller!.startVideoRecording();
    setState(() => isRecording = true);
    Future.delayed(Duration(seconds: 60), () { if(isRecording) stopRecord(); });
  }
  stopRecord() async {
    var file = await controller!.stopVideoRecording();
    setState(() { isRecording = false; videoFile = file; });
  }

  pickMusic() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if(result!= null) setState(() => musicFile = result.files.single.path);
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KOLNE - 1 Min Video")),
      body: Column(children: [
        if(controller!= null && controller!.value.isInitialized)
          AspectRatio(aspectRatio: controller!.value.aspectRatio, child: CameraPreview(controller!))
        else
          Container(height: 300, color: Colors.black, child: Center(child: Text("Camera Loading...", style: TextStyle(color: Colors.white)))),
        SizedBox(height: 10),
        Text(musicFile == null? "No Music Selected" : "Music: ${musicFile!.split('/').last}", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(onPressed: pickMusic, child: Text("Apna Gaana Chuno")),
          SizedBox(width: 10),
          ElevatedButton(onPressed: isRecording? stopRecord : startRecord, child: Text(isRecording? "Stop (60s max)" : "Record 1 Min")),
        ]),
        Padding(padding: EdgeInsets.all(10), child: Column(children: [
          TextField(onChanged: (v)=>caption=v, decoration: InputDecoration(hintText: "Caption likho...")),
          TextField(onChanged: (v)=>hashtag=v, decoration: InputDecoration(hintText: "#hashtag likho...")),
        ])),
        if(videoFile!= null) ElevatedButton(onPressed: (){}, child: Text("Post Video: $caption $hashtag")),
      ]),
    );
  }
}
