import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

void main()=>runApp(KolneApp());

class KolneApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UploadScreen(),
    );
  }
}

class UploadScreen extends StatefulWidget{
  @override
  _UploadScreenState createState()=>_UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen>{
  File? naturalPhoto;
  XFile? oneMinVideo;
  VideoPlayerController? _videoController;
  ImagePicker _picker=ImagePicker();
  TextEditingController aiTextController=TextEditingController();
  TextEditingController hashtagController=TextEditingController();
  String selectedMode="SELF";
  String selectedMusic="No Music";
  List<String> musicList=["No Music","🎵 Punjabi Beat","🎵 Haryanvi Beat","🎵 Trending"];

  Future<void> pickPhoto() async{
    final p=await _picker.pickImage(source: ImageSource.gallery);
    if(p!=null){ setState(()=> naturalPhoto=File(p.path)); }
  }

  Future<void> pickSelfVideo() async{
    final v=await _picker.pickVideo(source: ImageSource.gallery);
    if(v!=null){ setState(()=> oneMinVideo=v); }
  }

  void showLockPopup(){
    showDialog(
      context: context,
      builder: (c)=> AlertDialog(
        title: Text("🔒 Premium Feature Lock"),
        content: Text("AI TEXT se Natural Video (All Category) 100k Users ke baad khulega!\n\nPlan: ₹199 = 30 Videos"),
        actions: [ TextButton(onPressed: ()=> Navigator.pop(c), child: Text("OK Samajh Gaya")) ],
      )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Kolne - 2 Options"), backgroundColor: Colors.deepPurple),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(onTap: pickPhoto, child: Container(height: 150, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)), child: Center(child: naturalPhoto==null? Text("Natural Photo Select Karo"): Image.file(naturalPhoto!)))),
            SizedBox(height: 15),
            Row(children: [
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: selectedMode=="SELF"? Colors.green: Colors.grey),
                onPressed: (){ setState(()=> selectedMode="SELF"); },
                child: Text("SELF - FREE")
              )),
              SizedBox(width: 10),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: (){ showLockPopup(); },
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.lock, size: 16), SizedBox(width: 4), Text("AI TEXT 🔒")]),
              )),
            ]),
            SizedBox(height: 15),
            if(selectedMode=="SELF") GestureDetector(onTap: pickSelfVideo, child: Container(height: 50, color: Colors.green[50], child: Center(child: Text(oneMinVideo==null? "1 Min Video Select Karo (SELF)": "Video Selected: ${oneMinVideo!.name}")))),
            if(selectedMode=="AI") Column(children: [TextField(controller: aiTextController, decoration: InputDecoration(labelText: "AI Text Liko... (LOCKED)", border: OutlineInputBorder())),]),
            SizedBox(height: 15),
            DropdownButton<String>(value: selectedMusic, isExpanded: true, items: musicList.map((e)=> DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v){ setState(()=> selectedMusic=v!); }),
            SizedBox(height: 10),
            TextField(controller: hashtagController, decoration: InputDecoration(labelText: "#Hashtag", border: OutlineInputBorder())),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: Size(double.infinity, 50)),
              onPressed: (){},
              child: Text(selectedMode=="SELF"? "Upload SELF Video": "AI LOCKED - 100k ke baad", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
