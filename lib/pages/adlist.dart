import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtimelocation_admin/ad_details.dart';
import 'package:realtimelocation_admin/models/Ad.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/models/rides_model.dart';
import 'package:realtimelocation_admin/pages/locations.dart';
import 'package:realtimelocation_admin/pages/startpage.dart';
import 'package:realtimelocation_admin/riderList.dart';
import 'package:realtimelocation_admin/services/database_service.dart';


class Ad_List extends StatefulWidget {
  final String? uid;
   Ad_List(this.uid);

  @override
  State<Ad_List> createState() => _Ad_ListState();
}

class _Ad_ListState extends State<Ad_List> {
  

  String error="";
  bool loading=false;
  String adName="";
  final _formKey=GlobalKey<FormState>();
  final TextEditingController adNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DatabaseService _db=DatabaseService(userId: widget.uid);
    List<RiderModel> riderList=[];
    void addRiderToList(RiderModel rider){
    setState(() {
      riderList.add(rider);
      print(riderList.length);
    });
  }
  void removeRiderFromList(RiderModel rider){
    setState(() {
      riderList.remove(rider);
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: adNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val){
                    setState(() {
                      adName=val;
                    });
                  },
                  validator: (val)=>val!.isEmpty?"Rquired":null,
                ),
                
                ElevatedButton(
                  onPressed: ()async{
                    if(_formKey.currentState!.validate()){
                        setState(() {
                          loading=true;
                        });
                        dynamic result= await _db.createAd(adName);
                        
                         adNameController.clear();
                          setState(() {
                             loading=false;
                          });
                       
                    }
                  },
                  child: Text('Create'),
                ),
              
              ],
            ),
          ),
              
        );
      },
    );
  }
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
              child: AdWidget(ad_id: ads[i].id),
            )
            
          ],
        ),
        TextButton(onPressed: (){_showBottomSheet(context);}, child: Text("Create Ad"))
      ],
    );
  }
}
class AdWidget extends StatelessWidget {
  final String? ad_id;
  const AdWidget({required this.ad_id});

  @override
  Widget build(BuildContext context) {
    final adData = Provider.of<AdData>(context);
    return TextButton(onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>AdDetails(ad_id: ad_id)));
           },child: Text("${adData.name}"));
  }
}