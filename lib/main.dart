import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
void main() async {
WidgetsFlutterBinding.ensureInitialized();
final cams = await availableCameras();
runApp(KolneApp(cameras: cams));
}
class KolneApp extends StatelessWidget {
final List<CameraDescription> cameras;
const KolneApp({super.key, required this.cameras});
@override
Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: HomeScreen(cameras: cameras));
}
class HomeScreen extends StatefulWidget {
final List<CameraDescription> cameras;
const HomeScreen({super.key, required this.cameras});
@override
State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
late CameraController _controller;
final _recorder = AudioRecorder();
bool _isRec = false, _ready = false;
@override
void initState() { super.initState(); _init(); }
Future<void> _init() async {
_controller = CameraController(widget.cameras[0], ResolutionPreset.high);
await _controller.initialize();
if (mounted) setState(() => _ready = true);
}
Future<void> _start() async {
if (await _recorder.hasPermission()) {
final dir = await getTemporaryDirectory();
final path = '${dir.path}/kolne.m4a';
await _recorder.start(const RecordConfig(), path: path);
setState(() => _isRec = true);
}
}
Future<void> _stop() async {
await _recorder.stop();
setState(() => _isRec = false);
}
@override
void dispose() { _controller.dispose(); _recorder.dispose(); super.dispose(); }
@override
Widget build(BuildContext context) {
return Scaffold(appBar: AppBar(title: const Text('KOLNE')), body: _ready? Stack(children: [CameraPreview(_controller), Positioned(bottom: 30, left: 0, right: 0, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [FloatingActionButton(onPressed: () async { await _controller.takePicture(); }, child: const Icon(Icons.camera_alt)), FloatingActionButton(backgroundColor: _isRec? Colors.red:Colors.blue, onPressed: _isRec? _stop:_start, child: Icon(_isRec? Icons.stop:Icons.mic)), FloatingActionButton(onPressed: () async { await ImagePicker().pickVideo(source: ImageSource.gallery); }, child: const Icon(Icons.video_library)),]))]) : const Center(child: CircularProgressIndicator()));
}
}
