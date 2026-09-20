import 'package:flutter/material.dart';import 'package:camera/camera.dart';void main()async{Widg
etsFlutterBinding.ensureInitialized();final c=await availableCameras();runApp(M(c:c));}class M ext
ends StatelessWidget{final List<CameraDescription> c;const M({super.key,required this.c});@override
Widget build(BuildContext context){return MaterialApp(debugShowCheckedModeBanner:false,theme:Theme
Data.dark().copyWith(scaffoldBackgroundColor:const Color(0xFF0A1F16)),home:BN(c:c));}}class BN exte
nds StatefulWidget{final List<CameraDescription> c;const BN({super.key,required this.c});@override
State<BN> createState()=>_BN();}class _BN extends State<BN>{int i=0;bool b=true;@override void ini
tState(){super.initState();WidgetsBinding.instance.addPostFrameCallback((_)=>showDialog(context:co
ntext,builder:(_)=>AlertDialog(backgroundColor:const Color(0xFF1B4D3E),title:const Text("🌿 Roj +10
"),content:const Text("Self + AI One Min Ready",style:TextStyle(color:Colors.white70)),actions:[Te
xtButton(onPressed:()=>Navigator.pop(context),child:const Text("OK"))])));} @override Widget build(
BuildContext c){return Scaffold(body:NotificationListener<ScrollNotification>(onNotification:(n){
if(n is ScrollStartNotification)setState(()=>b=false);if(n is ScrollEndNotification)Future.delayed(
const Duration(seconds:2),()=>setState(()=>b=true));return false;},child:i==0?FD(ca:widget.c):i==4
?const PP():const Center(child:Text("Soon",style:TextStyle(color:Colors.white)))),bottomNavigatio
nBar:AnimatedContainer(duration:const Duration(milliseconds:300),height:b?70:0,child:b?BottomNaviga
tionBar(backgroundColor:const Color(0xFF0A1F16),type:BottomNavigationBarType.fixed,selectedItemColo
r:Colors.white,unselectedItemColor:Colors.white54,currentIndex:i,onTap:(x){if(x==2)showModalBottomS
heet(context:context,backgroundColor:const Color(0xFF1B4D3E),builder:(_)=>SP(ca:widget.c));else setS
tate(()=>i=x);},items:[const BottomNavigationBarItem(icon:Icon(Icons.home),label:"Home"),const Bot
tomNavigationBarItem(icon:Icon(Icons.search),label:"Search"),BottomNavigationBarItem(icon:Contain
er(padding:const EdgeInsets.all(10),decoration:const BoxDecoration(gradient:LinearGradient(colors:[
Color(0xFF1B4D3E),Color(0xFF6A1B9A)]),shape:BoxShape.circle),child:const Icon(Icons.add,color:Color
s.white)),label:""),const BottomNavigationBarItem(icon:Icon(Icons.favorite,color:Color(0xFF6A1B9A)
),label:"Like"),const BottomNavigationBarItem(icon:Icon(Icons.person),label:"Pro")]):const SizedBox
()),);}}class FD extends StatefulWidget{final List<CameraDescription> ca;const FD({super.key,requi
red this.ca});@override State<FD> createState()=>_FD();}class _FD extends State<FD>{List<bool> l=Li
st
