import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KolneApp());
}

class KolneApp extends StatelessWidget {
  const KolneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOLNE - Short Video App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.deepPurple,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black, elevation: 0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isOtpSent = false;

  void _sendOtp() {
    if (_phoneController.text.length >= 10) {
      setState(() => _isOtpSent = true);
    }
  }

  void _verifyOtp() {
    String enteredOtp = _otpControllers.map((e) => e.text).join();
    if (enteredOtp.length == 6) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 15, height: 15, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Container(width: 15, height: 15, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Container(width: 15, height: 15, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
              ],
            ),
            const SizedBox(height: 15),
            const Text('KOLNE', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 40),
            if (!_isOtpSent) ...[
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(counterText: "", labelText: 'Mobile Number Login', prefixText: '+91 ', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, minimumSize: const Size.fromHeight(50)),
                child: const Text('Get OTP Verification Box'),
              ),
            ] else ...[
              const Text('Enter 6-Digit Secret Pin', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: "", border: OutlineInputBorder()),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size.fromHeight(50)),
                child: const Text('Verify & Secure Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const HomeFeedScreen(),
    const SearchScreen(),
    const CameraScreen(),
    const ChatScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, size: 28), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32, color: Colors.deepPurpleAccent), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.mode_comment_outlined, size: 28), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined, size: 28), label: 'Settings'),
        ],
      ),
    );
  }
}

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});
  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final TextEditingController _aiTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                color: Colors.black87,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("“Tum badle toh majboori thi... \nHum badle toh bewafa ho gaye?”", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white90)),
                      SizedBox(height: 20),
                      Chip(avatar: Icon(Icons.music_note), label: Text('🔊 Lofi Playing...'))
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 60, left: 16, right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(child: TextField(controller: _aiTextController, decoration: const InputDecoration(hintText: "AI Engine: Prompt -> Video...", border: InputBorder.none, hintStyle: TextStyle(color: Colors.white30)))),
                      IconButton(icon: const Icon(Icons.auto_awesome), onPressed: () {})
                    ],
                  ),
                ),
              ),
              const Positioned(bottom: 30, right: 20, child: Text('KOLNE WATERMARK', style: TextStyle(color: Colors.white24, fontSize: 16, fontWeight: FontWeight.bold))),
            ],
          ),
        );
      },
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _tags = ['#TrendingSadSayri', '#LofiVibesOnly', '#AIVideoCreation'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TextField(decoration: InputDecoration(hintText: 'Search hashtags...', border: InputBorder.none))),
      body: ListView.builder(
        itemCount: _tags.length,
        itemBuilder: (context, index) => ListTile(leading: const Icon(Icons.tag), title: Text(_tags[index])),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final int _timer = 60;
  final bool _rec = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Icon(Icons.videocam_outlined, size: 80, color: Colors.white24)),
          Positioned(top: 60, left: 0, right: 0, child: Center(child: Text("00:$_timer", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))),
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
