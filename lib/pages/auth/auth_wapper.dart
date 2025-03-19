import 'package:flutter/material.dart';
import 'package:realtimelocation_admin/pages/auth/login.dart';
import 'package:realtimelocation_admin/pages/auth/signup.dart';


class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool islogin=true;
    void switchAuth(){
    setState(() {
      islogin=!islogin;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    return (islogin==true)?LogIn(switchAuth: switchAuth,):SignUp(switchAuth: switchAuth,);
  }
}