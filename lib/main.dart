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
      theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: Colors.black),
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
  int _index = 0;
  bool _showBottom = true;
  final _pages = [const FeedPage(), const SearchPage(), const Center(child: Text("Create", style: TextStyle(color: Colors.white))), const Center(child: Text("Inbox", style: TextStyle(color: Colors.white))), const Center(child: Text("Profile", style: TextStyle(color: Colors.white)))];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollUpdateNotification) {
            if (n.scrollDelta! > 0 && _showBottom) setState(()=>_showBottom=false);
            if (n.scrollDelta! < 0 && !_showBottom) setState(()=>_showBottom=true);
          }
          return true;
        },
        child: _pages[_index],
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _showBottom ? 70 : 0,
        child: _showBottom ? BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _index,
          onTap: (i)=>setState(()=>_index=i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 32), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ) : const SizedBox(),
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
      itemBuilder: (c, i
