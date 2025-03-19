import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/Ad.dart';
import 'package:realtimelocation_admin/models/rides_model.dart';
import 'package:realtimelocation_admin/pages/ad_widget.dart';
import 'package:realtimelocation_admin/pages/locations.dart';
import 'package:realtimelocation_admin/pages/startpage.dart';
import 'package:realtimelocation_admin/services/database_service.dart';


class Ad_List extends StatefulWidget {
  final String? uid;
   Ad_List(this.uid);

  @override
  State<Ad_List> createState() => _Ad_ListState();
}

class _Ad_ListState extends State<Ad_List> {
  
 
  String? selectedAdId="";
  
  @override
  Widget build(BuildContext context) {
    final ads = Provider.of<List<Ad_Model>?>(context);
    
     return Column(
      children: [
        Text("My ads"),
        for(int i=0 ; i<ads!.length; i++)
        Column(
          children: [
            StreamProvider<AdData?>.value(
              initialData: AdData(""),
              value: DatabaseService(userId: widget.uid,adId: ads[i].id).adData,
              child: AdWidget(),
            )
            
          ],
        ),
        
      ],
    );
  }
}