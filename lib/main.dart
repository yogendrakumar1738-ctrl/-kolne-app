import 'package:flutter/material.dart';

void main() => runApp(KolneApp());

class KolneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: LoginScreen(),
    );
  }
}

// LOGIN SCREEN - KOLNE
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("KOLNE 🍃", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, foregroundColor: Colors.black),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen())),
              child: Text("Login / Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}

// MAIN SCREEN - 5 BUTTON + HIDE ON SCROLL
class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool showBottomBar = true;
  int selectedIndex = 0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels > 100) {
        if (showBottomBar) setState(() => showBottomBar = false);
      } else {
        if (!showBottomBar) setState(() => showBottomBar = true);
      }
    });
  }

  Widget buildFeed() {
    return ListView.builder(
      controller: scrollController,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 600,
          color: Colors.grey[900],
          margin: EdgeInsets.only(bottom: 2),
          child: Stack(
            children: [
              Center(child: Text("Video ${index + 1} - Kolne", style: TextStyle(fontSize: 22))),
              Positioned(
                right: 10,
                bottom: 80,
                child: Column(
                  children: [
                    IconButton(icon: Icon(Icons.favorite, color: Colors.white, size: 35), onPressed: () {}),
                    IconButton(icon: Icon(Icons.download, color: Colors.white), onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloaded with Kolne watermark")));
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [buildFeed(), Center(child: Text("Search")), Center(child: Text("Inbox")), Center(child: Text("Profile"))];

    return Scaffold(
      body: selectedIndex == 0 || selectedIndex >= 2? pages[selectedIndex == 0? 0 : selectedIndex -1] : pages[0],
      floatingActionButton: showBottomBar? FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () => showModalBottomSheet(context: context, builder: (_) => Container(
          height: 200,
          color: Colors.black,
          child: Column(
            children: [
              ListTile(title: Text("SELF FREE", style: TextStyle(color: Colors.greenAccent)), onTap: () => Navigator.pop(context)),
              ListTile(title: Text("AI LOCKED 🔒", style: TextStyle(color: Colors.grey)), onTap: () {}),
            ],
          ),
        )),
        child: Icon(Icons.add, color: Colors.black, size: 30),
      ) : null,
      bottomNavigationBar: AnimatedOpacity(
        opacity: showBottomBar? 1 : 0,
        duration: Duration(milliseconds: 300),
        child: showBottomBar? BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: (i) => setState(() => selectedIndex = i),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: "Create"),
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "Inbox"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ) : SizedBox.shrink(),
      ),
    );
  }
}
