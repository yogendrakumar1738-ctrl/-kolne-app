import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0A1F16)),
      home: MainNav(cameras: cameras),
    );
  }
}

class MainNav extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainNav({super.key, required this.cameras});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _index = 0;
  bool _showBar = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF1B4D3E),
          title: const Text("🌿 Roj +10"),
          content: const Text("Self + AI One Min Ready", style: TextStyle(color: Colors.white70)),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollStartNotification) setState(() => _showBar = false);
          if (n is ScrollEndNotification) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) setState(() => _showBar = true);
            });
          }
          return false;
        },
        child: _index == 0 ? FeedPage(cameras: widget.cameras) : _index == 4 ? const ProfilePage() : const Center(child: Text("Soon", style: TextStyle(color: Colors.white))),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: _showBar ? 70 : 0,
        child: _showBar
            ? BottomNavigationBar(
                backgroundColor: const Color(0xFF0A1F16),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white54,
                currentIndex: _index,
                onTap: (v) {
                  if (v == 2) {
                    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF1B4D3E), builder: (_) => CreateSheet(cameras: widget.cameras));
                  } else {
                    setState(() => _index = v);
                  }
                },
                items: [
                  const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  const BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
                  BottomNavigationBarItem(
                      icon: Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1B4D3E), Color(0xFF6A1B9A)]), shape: BoxShape.circle), child: const Icon(Icons.add, color: Colors.white)), label: ""),
                  const BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Color(0xFF6A1B9A)), label: "Like"),
                  const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Pro"),
                ],
              )
            : const SizedBox(),
      ),
    );
  }
}

class FeedPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const FeedPage({super.key, required this.cameras});
  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<bool> liked = List.generate(20, (_) => false);
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 20,
      itemBuilder: (c, i) {
        return Container(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1F16), Color(0xFF2D1B4E)])),
          child: Stack(children: [
            Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.play_circle, size: 70, color: Colors.white24), Text("Reel ${i + 1} - Self+AI 1Min", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])),
            Positioned(
                right: 10,
                bottom: 30,
                child: Column(children: [
                  InkWell(onTap: () => setState(() => liked[i] = !liked[i]), child: Column(children: [Icon(liked[i] ? Icons.favorite : Icons.favorite_border, color: liked[i] ? Colors.red : Colors.white, size: 34), const Text("Like", style: TextStyle(fontSize: 10, color: Colors.white))])),
                  const SizedBox(height: 18),
                  const Icon(Icons.comment, color: Colors.white, size: 34),
                  const Text("Hide", style: TextStyle(fontSize: 10, color: Colors.white)),
                  const SizedBox(height: 18),
                  const Icon(Icons.share, color: Colors.white, size: 34),
                  const Text("Share", style: TextStyle(fontSize: 10, color: Colors.white)),
                  const SizedBox(height: 18),
                  const Icon(Icons.music_note, color: Color(0xFF00FF9D), size: 34),
                  const Text("Music", style: TextStyle(fontSize: 10, color: Colors.white)),
                ]))
          ]),
        );
      },
    );
  }
}

class CreateSheet extends StatelessWidget {
  final List<CameraDescription> cameras;
  const CreateSheet({super.key, required this.cameras});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("Create Self + AI One Min", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ListTile(leading: const Icon(Icons.videocam, color: Colors.orange), title: const Text("1. Self Vedio - REC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => CameraPage(cameras: cameras))); }),
        ListTile(leading: const Icon(Icons.smart_toy, color: Colors.purpleAccent), title: const Text("2. AI One Min Created", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), onTap: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("AI One Min Creating..."))); }),
        const ListTile(leading: Icon(Icons.photo, color: Colors.blue), title: Text("Photo", style: TextStyle(color: Colors.white))),
        const ListTile(leading: Icon(Icons.text_fields, color: Colors.yellow), title: Text("Shayari", style: TextStyle(color: Colors.white))),
        const ListTile(leading: Icon(Icons.park, color: Colors.green), title: Text("Natural 1-Min", style: TextStyle(color: Colors.white))),
      ]),
    );
  }
}

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _ready = false;
  bool _rec = false;
  @override
  void initState() { super.initState(); _init(); }
  Future<void> _init() async { if (widget.cameras.isEmpty) return; _controller = CameraController(widget.cameras.first, ResolutionPreset.high, enableAudio: true); await _controller!.initialize(); setState(() => _ready = true); }
  Future<void> _toggle() async { if (!_rec) { await _controller!.startVideoRecording(); setState(() => _rec = true); } else { final f = await _controller!.stopVideoRecording(); setState(() => _rec = false); if(mounted){ ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved ${f.path}"))); Navigator.pop(context);} } }
  @override
  void dispose() { _controller?.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) { return Scaffold(appBar: AppBar(title: const Text("Self + AI One Min"), backgroundColor: const Color(0xFF0A1F16)), backgroundColor: Colors.black, body: _ready ? Stack(children: [CameraPreview(_controller!), if (_rec) Positioned(top: 20, left: 20, child: Container(padding: const EdgeInsets.all(6), color: Colors.red, child: const Text("● REC")))]) : const Center(child: Text("Camera Allow", style: TextStyle(color: Colors.white))), floatingActionButton: _ready ? FloatingActionButton.large(backgroundColor: _rec ? Colors.red : Colors.white, onPressed: _toggle, child: Icon(_rec ? Icons.stop : Icons.videocam, color: _rec ? Colors.white : Colors.black)) : null, floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat); }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) { return Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0A1F16), Color(0xFF6A1B9A)])), child: Scaffold(backgroundColor: Colors.transparent, appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.transparent), body: const Center(child: Text("YK ✅ Self + AI 1Min", style: TextStyle(color: Colors.white, fontSize: 18))))); }
}
