import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/models/rides_model.dart';
import 'package:realtimelocation_admin/pages/startpage.dart';
import 'package:realtimelocation_admin/services/database_service.dart';

class RiderList extends StatefulWidget {
  final Function? addRider;
  final bool? isAssigned;
  final Function? removeRider;
  final String? ad_id;
  const RiderList({super.key, required this.addRider, required this.removeRider, required this.ad_id, required this.isAssigned});

  @override
  State<RiderList> createState() => _RiderListState();
}

class _RiderListState extends State<RiderList> {
  String selectedRider="";
  @override
  Widget build(BuildContext context) {
    final riderList = Provider.of<List<RiderModel>?>(context);
    DatabaseService _db=DatabaseService(userId:" ");
    
    void selectRider(String val){
      setState(() {
        selectedRider=val;
      });
      
    }
    return Container(
      width: double.maxFinite,
      child: Column(
        children: [
          for(int i=0; i<riderList!.length; i++)
          Column(
            children: [
              StreamProvider<RiderModel?>.value(
              value: DatabaseService(userId:"", riderId: riderList[i].id).riderData, 
              initialData: RiderModel("","",""),
              child:RiderWidget(addRider:widget.addRider,removeRider: widget.removeRider,isAssigned: widget.isAssigned,selectRider: selectRider,)
              ),
              if(selectedRider==riderList[i].id)
              StreamProvider<List<RidesModel>>.value(
                    value: DatabaseService(riderId:riderList[i].id,adId: widget.ad_id, userId: '').getRides, 
                    initialData: List.empty(),
                    child:RideList())
            ],
          ),
        ],
      ),
    );
  }
}

class RiderWidget extends StatefulWidget {
  final bool? isAssigned;
  final Function? selectRider;
  final Function? addRider;
  final Function? removeRider;
  const RiderWidget({super.key, required this.addRider, required this.removeRider, required this.isAssigned, required this.selectRider});

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
            if(widget.isAssigned==false){
              if(selected==false){
              widget.addRider!(rider.id);
            }else{
              widget.removeRider!(rider.id);
            }
            setState(() {
              selected=!selected;
            });
            }else{
             widget.selectRider!(rider.id);
            }
            
          },
          child: Text(" ${rider!.fn} ${rider.ln}", style: TextStyle(color: (selected==true)?Colors.green:Colors.black),)),
          
      ],
      
    );
  }
}

class RideList extends StatefulWidget {
  const RideList({super.key});

  @override
  State<RideList> createState() => _RideListState();
}

class _RideListState extends State<RideList> {
  @override
  Widget build(BuildContext context) {
    List<String> date=[];
    List<RidesModel> rideLocation=[];
    final rides = Provider.of<List<RidesModel>?>(context);
    if(rides!=null){
      for(RidesModel ride in rides){
        if(!date.contains(ride.createdAt)){
          date.add("${ride.createdAt}");
        }
      }
    }
        
    return Column(
      children: [
        for(int i=0; i<date.length; i++)
        TextButton(
          onPressed: (){
            if(rides!=null){
              for(RidesModel ride in rides){
                if(ride.createdAt==date[i]){
                  rideLocation.add(ride);
                }
              }
              Navigator.push(context, MaterialPageRoute(builder: (context)=>StartPage(rideLocation)));
            }
          },
          child: Text("${date[i]}"),
        )
      ],
    );
  }
}