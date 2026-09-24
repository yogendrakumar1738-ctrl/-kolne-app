import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const KolneApp());

class KolneApp extends StatelessWidget {
  const KolneApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOLNE - Real 1 Mint',
      theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: Colors.black),
      home: const LoginScreen(),
    );
  }
}

// 1. LOGIN - NUMBER + OTP VERIFY - 1 NUMBER = 1 ID
class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('KOLNE', style: TextStyle(color: Colors.purple, fontSize: 48, fontWeight: FontWeight.bold)),
      const Text('Instagram jaisa - Sirf REAL', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 40),
      TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Mobile Number', hintStyle: const TextStyle(color: Colors.white54), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.white10)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.all(16)), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=> OtpScreen(phone: phoneCtrl.text))), child: const Text('OTP Bhejo - Verify ID', style: TextStyle(color: Colors.white)))),
      const SizedBox(height: 10), const Text('1 Number = 1 ID - Verify Clean', style: TextStyle(color: Colors.white38, fontSize: 12))
    ])));
  }
}

class OtpScreen extends StatelessWidget {
  final String phone; const OtpScreen({super.key, required this.phone});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(phone), backgroundColor: Colors.black, foregroundColor: Colors.white), body: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Text('OTP Verify - 6 Box', style: TextStyle(color: Colors.white, fontSize: 20)),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(6, (i)=> Container(width: 45, height: 55, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.purple)), child: const TextField(textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20), decoration: InputDecoration(border: InputBorder.none), maxLength: 1)))),
      const SizedBox(height: 30),
      SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.all(16)), onPressed: ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const MainApp())), child: const Text('Verify & Login', style: TextStyle(color: Colors.white))))
    ])));
  }
}

// 2. MAIN APP - 5 BUTTON - INSTAGRAM JAISA
class MainApp extends StatefulWidget { const MainApp({super.key}); @override State<MainApp> createState() => _MainAppState(); }
class _MainAppState extends State<MainApp> {
  int index = 0;
  final pages = [const HomeFeed(), const SearchScreen(), const CreateScreen(), const InboxScreen(), const ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: pages[index], bottomNavigationBar: BottomNavigationBar(currentIndex: index, onTap: (i)=>setState(()=>index=i), backgroundColor: Colors.black, selectedItemColor: Colors.purple, unselectedItemColor: Colors.white54, type: BottomNavigationBarType.fixed, items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create'),
      BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ]));
  }
}

// 3. HOME - 9:16 VIDEO FEED - CHALEGA - LOG DEKHENGE
class HomeFeed extends StatelessWidget { const HomeFeed({super.key});
  @override
  Widget build(BuildContext context) {
    return PageView.builder(itemCount: 10, scrollDirection: Axis.vertical, itemBuilder: (ctx, i){
      return Stack(children: [
        Container(color: Colors.grey[900], child: Center(child: AspectRatio(aspectRatio: 9/16, child: Container(margin: const EdgeInsets.all(8), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.play_circle, size: 80, color: Colors.white.withOpacity(0.8)), const SizedBox(height: 10), const Text('9:16 - 1 MINT REAL VIDEO', style: TextStyle(color: Colors.white)), const Text('KOLNE Watermark', style: TextStyle(color: Colors.white54))]))))),
        Positioned(bottom: 80, left: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('@user_$i - REAL', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Text('#kolne #real #bharat #9x16', style: TextStyle(color: Colors.white70)), Row(children: [const Icon(Icons.music_note, color: Colors.white, size: 14), const SizedBox(width: 4), Text('Trending Music - Auto + User', style: TextStyle(color: Colors.white.withOpacity(0.9)))])])),
        const Positioned(bottom: 80, right: 16, child: Column(children: [Icon(Icons.favorite, color: Colors.white, size: 30), SizedBox(height: 20), Icon(Icons.comment, color: Colors.white, size: 30), SizedBox(height: 20), Icon(Icons.share, color: Colors.white, size: 30)]))
      ]);
    });
  }
}

class SearchScreen extends StatelessWidget { const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Search - #Hashtag', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black), body: Column(children: [Padding(padding: const EdgeInsets.all(12), child: TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(hintText: 'Search #kolne #real', hintStyle: const TextStyle(color: Colors.white54), prefixIcon: const Icon(Icons.search, color: Colors.white54), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))), Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 9/16), itemCount: 12, itemBuilder: (_, i)=> Container(margin: const EdgeInsets.all(2), color: Colors.grey[900], child: Center(child: Text('9:16\n#tag $i', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54))))))]));
  }
}

// 4. CREATE - SELF + AI + GALLERY - 1 MINT 9:16 + MUSIC HASHTAGS USER LAGAYEGA
class CreateScreen extends StatefulWidget { const CreateScreen({super.key}); @override State<CreateScreen> createState() => _CreateScreenState(); }
class _CreateScreenState extends State<CreateScreen> {
  int sec=0; Timer? t; bool rec=false;
  final musicCtrl = TextEditingController(text: 'Trending Lofi');
  final hashCtrl = TextEditingController(text: '#kolne #real #bharat');
  void start(){ rec=true; t=Timer.periodic(const Duration(seconds: 1), (timer){ setState(()=>sec++); if(sec>=60){ timer.cancel(); setState(()=>rec=false); }}); }
  @override void dispose(){ t?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Create - 1 MINT 9:16', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black), body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
      AspectRatio(aspectRatio: 9/16, child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.purple, width: 2), borderRadius: BorderRadius.circular(12)), child: Stack(children: [Center(child: Icon(rec? Icons.circle: Icons.videocam, color: Colors.red, size: 80)), Positioned(bottom: 8, right: 8, child: Container(color: Colors.black54, padding: const EdgeInsets.all(4), child: const Text('KOLNE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))), Positioned(top: 8, left: 8, child: Container(color: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Text(rec? 'REC $sec/60':'9:16 | 1 MINT', style: const TextStyle(color: Colors.white, fontSize: 12))))]))),
      const SizedBox(height: 16), Text('$sec Sec / 60 Sec - Auto Stop 1 Mint', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),
      Row(children: [Expanded(child: ElevatedButton(onPressed: (){ if(!rec) start(); else { t?.cancel(); setState(()=>rec=false); } }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text(rec? 'STOP':'START SELF VIDEO'))), const SizedBox(width: 8), Expanded(child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple), child: const Text('AI VIDEO'))), const SizedBox(width: 8), Expanded(child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(backgroundColor: Colors.white10), child: const Text('GALLERY')))]),
      const SizedBox(height: 20),
      TextField(controller: musicCtrl, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Music - Instagram jaise User lagayega', labelStyle: const TextStyle(color: Colors.white54), prefixIcon: const Icon(Icons.music_note, color: Colors.purple), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      const SizedBox(height: 12),
      TextField(controller: hashCtrl, style: const TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Hashtags - Instagram jaise User lagayega', labelStyle: const TextStyle(color: Colors.white54), prefixIcon: const Icon(Icons.tag, color: Colors.purple), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
      const SizedBox(height: 20), SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.all(16)), onPressed: (){}, child: const Text('POST - 9:16 Feed me Jayega', style: TextStyle(color: Colors.white))))
    ])));
  }
}

class InboxScreen extends StatelessWidget { const InboxScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Inbox - Mutual Follow Only', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black), body: const Center(child: Text('Mutual Follow pe hi Message', style: TextStyle(color: Colors.white54)))); } }
class ProfileScreen extends StatelessWidget { const ProfileScreen({super.key}); @override Widget build(BuildContext context){ return Scaffold(appBar: AppBar(title: const Text('Profile - My 9:16 Videos', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black), body: Column(children: [const SizedBox(height: 20), const CircleAvatar(radius: 40, backgroundColor: Colors.purple, child: Icon(Icons.person, size: 40, color: Colors.white)), const SizedBox(height: 10), const Text('@my_real_id - 1 ID Verified', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), const Text('REAL | CLEAN | SAFE', style: TextStyle(color: Colors.white54)), const SizedBox(height: 20), Expanded(child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 9/16), itemCount: 9, itemBuilder: (_, i)=> Container(margin: const EdgeInsets.all(2), color: Colors.grey[900], child: Center(child: Text('9:16\n1 MINT\n$i', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54))))))])) ; } }
