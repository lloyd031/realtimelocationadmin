import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/services/database_service.dart';

class RiderList extends StatelessWidget {
  final Function? addRiderToList;
  final Function? removeRiderFromList;
  const RiderList({super.key, required this.addRiderToList, required this.removeRiderFromList});

  @override
  Widget build(BuildContext context) {
    final riderList = Provider.of<List<RiderModel>?>(context);
    return Column(
      children: [
        for(int i=0; i<riderList!.length; i++)
        StreamProvider<RiderModel?>.value(
        value: DatabaseService(userId:"", riderId: riderList[i].id).riderData, 
        initialData: RiderModel("","",""),
        child:RiderWidget(addRiderToList:addRiderToList,removeRiderFromList: removeRiderFromList,)
        
        ),
      ],
    );
  }
}

class RiderWidget extends StatefulWidget {
  final Function? addRiderToList;
  final Function? removeRiderFromList;
  const RiderWidget({super.key, required this.addRiderToList, required this.removeRiderFromList});

  @override
  State<RiderWidget> createState() => _RiderWidgetState();
}

class _RiderWidgetState extends State<RiderWidget> {
  bool selected=false;
  @override
  Widget build(BuildContext context) {
    final rider = Provider.of<RiderModel?>(context);
    return TextButton(
      
      onPressed: (){
        if(selected==false){
          widget.addRiderToList!(rider);
        }else{
          widget.removeRiderFromList!(rider);
        }
        setState(() {
          selected=!selected;
        });
        
      },
      child: Text(" ${rider!.fn} ${rider.ln}", style: TextStyle(color: (selected==true)?Colors.green:Colors.black),));
  }
}