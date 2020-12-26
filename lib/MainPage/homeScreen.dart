import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:plutox/PagesMainPage/ChatBot.dart';
import 'package:plutox/PagesMainPage/RecordsController.dart';
import 'package:plutox/PagesMainPage/route.dart';
import 'package:plutox/login/google_signin.dart';
import 'package:plutox/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: RaisedButton(
//           onPressed: () {
//             final provider =
//                 Provider.of<GoogleSignInProvider>(context, listen: false);
//             provider.logout();
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => MyApp()),
//             );
//           },
//           child: Text("Logout"),
//         ),
//       ),
//     );
//   }
// }

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  final user = FirebaseAuth.instance.currentUser;
  PageController _pageController;
  SharedPreferences prefs;
  String id;

  int _Page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    init();
  }

  void init() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "PlutoX",
          style: TextStyle(fontFamily: 'JetBrains', color: Colors.blueAccent),
        ),
        iconTheme: IconThemeData(color: Colors.blueAccent),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL),
                      radius: 50.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(user.email),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text('Settings'),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      body: PageView(
        physics: new NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          RecordsController(),
          Routes(currentUserId: id),
          Chatbot()
        ],
        onPageChanged: (int index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.compare_arrows, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.blueAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 250),
        onTap: (index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
