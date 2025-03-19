import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/Ad.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/pages/adlist.dart';
import 'package:realtimelocation_admin/riderList.dart';
import 'package:realtimelocation_admin/services/database_service.dart';

class PageWrapper extends StatefulWidget {
  final String? uid;
  const PageWrapper({required this.uid});

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  
  int screenView=1;
  
   
  @override
  Widget build(BuildContext context) {
   
    
    
    final userData = Provider.of<UserData?>(context);
    return (userData!.acc_type!="admin")?Text("Unatorized account"):
    StreamProvider<List<Ad_Model>>.value(
            value: DatabaseService(userId:widget.uid).getAd, 
            initialData: List.empty(),
            child:(screenView==0)?Text("My Profile")
            :(screenView==2)?Ad_List(widget.uid)
            :Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Ad_List(widget.uid,),
            
            
            ],
          ) ,);
  }
}