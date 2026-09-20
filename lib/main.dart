import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(KolneApp(cameras: cameras));
}

class KolneApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const KolneApp({super.key, required this.cameras});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen(cameras: cameras),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const HomeScreen({super.key, required this.cameras});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isShort = true;
  CameraController? _controller;
  List<String> categories = ["All","Natural","Bhakti","Motivational","Knowledge","Fact","Shayari"];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (widget.cameras.isEmpty) return;
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _filterGaali(String text) {
    if (text.toLowerCase().contains("mc") || text.toLowerCase().contains("bc")) {
      return "*** Comment Hidden - Family Safe ***";
    }
    return text;
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 15),
              const Text("Create - 7 Format (Natural)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              ListTile(leading: const Icon(Icons.videocam, color: Colors.orange), title: const Text("1. Self Vedio"), subtitle: const Text("Camera se Direct - Instagram jaisa"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CameraPage(controller: _controller!)))),
              ListTile(leading: const Icon(Icons.smart_toy, color: Colors.purple), title: const Text("2. AI Vedio Creat"), subtitle: const Text("1 Min Natural Vedio - AI se")),
              ListTile(leading: const Icon(Icons.photo, color: Colors.blue), title: const Text("3. Photo Post"), subtitle: const Text("Single / Multiple Photos")),
              ListTile(leading: const Icon(Icons.text_fields, color: Colors.yellow), title: const Text("4. Shayari / Text Thought")),
              ListTile(leading: const Icon(Icons.park, color: Colors.green), title: const Text("5. Natural 1-Min Vedio"), subtitle: const Text("Nature + Life")),
              ListTile(leading: const Icon(Icons.mic, color: Colors.red), title: const Text("6. Audio / Podcast")),
              ListTile(leading: const Icon(Icons.live_tv, color: Colors.pink), title: const Text("7. Live - Family Safe"), subtitle: const Text("Gaali Filter ON + Face Verify")),
              const SizedBox(height: 10),
              const Text("Features: Like, Comment (Hide), Share, Music, Self Message (Mutual)", style: TextStyle(fontSize: 10, color: Colors.white38), textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[900],
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isShort? "Short Reel ${index+1}" : "Long Reel ${index+1}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          Text(isShort? "Natural - 15-60 sec" : "Natural - 2-5 min", style: const TextStyle(color: Colors.white54)),
                          const SizedBox(height: 20),
                          Container(color: Colors.black54, padding: const EdgeInsets.all(8), child: Text(_filterGaali(index % 2 == 0? "mast natural vedio" : "nice mc"), style: const TextStyle(color: Colors.white70, fontSize: 12))),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 12, bottom: 130,
                      child: Column(
                        children: const [
                          Icon(Icons.favorite, size: 32), Text("Like", style: TextStyle(fontSize: 10)),
                          SizedBox(height: 18),
                          Icon(Icons.comment, size: 32), Text("Hide", style: TextStyle(fontSize: 10, color: Colors.green)),
                          SizedBox(height: 18),
                          Icon(Icons.share, size: 32),
                          SizedBox(height: 18),
                          Icon(Icons.music_note, size: 32), Text("Music", style: TextStyle(fontSize: 10)),
                          SizedBox(height: 18),
                          Icon(Icons.message, size: 32), Text("Chat\nMutual", style: TextStyle(fontSize: 8), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            top: 50, left: 10, right: 10,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(label: const Text("Short"), selected: isShort, onSelected: (v) => setState(() => isShort = true)),
                    const SizedBox(width: 10),
                    ChoiceChip(label: const Text("Long"), selected:!isShort, onSelected: (v) => setState(() => isShort = false)),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: categories.map((e) => Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)), child: Text(e, style: const TextStyle(fontSize: 12)))).toList()),
                ),
              ],
            ),
          ),
          Positioned(top: 48, right: 14, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)), child: const Text("Face Verify: 1 Mobile = 1 ID", style: TextStyle(fontSize: 8)))),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _openCreateSheet, backgroundColor: Colors.white, child: const Icon(Icons.add, color: Colors.black, size: 32)),
    );
  }
}

class CameraPage extends StatelessWidget {
  final CameraController controller;
  const CameraPage({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Self Vedio - Natural"), backgroundColor: Colors.black),
      backgroundColor: Colors.black,
      body: CameraPreview(controller),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.camera_alt)),
    );
  }
}
