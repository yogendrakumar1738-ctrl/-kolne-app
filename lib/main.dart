import 'package:flutter/material.dart';

void main() {
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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const FeedPage(),
      const SearchPage(),
      const CreatePage(),
      const InboxPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.black,
          child: Stack(
            children: [
              Center(
                child: Text('KOLNE Video ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              const Positioned(bottom: 30, left: 15, child: Text('@yogendra • Bharat Ka App', style: TextStyle(color: Colors.white))),
              const Positioned(
                bottom: 30,
                right: 15,
                child: Column(
                  children: [
                    Icon(Icons.favorite, color: Colors.white, size: 30),
                    SizedBox(height: 15),
                    Icon(Icons.comment, color: Colors.white),
                    SizedBox(height: 15),
                    Icon(Icons.share, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Search Page', style: TextStyle(color: Colors.white, fontSize: 22)));
  }
}

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Create +', style: TextStyle(color: Colors.white, fontSize: 30)));
  }
}

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Inbox', style: TextStyle(color: Colors.white, fontSize: 22)));
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Profile', style: TextStyle(color: Colors.white, fontSize: 22)));
  }
}
