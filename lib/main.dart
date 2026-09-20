

import 'package:flutter/material.dart';
void main(){runApp(KolneFinal());}
class KolneFinal extends StatelessWidget{
@override
Widget build(BuildContext c){
return MaterialApp(
debugShowCheckedModeBanner:false,
home:Home());
}}
class Home extends StatefulWidget{
@override
_HomeState createState()=>_HomeState();}
class _HomeState extends State<Home>{
bool isShort=true;
void openCreate(){
showModalBottomSheet(
context:context,
builder:(_)=>Container(
padding:EdgeInsets.all(16),
child:Column(
mainAxisSize:MainAxisSize.min,
children:[
Text("Create - 7 Format",
style:TextStyle(fontWeight:FontWeight.bold)),
ListTile(leading:Icon(Icons.videocam),
title:Text("1. Self Vedio")),
ListTile(leading:Icon(Icons.smart_toy),
title:Text("2. AI Vedio Creat - 1 Min")),
ListTile(leading:Icon(Icons.photo),
title:Text("3. Photo Post")),
ListTile(leading:Icon(Icons.text_fields),
title:Text("4. Shayari / Thought")),
ListTile(leading:Icon(Icons.park),
title:Text("5. Natural 1-Min")),
ListTile(leading:Icon(Icons.mic),
title:Text("6. Audio / Podcast")),
ListTile(leading:Icon(Icons.live_tv),
title:Text("7. Live - Family Safe")),
])));}
@override
Widget build(BuildContext context){
return Scaffold(
backgroundColor:Colors.black,
body:Stack(children:[
PageView.builder(
scrollDirection:Axis.vertical,
itemCount:20,
itemBuilder:(c,i){
return Container(
color:Colors.grey[900],
child:Center(child:Text(
isShort?"Short ${i+1}":"Long ${i+1}",
style:TextStyle(color:Colors.white))));
}),
Positioned(
top:45,
left:10,
child:Row(children:[
ChoiceChip(label:Text("Short"),
selected:isShort,
onSelected:(v){
setState(()=>isShort=true);}),
SizedBox(width:10),
ChoiceChip(label:Text("Long"),
selected:!isShort,
onSelected:(v){
setState(()=>isShort=false);}),
])),
]),
floatingActionButton:FloatingActionButton(
onPressed:openCreate,
child:Icon(Icons.add)),
);}}
