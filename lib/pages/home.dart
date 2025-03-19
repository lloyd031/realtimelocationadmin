import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/Ad.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/pages/adlist.dart';
import 'package:realtimelocation_admin/pages/loading.dart';
import 'package:realtimelocation_admin/pages/page_wrapper.dart';
import 'package:realtimelocation_admin/services/auth.dart';
import 'package:realtimelocation_admin/services/database_service.dart';

class Home extends StatefulWidget {
  final String? userid;
  const Home(this.userid);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenView=1;
  final  auth=AuthService();
  void switchScreen(int screenNumber){
    setState(() {
      screenView=screenNumber;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    bool loading=false;
    return(loading==true)?Loading(): Scaffold(
      appBar:  AppBar(
        leading: Builder( builder: (BuildContext context) { return IconButton(
          onPressed:(){Scaffold.of(context).openDrawer();}, 
          icon: Icon(Icons.menu,color: Colors.blue,size: 25,)); }),
      elevation: 0,
      backgroundColor:Colors.white,
      
      ),
      drawer: Drawer(
        child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                    accountName: Text('Hello'), accountEmail: Text('hello@gmgmg'),
                    currentAccountPicture: CircleAvatar(
                      child: ClipOval(
                        child: Image.network('https://images.pexels.com/photos/1040881/pexels-photo-1040881.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                        width: 90,
                        height:90,
                        fit:BoxFit.cover),
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color:Colors.blue,
                      image: DecorationImage(image: NetworkImage('https://images.pexels.com/photos/323311/pexels-photo-323311.jpeg?auto=compress&cs=tinysrgb&w=400'
                      ),
                      fit:BoxFit.cover,
                      ),
                    ),
                    ),
                ListTile(
                  leading:const Icon(Icons.person),
                  title:const Text('My Profile'),
                  onTap: (){
                    switchScreen(0);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading:const Icon(Icons.add_business_rounded),
                  title:const Text('My Ads'),
                  onTap: (){
                    switchScreen(1);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading:const Icon(Icons.motorcycle),
                  title:const Text('My Rides'),
                  onTap: (){
                    switchScreen(2);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading:const Icon(Icons.upload),
                  title:const Text('Sync Data'),
                  onTap: (){
                    switchScreen(4);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading:const Icon(Icons.star),
                  title:const Text('Rate App'),
                  onTap: (){},
                ),
                ListTile(
                  leading:const Icon(Icons.share),
                  title:const Text('Share'),
                  onTap: (){},
                ),
                
                /**
                 * const Divider(),
                ListTile(
                  leading:const Icon(Icons.notifications),
                  title:const Text('Notifications'),
                  onTap: (){},
                  trailing: ClipOval(
                    child: Container(
                      color:Colors.red,
                      width:20,
                      height:20,
                      child:const Center(
                        child: Text('2',
                        style: TextStyle(fontSize: 12, color: Colors.white),),
                      )
                    ),
                  ),
                ),
                 */
                const Divider(),
                ListTile(
                  leading:const Icon(Icons.exit_to_app),
                  title:const Text('Signout'),
                  onTap: ()async{
                   await auth.signOut();
                  },
                ),
              ],
            ),
      ),
          
      
      body:SafeArea(child:StreamProvider<UserData?>.value(
        value: DatabaseService(userId:widget.userid).userData, 
        initialData: UserData("","",""),
        child: PageWrapper(uid: widget.userid)
        
        ) ),
    );
  }
}
/**
 * 
 */