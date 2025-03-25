import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realtimelocation_admin/models/rides_model.dart';

class StartPage extends StatefulWidget {

  final List<RidesModel>? trailmark;
  StartPage(this.trailmark);
  
  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
        int keyframe=-1; // used to view riders trialmark history
        bool isTimerRun=false; // used to make sure that timer only start once
        Set<Polyline> _poly={};
        List<LatLng> points=[];
        bool loading=false;
        List<dynamic> keys=[];
        //start - all about geolocator and google map
        bool runOnBackground=false;
        late double lat;
        late double long;
      
      
     
   
    

    final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

      static const CameraPosition _duma = CameraPosition(
      target: LatLng(9.3068, 123.3054),
      zoom: 14.4746,);

      Future<void> _goToLocation() async {
       GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long),
        zoom: 16)));
      
    }
    
    
    
    
  String _twoDigitFormat(int number) {
    return number.toString().padLeft(2, '0');
  }

    void back(){
      setState(() {
          runOnBackground=false;
          });
      Navigator.pop(context);
    }
  void addPolyline(){
      setState(() {
        points.add(LatLng(lat, long));
      _poly.clear();
      _poly.add(Polyline(polylineId: PolylineId("id"),
      points: points,
      width: 8,
      color: Colors.deepOrange));
      });
    }
    @override
  void initState() {
    // TODO: implement initState
    
    for(int i=0; i<widget.trailmark!.length; i++){
                    setState(() {
                        keyframe++;
                        lat = widget.trailmark![keyframe].lat;
                        long = widget.trailmark![keyframe].long;
                        addPolyline();
                       

                    });
                  }
                  _goToLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  
    //end still related to geolocator and google map.
     
    return WillPopScope(
      onWillPop: ()async{ 
        return false;
       },
      child: Scaffold(
        appBar:  AppBar(
          title: Text("", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),
          automaticallyImplyLeading: false,
          elevation: 1,
          shadowColor: Colors.black,
          backgroundColor:Colors.white,
          actions: <Widget>[
         if(runOnBackground==false)
          TextButton(onPressed: ()async{
                 Navigator.pop(context); 
          }, child: Text("BACK", style: TextStyle(color:Colors.red[700]),))
        ],
          
      ),
        body: SafeArea(child: 
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            
            Expanded(
              flex: 1,
              child: GoogleMap(
                polylines: _poly,
                mapType: MapType.terrain,
                onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                
              },
                initialCameraPosition: _duma,
                markers:(!_controller.isCompleted)?{}:{Marker(
                  position: LatLng(lat, long),
                  markerId: MarkerId('1'),),
                },
                ),
            ),
            /**
             * Container(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    for(int i=0; i<keys.length; i++)
                    Text("${keys[i][1]} - ${keys[i][2]} - ${keys[i][3]}")
                  ],
                ),
              ),
            ),
             */
            Container(
              padding: EdgeInsets.all(8),
              height: 45, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Colors.white, // White color for the container
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(1), // Shadow color
                    spreadRadius: 2, // Spread radius of the shadow
                    blurRadius: 4, // Blur radius for the shadow
                    offset: Offset(0, 4), // Shadow position (top shadow)
                  ),
                ],
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.map,color:Colors.green,),
                          SizedBox(width: 8,),
                          Text("Distance Traveled ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),)
                        ],
                      ),
                      Text("${widget.trailmark!.length*50} Km", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color:Colors.black),)
                    ],
                ),
            ),
      
            
          ],
        )
        ),
      ),
    );
  }
}