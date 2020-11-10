import 'package:agora_rtc_engine/rtc_engine.dart' as Rtc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melba/constants.dart';
import 'package:melba/screens/events_screen.dart';
import 'package:melba/screens/feedback_screen.dart';
import 'package:melba/screens/gallery_screen.dart';
import 'package:melba/screens/home_screen.dart';
import 'package:melba/screens/live_stream.dart';
import 'package:melba/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  final User result = FirebaseAuth.instance.currentUser;
  final UserType userType;

  final List<DrawerItems> itemsGuest = [
    DrawerItems(title: 'Home', icon: Icons.home, route: HomeScreen(userType: UserType.guest,)),
    DrawerItems(title: 'Login', icon: Icons.person, route: LoginScreen()),
    DrawerItems(title: 'Events', icon: Icons.schedule, route: EventScreen()),
    DrawerItems(title: 'Sponsors', icon: Icons.star, route: HomeScreen()),
    DrawerItems(title: 'Gallery', icon: Icons.image, route: GalleryScreen(userType: UserType.guest,)),
  ];
  final List<DrawerItems> itemsUser = [
    DrawerItems(title: 'Home', icon: Icons.home, route: HomeScreen(userType: UserType.user,)),
    DrawerItems(title: 'Events', icon: Icons.schedule, route: EventScreen()),
    DrawerItems(title: 'Sponsors', icon: Icons.star, route: HomeScreen()),
    DrawerItems(title: 'Live Streaming', icon: Icons.videocam, route: LiveStream(role: Rtc.ClientRole.Audience, label: 'WATCH LIVE STREAMING',)),
    DrawerItems(title: 'Donation Box', icon: Icons.monetization_on_outlined, route: HomeScreen()),
    DrawerItems(title: 'Feedback', icon: Icons.info_outline, route: FeedbackScreen()),
    DrawerItems(title: 'Gallery', icon: Icons.image, route: GalleryScreen(userType: UserType.user,)),
    DrawerItems(title: 'Logout', icon: Icons.logout, route: HomeScreen()),
  ];
  final List<DrawerItems> itemsAdmin = [
    DrawerItems(title: 'Home', icon: Icons.home, route: HomeScreen(userType: UserType.admin,)),
    DrawerItems(title: 'Admin Panel', icon: Icons.settings, route: HomeScreen()),
    DrawerItems(title: 'Events', icon: Icons.schedule, route: EventScreen()),
    DrawerItems(title: 'Sponsors', icon: Icons.star, route: HomeScreen()),
    DrawerItems(title: 'Live Streaming', icon: Icons.videocam, route: LiveStream(role: Rtc.ClientRole.Broadcaster, label: 'START LIVE STREAMING',)),
    DrawerItems(title: 'Donation Box', icon: Icons.monetization_on_outlined, route: HomeScreen()),
    DrawerItems(title: 'Feedback', icon: Icons.info_outline, route: FeedbackScreen()),
    DrawerItems(title: 'Gallery', icon: Icons.image, route: GalleryScreen(userType: UserType.admin,)),
    DrawerItems(title: 'Logout', icon: Icons.logout, route: HomeScreen()),
  ];

  AppDrawer({Key key, @required this.userType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email;
    if(result != null){
      email = result.email;
    }
    List<DrawerItems> menuItems = [];
    if(userType == UserType.guest){
      menuItems = itemsGuest;
    } else if(userType == UserType.user){
      menuItems = itemsUser;
    } else if(userType == UserType.admin){
      menuItems = itemsAdmin;
    }
    final drawerHeader = Container(
      height: 200,
      width: double.infinity,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff982223), Color(0xffda9d52)],
              stops: [0.1, 0.9],
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/melba_user.png', height: 100, width: 100,),
            SizedBox(height: 20,),
            Text(email ?? 'Welcome Guest', style: TextStyle(color: Colors.white, fontSize: 20),),
          ],
        ),
      ),
    );
    final drawerItems = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        drawerHeader,
        Divider(color: Colors.white, thickness: 2, height: 0,),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: Image.asset('assets/images/menu_bg.jpg').image, fit: BoxFit.cover),
            ),
            child: ListView.separated(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                IconData icon = menuItems[index].icon;
                String title = menuItems[index].title;
                Widget route = menuItems[index].route;
                return ListTile(
                  tileColor: Colors.black38,
                  title: Text(title, style: TextStyle(color: Colors.white),),
                  leading: Icon(icon, color: Color(0xffef4726),),

                  onTap: (){
                    if(title == "Logout"){
                      FirebaseAuth auth = FirebaseAuth.instance;
                      auth.signOut().then((res) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                                (Route<dynamic> route) => false);
                        return;
                      });
                    }
                    title == "Home" ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route)) : Navigator.push(context, MaterialPageRoute(builder: (context) => route));
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(color: Colors.white, thickness: 2, height: 0,),
            ),
          ),
        ),
      ],
    );
    return SafeArea(
      child: Container(
        width: 200,
        child: Drawer(
          child: drawerItems,
        ),
      ),
    );
  }
}

class DrawerItems{
  final IconData icon;
  final String title;
  final Widget route;

  DrawerItems({@required this.icon, @required this.title, @required this.route});

}