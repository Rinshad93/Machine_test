
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machine_test/pages/authenticationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;
var name,profileImage;
GoogleSignIn _googleSignIn = new GoogleSignIn();
class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  void initState() {
    setState(() {
      getUser();
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(

        children: <Widget>[
          Center(
            child: GestureDetector(
              child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(

                    gradient: LinearGradient(
                        colors: [Colors.green, Colors.yellow],
                        begin: const FractionalOffset(0.1, 0.0),
                        end: const FractionalOffset(1.9, 0.0),
                        stops: [0.0, 2.0],
                        tileMode: TileMode.clamp
                    ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular((10))),
                  ),
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(90)),
                  child:  CachedNetworkImage(
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: profileImage,

                      errorWidget: (context, url, error) =>
                          Image.asset(
                            'assets/img/avatar_placeholder.png',
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          )
                  ),

                ),
                accountName: Text(
                  name,
                  style: Theme.of(context).textTheme.title,
                ),

              ),

            ),
          ),
          ListTile(
            onTap: () {
              gooleSignout();
            },
            leading:
            Image.asset("assets/img/logout.png",height: 20,width: 20),

            title: Text(
              "Log out",
              style: TextStyle(color: Colors.grey,fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
  Future getUser()
  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      profileImage = prefs.getString('image');
    });

    print("NAme--- $profileImage");
  }
  Future<void> gooleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
      setState(() {
        isSignIn = false;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return AuthenticationPage();
            },
          ),
        );
      });
    });
  }
}
