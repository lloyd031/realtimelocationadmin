import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/Ad.dart';

class AdWidget extends StatelessWidget {
  const AdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final adData = Provider.of<AdData>(context);
    return TextButton(onPressed: (){
             // Navigator.push(context, MaterialPageRoute(builder: (context)=>StartPage(widget.uid,ads[i].id,null)));
           },child: Text("${adData.name}"));
  }
}