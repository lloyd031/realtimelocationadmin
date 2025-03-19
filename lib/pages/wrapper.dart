
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/pages/auth/auth_wapper.dart';
import 'package:realtimelocation_admin/pages/home.dart';

class Wrapper extends StatefulWidget {
  
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
 
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserObj?>(context);
    if(user==null)
    {
      return Authenticate();
    }else
    {
      return Home(user.uid);
      
    }
  }
}
