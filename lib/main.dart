class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginState();
}
class _LoginState extends State<LoginScreen> {
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF22C55E), Color(0xFF7C3AED), Color(0xFFFACC15)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110, height: 110,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Center(child: Text("K", style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED)))),
            ),
            SizedBox(height: 15),
            Text("KOLNE", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4)),
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF22C55E)),
                  hintText: "Mobile Number",
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.black38,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFF22C55E), width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Color(0xFFFACC15), width: 2)),
                ),
              ),
            ),
            SizedBox(height: 200),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFACC15), minimumSize: Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () async {
                  await FirebaseAuth.instance.signInAnonymously();
                },
                child: Text("LOGIN / CONTINUE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
