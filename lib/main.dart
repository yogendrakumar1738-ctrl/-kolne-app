import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const KolneApp());
}

class KolneApp extends StatelessWidget {
  const KolneApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOLNE',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return const MainScreen();
        return const OTPLoginScreen();
      },
    );
  }
}

// 9. OTP LOGIN - 1 Mobile = 1 ID
class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({super.key});
  @override State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}
class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  String _vid = "";
  bool _otpSent = false;
  bool _loading = false;

  void _sendOTP() async {
    setState(()=> _loading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${_phone.text}",
      verificationCompleted: (c) async => await FirebaseAuth.instance.signInWithCredential(c),
      verificationFailed: (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!))),
      codeSent: (id, _) { setState((){ _vid=id; _otpSent=true; _loading=false; }); },
      codeAutoRetrievalTimeout: (id) => _vid=id,
    );
    setState(()=> _loading = false);
  }
  void _verify() async {
    try{
      final cred = PhoneAuthProvider.credential(verificationId: _vid, smsCode: _otp.text);
      await FirebaseAuth.instance.signInWithCredential(cred);
    } catch(e){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Galat OTP: $e"))); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("KOLNE", style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: 4)),
          const SizedBox(height: 10),
          const Text("Bharat Ka Short Video App", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 40),
          TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Mobile Number", prefixText: "+91 ", border: OutlineInputBorder())),
          const SizedBox(height: 15),
          if(_otpSent) TextField(controller: _otp, decoration: const InputDecoration(labelText: "OTP Daliye", border: OutlineInputBorder())),
          const SizedBox(height: 20),
          _loading? const CircularProgressIndicator() : SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _otpSent? _verify : _sendOTP, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black), child: Text(_otpSent? "LOGIN KARO" : "OTP BHEJO"))),
        ]),
      ),
    );
  }
}

// 4. 5 BUTTON HIDE/SHOW LOGIC
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  bool _showBottomBar = true;
  final _pages = [const HomeReelsScreen(), const SearchScreen(), const CreateScreen(), const InboxScreen(), const ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => setState(()=> _showBottomBar =!_showBottomBar),
        child: _pages[_index],
      ),
      bottomNavigationBar: _showBottomBar? BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(()=> _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Dost"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "You"),
        ],
      ) : null,
    );
  }
}

// 3. 9:16 FULL REELS + 5,6,7 FEATURES
class HomeReelsScreen extends StatelessWidget {
  const HomeReelsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('videos').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snap) {
        if(!snap.hasData) return const Center(child: CircularProgressIndicator());
        if(snap.data!.docs.isEmpty){
          return const Center(child: Text("Abhi koi video nahi hai\nPehla video aap banao!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)));
        }
        var videos = snap.data!.docs;
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          itemBuilder: (context, index){
            var v = videos[index];
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(color: Colors.grey[900], child: Center(child: Text(v['title']?? "KOLNE Video", style: const TextStyle(fontSize: 22)))),
                // Watermark 8.
                Positioned(top: 50, right: 15, child: Container(color: Colors.black54, padding: const EdgeInsets.all(4), child: const Text("KOLNE", style: TextStyle(fontWeight: FontWeight.bold)))),
                Positioned(bottom: 100, left: 15, right: 80, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("@${v['user']?? 'kolne_user'}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 5),
                  Text(v['title']?? '', maxLines: 2),
                  const SizedBox(height: 5),
                  Text(v['hashtag']?? '#kolne', style: const TextStyle(color: Colors.cyan)),
                ])),
                // 5,7 - Follow Like Comment Share Real
                Positioned(bottom: 100, right: 10, child: Column(children: [
                  _ActionButton(icon: Icons.favorite, label: "${v['likes']?? '12.4K'}", onTap: ()=> FirebaseFirestore.instance.collection('videos').doc(v.id).update({'likes': FieldValue.increment(1)})),
                  const SizedBox(height: 15),
                  _ActionButton(icon: Icons.comment, label: "${v['comments']?? 842}", onTap: ()=> ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Comment Open Hoga")))),
                  const SizedBox(height: 15),
                  _ActionButton(icon: Icons.share, label: "Share", onTap: (){}),
                  const SizedBox(height: 15),
                  ElevatedButton(onPressed: (){ FirebaseFirestore.instance.collection('follows').add({'to': v['uid'], 'from': FirebaseAuth.instance.currentUser!.uid}); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Followed! Ab Dost Chat ON")) ); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.red, padding: const EdgeInsets.symmetric(horizontal: 12)), child: const Text("+Follow", style: TextStyle(fontSize: 12))),
                ])),
              ],
            );
          },
        );
      },
    );
  }
}
class _ActionButton extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});
  @override Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Column(children: [Icon(icon, size: 32), const SizedBox(height: 3), Text(label, style: const TextStyle(fontSize: 12))]));
}

// 6. DOST + SEARCH
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Dost Dhundo")), body: StreamBuilder(stream: FirebaseFirestore.instance.collection('users').snapshots(), builder: (context, snap){
      if(!snap.hasData) return const Center(child: CircularProgressIndicator());
      return ListView(children: snap.data!.docs.map((d)=> ListTile(title: Text(d['phone']?? 'User'), trailing: ElevatedButton(onPressed: (){}, child: const Text("Follow")))).toList());
    }));
  }
}

// 1,2,10,11 - CREATE SCREEN
class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});
  @override State<CreateScreen> createState() => _CreateScreenState();
}
class _CreateScreenState extends State<CreateScreen> {
  final _title = TextEditingController();
  bool _isPaid = false;

  bool isAshleel(String text){
    List bad = ['gali1', 'xxx', 'sex', 'nude', 'porn'];
    for(var w in bad){ if(text.toLowerCase().contains(w)) return true; }
    return false;
  }

  void _upload(){
    if(isAshleel(_title.text)){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⚠️ Warning: Ashleel Content Block Hai!"))); return; }
    if(_title.text.isEmpty){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title Likho"))); return; }
    FirebaseFirestore.instance.collection('videos').add({
      'title': _title.text,
      'hashtag': _isPaid? '#AI_music #viral' : '#self',
      'user': FirebaseAuth.instance.currentUser!.phoneNumber,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'likes': 0, 'comments': 0,
      'timestamp': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Video Upload Ho Gayi! Home pe dekho")));
    _title.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Banao")),
      body: ListView(padding: const EdgeInsets.all(15), children: [
        ListTile(
          tileColor: _isPaid? null : Colors.white10,
          leading: const Icon(Icons.videocam),
          title: const Text("Self Video (Free)"),
          subtitle: const Text("Music + Hashtag khud lagao - FREE"),
          trailing:!_isPaid? const Icon(Icons.check, color: Colors.green) : null,
          onTap: ()=> setState(()=> _isPaid = false),
        ),
        const SizedBox(height: 10),
        ListTile(
          tileColor: _isPaid? Colors.white10 : null,
          leading: const Icon(Icons.auto_awesome, color: Colors.amber),
          title: const Text("AI Video (Paid Rs 199)"),
          subtitle: const Text("Text se Background + AI Music/Hashtag"),
          trailing: _isPaid? const Icon(Icons.check, color: Colors.green) : ElevatedButton(onPressed: ()=> setState(()=> _isPaid = true), child: const Text("Rs 199 Unlock")),
          onTap: ()=> setState(()=> _isPaid = true),
        ),
        const Divider(height: 30),
        TextField(controller: _title, decoration: InputDecoration(labelText: _isPaid? "AI ke liye Text Likho (e.g. pahad pe dance)" : "Video Title Likho", border: const OutlineInputBorder())),
        const SizedBox(height: 15),
        SizedBox(height: 50, child: ElevatedButton(onPressed: _upload, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black), child: Text(_isPaid? "AI VIDEO BANAO - PAID" : "UPLOAD SELF VIDEO"))),
        const SizedBox(height: 20),
        const Text("Category Lock: Comedy, Bhakti, Dance sab 199 ke peeche lock hai. Payment ke baad khulega.", style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
      ]),
    );
  }
}

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Dost Chat - Real")), body: const Center(child: Text("Jisko Follow Kiya Hai, Usse Yaha Chat Kar Sakte Ho")));
}
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Profile")), body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(FirebaseAuth.instance.currentUser?.phoneNumber?? ''), const SizedBox(height: 10), const Text("Watermark: KOLNE har video pe lagega"), const SizedBox(height: 20), ElevatedButton(onPressed: ()=> FirebaseAuth.instance.signOut(), child: const Text("Logout"))])));
}
