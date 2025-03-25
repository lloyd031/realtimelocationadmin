import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/models/Ad.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/pages/adlist.dart';
import 'package:realtimelocation_admin/pages/loading.dart';
import 'package:realtimelocation_admin/riderList.dart';
import 'package:realtimelocation_admin/services/database_service.dart';

class AdDetails extends StatefulWidget {
  final String? ad_id;
  const AdDetails({required this.ad_id});

  @override
  State<AdDetails> createState() => _AdDetailsState();
}

class _AdDetailsState extends State<AdDetails> {
  List<String?> riderList=[];
  DatabaseService _db=DatabaseService(userId: "");
    bool loading=false;
  void addRider(String riderid){
    setState(() {
      riderList.add(riderid);
      print(riderList.length);
    });
  }
  void removeRider(String riderid){
    setState(() {
      riderList.remove(riderid);
      print(riderList.length);
    });
  }
   void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,  // Removes the border radius
      ),
      isScrollControlled: true,  // Allows content to take up less or more space based on the content
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
             mainAxisSize: MainAxisSize.min,
            children: [
              StreamProvider<List<RiderModel>?>.value(
                  initialData: List.empty(),
                  value: DatabaseService(userId:"",adId:  widget.ad_id).getRiderList,
                  child:RiderList(addRider:addRider, removeRider: removeRider,ad_id: widget.ad_id,isAssigned: false,)
                  ),
                  TextButton(
                    onPressed: ()async{
                      setState(() {
                        loading=true;
                      });
                      for(String? i in  riderList){
                        await _db.createAssignedAdDoc("${widget.ad_id}","$i");
                        await _db.addAsignedAds("${widget.ad_id}","$i");
                      }
                      setState(() {
                        loading=false;
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Assign ad"),
                  ),
            ],
          )
              
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black,
      ),
      body:(loading==true)?Loading(): StreamProvider<AdData?>.value(
              initialData: AdData(""),
              value: DatabaseService(userId:"",adId:  widget.ad_id).adData,
              child: Column(
                children: [
                  AdWidget(ad_id: widget.ad_id),
                  StreamProvider<List<RiderModel>?>.value(
                  initialData: List.empty(),
                  value: DatabaseService(userId:"",adId:  widget.ad_id).getAssignedRiderList,
                  child:RiderList(addRider:addRider, removeRider: removeRider,ad_id: widget.ad_id,isAssigned: true,)
                  ),
                  TextButton(onPressed: (){_showBottomSheet(context);}, child: Text("Add Riders"))
                ],
              ),
            ),
    );
  }
}