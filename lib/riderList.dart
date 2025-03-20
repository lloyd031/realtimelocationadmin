import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/services/database_service.dart';

class RiderList extends StatelessWidget {
  final Function? addRider;
  final Function? removeRider;
  final String? ad_id;
  const RiderList({super.key, required this.addRider, required this.removeRider, required this.ad_id});

  @override
  Widget build(BuildContext context) {
    final riderList = Provider.of<List<RiderModel>?>(context);
    DatabaseService _db=DatabaseService(userId:" ");
    
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          for(int i=0; i<riderList!.length; i++)
          StreamProvider<RiderModel?>.value(
          value: DatabaseService(userId:"", riderId: riderList[i].id).riderData, 
          initialData: RiderModel("","",""),
          child:RiderWidget(addRider:addRider,removeRider: removeRider,)
          
          ),
        ],
      ),
    );
  }
}

class RiderWidget extends StatefulWidget {
  final Function? addRider;
  final Function? removeRider;
  const RiderWidget({super.key, required this.addRider, required this.removeRider});

  @override
  State<RiderWidget> createState() => _RiderWidgetState();
}

class _RiderWidgetState extends State<RiderWidget> {
  bool selected=false;
  @override
  Widget build(BuildContext context) {
    final rider = Provider.of<RiderModel?>(context);
    return Column(
      children: [
        TextButton(
          
          onPressed: (){
            if(selected==false){
              widget.addRider!(rider.id);
            }else{
              widget.removeRider!(rider.id);
            }
            setState(() {
              selected=!selected;
            });
            
          },
          child: Text(" ${rider!.fn} ${rider.ln}", style: TextStyle(color: (selected==true)?Colors.green:Colors.black),)),
      ],
    );
  }
}