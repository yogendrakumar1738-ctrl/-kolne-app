import 'package:flutter/material.dart';
void main(){runApp(KolneFinal());}
class KolneFinal extends StatelessWidget{
  @override Widget build(BuildContext c)=>MaterialApp(debugShowCheckedModeBanner:false, home:Home());
}
class Home extends StatefulWidget{ @override _HomeState createState()=>_HomeState();}
class _HomeState extends State<Home>{
bool isShort=true;
List<String> cats=["All","Natural","Bhakti","Motivational","Knowledge","Fact","Shayari"];
void openCreate(){
showModalBottomSheet(context:context, builder:(_)=>Container(padding:EdgeInsets.all(16), child:Column(mainAxisSize:MainAxisSize.min, children:[
Text("Create - 7 Format", style:TextStyle(fontWeight:FontWeight.bold, fontSize:18)),
ListTile(leading:Icon(Icons.videocam), title:Text("1. Self Vedio")),
ListTile(leading:Icon(Icons.smart_toy), title:Text("2. AI Vedio Creat - 1 Min Natural")),
ListTile(leading:Icon(Icons.photo), title:Text("3. Photo Post")),
ListTile(leading:Icon(Icons.text_fields), title:Text("4. Shayari / Text Thought")),
ListTile(leading:Icon(Icons.park), title:Text("5. Natural 1-Min")),
ListTile(leading:Icon(Icons.mic), title:Text("6. Audio / Podcast")),
ListTile(leading:Icon(Icons.live_tv), title:Text("7. Live - Family Safe")),
])));}
@override Widget build(BuildContext context){
return Scaffold(backgroundColor:Colors.black,
body:Stack(children:[
PageView.builder(scrollDirection:Axis.vertical, itemCount:20, itemBuilder:(c,i)=>Container(color:Colors.grey[900], child:Stack(children:[
Center(child:Text(isShort?"Short ${i+1}\n15-60 sec":"Long ${i+1}\n2-5 min", style:TextStyle(color:Colors.white), textAlign:TextAlign.center)),
Positioned(right:10, bottom:120, child:Column(children:[
Icon(Icons.favorite, color:Colors.white), Text("Like", style:TextStyle(color:Colors.white, fontSize:10)),
SizedBox(height:10), Icon(Icons.comment, color:Colors.white), Text("Hide ON", style:TextStyle(color:Colors.white, fontSize:8)),
SizedBox(height:10), Icon(Icons.share, color:Colors.white),
SizedBox(height:10), Icon(Icons.music_note, color:Colors.white), Text("Music", style:TextStyle(color:Colors.white, fontSize:10)),
SizedBox(height:10), Icon(Icons.message, color:Colors.white), Text("Chat", style:TextStyle(color:Colors.white, fontSize:8)),
]))])),
Positioned(top:45, left:10, right:10, child:Column(children:[
Row(mainAxisAlignment:MainAxisAlignment.center, children:[
ChoiceChip(label:Text("Short"), selected:isShort, onSelected:(v)=>setState(()=>isShort=true)),
SizedBox(width:10),
ChoiceChip(label:Text("Long"), selected:!isShort, onSelected:(v)=>setState(()=>isShort=false)),
]),
SizedBox(height:10),
SingleChildScrollView(scrollDirection:Axis.horizontal, child:Row(children:cats.map((e)=>Container(margin:EdgeInsets.only(right:6), padding:EdgeInsets.symmetric(horizontal:12, vertical:6), decoration:BoxDecoration(color:Colors.white24, borderRadius:BorderRadius.circular(20)), child:Text(e, style:TextStyle(color:Colors.white, fontSize:12)))).toList())),
])),
Positioned(top:50, right:15, child:Container(padding:EdgeInsets.all(6), decoration:BoxDecoration(color:Colors.green, borderRadius:BorderRadius.circular(10)), child:Text("Face: 1 Mobile=1 ID", style:TextStyle(color:Colors.white, fontSize:8)))),
]),
floatingActionButton:FloatingActionButton(onPressed:openCreate, child:Icon(Icons.add)),
);
}
}
