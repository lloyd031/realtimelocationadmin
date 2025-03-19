

import 'package:flutter/material.dart';
import 'package:realtimelocation_admin/pages/loading.dart';
import 'package:realtimelocation_admin/services/auth.dart';


class LogIn extends StatefulWidget {
  final Function switchAuth;
  const LogIn({super.key, required this.switchAuth});
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final  auth=AuthService();
 
  final _formKey=GlobalKey<FormState>();
  String error=" ";
  bool loading=false;
  String email="";
  String pw="";
  
  @override
  Widget build(BuildContext context) {
    
    return (loading==true)?Loading() :Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (val){
                  setState(() {
                    email=val;
                  });
                },
                validator: (val)=>val!.isEmpty?"Rquired":null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val){
                  setState(() {
                    pw=val;
                  });
                },
                validator: (val)=>val!.isEmpty?"Rquired":null,
                obscureText: true,
              ),
              SizedBox(height: 16),
              Text(error , style: TextStyle(color: Colors.red),),
              SizedBox(height: 16),
              TextButton(onPressed:(){widget.switchAuth();}, child:Text("Signup instead")),
                SizedBox(height: 16),
              ElevatedButton(
                onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                      setState(() {
                        loading=true;
                      });
                      dynamic result= await auth.signIn(email, pw);
                      if(result==null){
                        setState(() {
                           error="Invalid email or password";
                           loading=false;
                        });
                      }else{}
                  }
                },
                child: Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
