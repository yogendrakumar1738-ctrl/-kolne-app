import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

void main() {
  runApp(const KolneApp());
}

class KolneApp extends StatelessWidget {
  const KolneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KOLNE',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ================= लॉगिन स्क्रीन =================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showOTP = false;
  final phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());

  void _verifyPhone() {
    if (phoneController.text.length >= 10) {
      setState(() => showOTP = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("कृपया सही 10 अंकों का नंबर दर्ज करें")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "KOLNE", 
              style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.purpleAccent, letterSpacing: 2)
            ),
            const SizedBox(height: 10),
            const Text("1 Number = 1 ID Auth System", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 40),
            if (!showOTP) ...[
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "मोबाइल नंबर", 
                  prefixText: "+91 ",
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(double.infinity, 50)),
                onPressed: _verifyPhone,
                child: const Text("OTP प्राप्त करें", style: TextStyle(fontSize: 16)),
              ),
            ] else ...[
              const Text("6-अंकों का OTP दर्ज करें", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _otpControllers[index],
                    textAlign: Center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: const InputDecoration(counterText: "", border: OutlineInputBorder()),
                  ),
                )),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainNavigationLayout()),
                  );
                },
                child: const Text("लॉगिन और वेरीफाई करें", style: TextStyle(fontSize: 16)),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// ================= मुख्य लेआउट (5 Buttons) =================
class MainNavigationLayout extends StatefulWidget {
  const MainNavigationLayout({super.key});

  @override
  State<MainNavigationLayout> createState() => _MainNavigationLayoutState();
}

class _MainNavigationLayoutState extends State<MainNavigationLayout> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const VideoFeedScreen(),         
    const SearchHashtagsScreen(),    
    const VideoUploadScreen(),      
    const AiSayriScreen(),          
    const SettingsScreen(),          
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white54,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.play_circle_fill), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32), label: 'Create'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_motion), label: 'AI & Lofi'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// ================= वीडियो फ़ीड स्क्रीन =================
class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://github.io')
    )..initialize().then((_) {
        setState(() {});
        _controller?.setLooping(true);
        _controller?.play();
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _controller != null && _controller!.value.isInitialized
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                )
              : const Center(child: CircularProgressIndicator(color: Colors.purpleAccent)),
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(5)),
              child: const Text("KOLNE ✨", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= वीडियो अपलोड / क्रिएटर स्क्रीन =================
class VideoUploadScreen extends StatefulWidget {
  const VideoUploadScreen({super.key});

  @override
  State<VideoUploadScreen> createState() => _VideoUploadScreenState();
}

class _VideoUploadScreenState extends State<VideoUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  bool isRecording = false;
  int secondsLeft = 60;
  Timer? _timer;

  void start60SecTimer() {
    setState(() {
      isRecording = true;
      secondsLeft = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() => secondsLeft--);
      } else {
        stopRecording();
      }
    });
  }

  void stopRecording() {
    _timer?.cancel();
    setState(() {
      isRecording = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("60 सेकंड पूरे हुए! वीडियो सेव कर ली गई है।")),
    );
  }

  Future<void> _pickFromGallery() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 60), 
    );
    if (video != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("गैलरी से वीडियो चुनी गई: ${video.name} (Max 60s Cut Applied)")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("वीडियो बनाएं / अपलोड करें")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRecording) ...[
              Text("$secondsLeft सेकंड बचे हैं", style: const TextStyle(fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              IconButton(
                iconSize: 80,
                icon: const Icon(Icons.stop_circle, color: Colors.red),
                onPressed: stopRecording,
              )
            ] else ...[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: const EdgeInsets.all(16)),
                onPressed: start60SecTimer,
                icon: const Icon(Icons.videocam),
                label: const Text("सेल्फ़ वीडियो शुरू करें (60s Timer)"),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
