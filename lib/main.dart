import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() { runApp(const KolneApp()); }

class KolneApp extends StatelessWidget {
  const KolneApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kolne - Real Bharat',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final screens = [const HomeFeed(), const SearchScreen(), const CameraScreen(), const EarnScreen(), const ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 35), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.currency_rupee), label: 'Earn'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// 1. HOME FEED - Mindful Timer + Share
class HomeFeed extends StatelessWidget {
  const HomeFeed({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kolne - No Filter Zone'), actions: [Chip(label: Text('Timer: 30m'), avatar: Icon(Icons.timer, size: 18))]),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          if (index % 10 == 9) return Card(child: ListTile(title: Text('Ad - Clutter Free (10 pe 1 Ad)'), subtitle: Text('Premium lo - 99rs Ad-Free'))); // Point 6
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(child: Text('U$index')),
              title: Text('Real Video #$index #bharat #real'),
              subtitle: Text('Music: Bhojpuri Beat - Organic Reach 2x (No Filter)'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border)),
                IconButton(onPressed: (){ Share.share('Dekho Kolne pe Real Video #real - Download: kolne.app.link'); }, icon: const Icon(Icons.share)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Search - Strict Verification')), body: const Center(child: Text('Point 5: Bot & Spam Control - OTP Verified Users Only\nHashtag: #kolne #real #bharat')));
  }
}

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Post - Music + Hashtag')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const TextField(decoration: InputDecoration(labelText: 'Caption likho...')),
          const SizedBox(height: 10),
          const TextField(decoration: InputDecoration(labelText: 'Hashtags #real #kolne #bharat')),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(value: 'No Music', items: const [DropdownMenuItem(value: 'No Music', child: Text('No Music')), DropdownMenuItem(value: 'Bhojpuri Beat', child: Text('Bhojpuri Beat')), DropdownMenuItem(value: 'Haryanvi Bass', child: Text('Haryanvi Bass'))], onChanged: (v){}, decoration: const InputDecoration(labelText: 'Music Select Karo')),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: (){ ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post Done! Feed me chala gaya'))); }, child: const Text('Post Karo - 1 Min Real'))
        ]),
      ),
    );
  }
}

class EarnScreen extends StatelessWidget {
  const EarnScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Earn - Fair Earnings')), body: const Center(child: Text('Point 4: 60% Ad Earning Creator Ko\n+ 5rs / 10rs Micro-Tipping\nWallet Balance: 0 rs')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Settings - Privacy First')), body: ListView(children: const [
      ListTile(title: Text('Point 1: Zero AI Data Training'), trailing: Icon(Icons.shield), subtitle: Text('One-Click Opt-Out: ON')),
      ListTile(title: Text('Point 2: Mindful Scrolling'), subtitle: Text('30 min ke baad Break Reminder')),
      ListTile(title: Text('Point 6: Ad-Free Premium'), subtitle: Text('99rs / Month - Zero Ads')),
      ListTile(title: Text('Point 5: Bot Control'), subtitle: Text('Strict Verification ON')),
    ]));
  }
}
