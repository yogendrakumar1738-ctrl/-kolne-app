import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
void main()=>runApp(KolneApp());
class KolneApp extends StatelessWidget{
@override Widget build(BuildContext context){return MaterialApp(debugShowCheckedModeBanner:false,theme:ThemeData.dark(),home:UploadScreen());}
}
class UploadScreen extends StatefulWidget{
@override _UploadScreenState createState()=>_UploadScreenState();
}
class _UploadScreenState extends State<UploadScreen>{
XFile? naturalPhoto; XFile? oneMinVideo; VideoPlayerController? _videoController;
final ImagePicker _picker=ImagePicker();
TextEditingController aiTextController=TextEditingController();
TextEditingController hashtagController=TextEditingController();
String selectedMode="SELF"; String selectedMusic="No Music"; bool isGenerating=false;
List<String> musicList=["No Music","🎵 Punjabi Beat","🎵 Arijit Love","🎵 Romantic"];
Future<void> pickPhoto() async{final p=await _picker.pickImage(source:ImageSource.camera,preferredCameraDevice:CameraDevice.front);if(p!=null)setState(()=>naturalPhoto=p);}
Future<void> pickSelfVideo() async{final v=await _picker.pickVideo(source:ImageSource.camera,maxDuration:Duration(seconds:60));if(v!=null){_videoController=VideoPlayerController.file(File(v.path))..initialize().then((_)=>setState((){}))..setLooping(true)..play();setState(()=>oneMinVideo=v);}}
Future<void> generateAI() async{if(aiTextController.text.isEmpty){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Pehle text likho!")));return;}setState(()=>isGenerating=true);await Future.delayed(Duration(seconds:3));setState(()=>isGenerating=false);ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("🤖 AI Video Ready")));setState(()=>oneMinVideo=XFile("ai"));}
@override Widget build(BuildContext context){
return Scaffold(appBar:AppBar(title:Text("Kolne - 2 Options"),backgroundColor:Colors.pink),
body:SingleChildScrollView(padding:EdgeInsets.all(16),child:Column(children:[
GestureDetector(onTap:pickPhoto,child:Container(height:160,decoration:BoxDecoration(color:Colors.grey[900],borderRadius:BorderRadius.circular(15),border:Border.all(color:Colors.pink)),child:naturalPhoto==null?Center(child:Text("📸 Natural Photo")):Image.file(File(naturalPhoto!.path),fit:BoxFit.cover,width:double.infinity))),
SizedBox(height:15),
Row(children:[Expanded(child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:selectedMode=="SELF"?Colors.pink:Colors.grey[800]),onPressed:()=>setState(()=>selectedMode="SELF"),child:Text("📹 SELF"))),SizedBox(width:10),Expanded(child:ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:selectedMode=="AI"?Colors.pink:Colors.grey[800]),onPressed:()=>setState(()=>selectedMode="AI"),child:Text("🤖 AI TEXT")))]),
SizedBox(height:15),
if(selectedMode=="SELF")GestureDetector(onTap:pickSelfVideo,child:Container(height:200,decoration:BoxDecoration(color:Colors.grey[900],borderRadius:BorderRadius.circular(15),border:Border.all(color:Colors.pink)),child:oneMinVideo==null?Center(child:Text("SELF 1 Min Video")): _videoController!=null && _videoController!.value.isInitialized?AspectRatio(aspectRatio:_videoController!.value.aspectRatio,child:VideoPlayer(_videoController!)):Center(child:Text("Ready ✅")))),
if(selectedMode=="AI")Column(children:[TextField(controller:aiTextController,maxLines:3,decoration:InputDecoration(hintText:"Ex: Jaipur se hu, natural look",filled:true,fillColor:Colors.grey[900],border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),SizedBox(height:10),ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Colors.purple,minimumSize:Size(double.infinity,50)),onPressed:isGenerating?null:generateAI,child:Text(isGenerating?"Generating...":"✨ AI SE VIDEO BANAO"))]),
SizedBox(height:15),
DropdownButton<String>(value:selectedMusic,isExpanded:true,dropdownColor:Colors.black,items:musicList.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>selectedMusic=v!)),
SizedBox(height:10),
TextField(controller:hashtagController,decoration:InputDecoration(hintText:"#Jaipur #Real",filled:true,fillColor:Colors.grey[900],border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)))),
SizedBox(height:20),
ElevatedButton(style:ElevatedButton.styleFrom(backgroundColor:Colors.pink,minimumSize:Size(double.infinity,55)),onPressed:(){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Uploaded: $selectedMode")));},child:Text("🚀 UPLOAD")),
])));}}
