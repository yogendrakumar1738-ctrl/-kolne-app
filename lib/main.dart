import 'dart:async';
import 'package:flutter/material.dart';

void main() { runApp(const KolneApp()); }

class KolneApp extends StatelessWidget {
  const KolneApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOLNE',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const LoginScreen(),
    );
  }
}

// 1. NUMBER LOGIN + OTP 6 BOX - NO FACE
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController();
  final otpCtrls = List.generate(6, (_) => TextEditingController());
  bool otpSent = false;
  // 2. 1 Number = 1 ID Logic
  final String oneDeviceId = "ONE_ID_PER_NUMBER";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 10. 3 Rang Logo
              const LogoWidget(),
              const SizedBox(height: 30),
              if (!otpSent)...[
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Mobile Number", hintStyle: TextStyle(color: Colors.white54),
                    filled: true, fillColor: Colors.white10,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6A00)),
                  onPressed: () => setState(() => otpSent = true),
                  child: const Text("SEND OTP - 1 Number = 1 ID"),
                )
              ] else...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (i) => SizedBox(
                    width: 45,
                    child: TextField(
                      controller: otpCtrls[i],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: "", filled: true, fillColor: Colors.white10),
                    ),
                  )),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNav())),
                  child: const Text("VERIFY & ENTER KOLNE"),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFFFF6A00), shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF00C6FF), shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF7B61FF), shape: BoxShape.circle)),
        const SizedBox(width: 10),
        const Text("KOLNE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28, letterSpacing: 3)),
      ],
    );
  }
}

// 10. 5 BUTTON NAV
class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int idx = 0;
  final screens = [const FeedScreen(), const SearchScreen(), const CreateScreen(), const ChatScreen(), const SettingsScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[idx],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, selectedItemColor: const Color(0xFFFF6A00), unselectedItemColor: Colors.white54,
        currentIndex: idx, type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 40), label: "Create"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// 3,4,5,6,7 FEED + CREATE LOGIC
class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});
  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int sec = 0; Timer? t; bool isRec = false;
  String mode = "Normal"; String musicType = "Auto";
  int freeVideos = 0; // 11. Paywall Logic

  void startRec() {
    if (freeVideos >= 2) { showPaywall(); return; }
    setState(() { isRec = true; sec = 0; });
    t = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sec >= 60) { stopRec(); } else { setState(() => sec++); } // 3. 60 Sec Auto Stop
    });
  }
  void stopRec() { t?.cancel(); setState(() { isRec = false; freeVideos++; }); }
  void showPaywall() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text("PAYWALL - Rs 199 = 30 Video"),
      content: const Text("2 Free khatam! Ab Rs 199 do, 30 video banao."),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("PAY Rs 199"))],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const LogoWidget()),
      body: Column(
        children: [
          // 3. Timer
          Text("$sec / 60 Sec", style: const TextStyle(color: Colors.white, fontSize: 24)),
          // 5,6,7 Modes
          Wrap(spacing: 8, children: [
            ChoiceChip(label: const Text("AI Video"), selected: mode=="AI", onSelected: (_) => setState(() => mode="AI")), // Text -> BG + Voice
            ChoiceChip(label: const Text("Sayri Lofi"), selected: mode=="Sayri", onSelected: (_) => setState(() => mode="Sayri")), // 6. Sad BG + Lofi
            ChoiceChip(label: const Text("Music Auto"), selected: musicType=="Auto", onSelected: (_) => setState(() => musicType="Auto")),
            ChoiceChip(label: const Text("Phone"), selected: musicType=="Phone", onSelected: (_) => setState(() => musicType="Phone")),
            ChoiceChip(label: const Text("Trending"), selected: musicType=="Trending", onSelected: (_) => setState(() => musicType="Trending")),
          ]),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(width: 200, height: 350, color: Colors.white10, child: const Icon(Icons.videocam, size: 80, color: Colors.white30)),
              // 10. WATERMARK
              const Positioned(bottom: 10, right: 10, child: Text("KOLNE", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))),
              // EXTRA: Asleel Warning
              if (isRec) const Positioned(top: 10, child: Text("Asleel pe Warning System ON", style: TextStyle(color: Colors.red, fontSize: 10))),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: isRec? Colors.red : const Color(0xFFFF6A00), padding: const EdgeInsets.all(24), shape: const CircleBorder()),
            onPressed: isRec? stopRec : startRec,
            child: Icon(isRec? Icons.stop : Icons.videocam),
          ),
          const Text("Self Video 60 Sec + Gallery 60 Sec Cut + Hashtag + AI BG/Voice", style: TextStyle(color: Colors.white38, fontSize: 10), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// 8. HASHTAG SEARCH + 9. SETTINGS
class FeedScreen extends StatelessWidget { const FeedScreen({super.key}); @override Widget build(BuildContext context) { return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text("Family Video Feed - #Hashtag Search se ayega", style: TextStyle(color: Colors.white)))); } }
class SearchScreen extends StatelessWidget { const SearchScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: const Text("#Hashtag Search")), body: const Center(child: Text("Hashtag - Search me milega", style: TextStyle(color: Colors.white)))); } }
class ChatScreen extends StatelessWidget { const ChatScreen({super.key}); @override Widget build(BuildContext context) { return const Scaffold(backgroundColor: Colors.black, body: Center(child: Text("Mutual Follow pe hi Message - EXTRA", style: TextStyle(color: Colors.white)))); } }
class SettingsScreen extends StatelessWidget { const SettingsScreen({super.key}); @override Widget build(BuildContext context) { return Scaffold(backgroundColor: Colors.black, appBar: AppBar(title: const Text("Settings")), body: ListView(children: const [ListTile(title: Text("Logout", style: TextStyle(color: Colors.white))), ListTile(title: Text("Delete Account", style: TextStyle(color: Colors.white))), ListTile(title: Text("Terms & Privacy", style: TextStyle(color: Colors.white)))])); } }
