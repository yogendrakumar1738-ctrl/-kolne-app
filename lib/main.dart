// CameraScreen ke andar video save hone ke baad ye screen ayegi
class PostScreen extends StatefulWidget {
  final String videoPath;
  const PostScreen({super.key, required this.videoPath});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final captionController = TextEditingController();
  final hashtagController = TextEditingController();
  String selectedMusic = "No Music";

  List<String> musics = ["No Music", "Bhojpuri Beat", "Haryanvi Bass", "Pahadi Folk", "LoFi Bharat"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post - Music + Hashtag')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: captionController,
              decoration: const InputDecoration(labelText: 'Caption likho...'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: hashtagController,
              decoration: const InputDecoration(labelText: 'Hashtags #real #kolne #bharat'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedMusic,
              isExpanded: true,
              items: musics.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => selectedMusic = v!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Yaha video + music + hashtag save hoga
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Post Done! Music: $selectedMusic | ${hashtagController.text}'))
                );
                Navigator.pop(context);
              },
              child: const Text('Post Karo - Feed me jayega'),
            )
          ],
        ),
      ),
    );
  }
}
