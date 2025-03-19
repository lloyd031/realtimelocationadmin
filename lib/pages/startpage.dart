import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:realtimelocation_admin/models/rides_model.dart';
import 'package:realtimelocation_admin/pages/loading.dart';

class StartPage extends StatefulWidget {
  final String? rid;
  final String? ad_id;
  final List<RidesModel>? trailmark;
  StartPage(this.rid,this.ad_id, this.trailmark);
  
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
      @override
      void initState() {
        
        super.initState();
      }
   
    

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
    //start - all about geolocator and google map

    //offline db
    final _myBox=Hive.box('riderBox');
    //write
    Future writeData() async{
      for(int i=0; i<points.length; i++){
        DateTime now = DateTime.now();
        String dateFormat=now.month.toString() +"-"+now.day.toString()+"-"+now.year.toString();
        String timestamp=now.hour.toString() +"-"+now.minute.toString()+"-"+now.second.toString()+"-"+now.millisecond.toString();
        await _myBox.put("$dateFormat$timestamp",[widget.rid, widget.ad_id, points[i].latitude, points[i].longitude, timestamp,dateFormat]);
        
      }
      setState(() {
        readData();
      });
    }
    
    //read
    void readData(){
      keys=[];
      for(int i=0; i<_myBox.length; i++){
        final _key=_myBox.getAt(i);
        if(_key[0]==widget.rid && _key[1]==widget.ad_id ){
          keys.add(_key);
        }
        
      }
    }
    
    //timer
    int _seconds = 00;
    int _mins = 00;
    int _hours = 00; // The timer count
  late Timer _timer; // Timer object
  void _starTimer() {
    _timer = Timer.periodic(Duration(seconds: 1 ), (timer) {
      setState(() {
        if(_seconds==59){
          _seconds=0;
          if(_mins==59){
            _mins=0;
            _hours++;
          }else{
            _mins++;
          }
        }else{
          _seconds++;
        }
      });
    });
    
  }
  String _twoDigitFormat(int number) {
    return number.toString().padLeft(2, '0');
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
  Widget build(BuildContext context) {
    
    //start still related to geolocator and google map
    
    //end still related to geolocator and google map.
     
    return WillPopScope(
      onWillPop: ()async{ 
        return false;
       },
      child:(loading==true)?Loading(): Scaffold(
        appBar:  AppBar(
          title: Text("${widget.ad_id}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),),
          automaticallyImplyLeading: false,
          elevation: 1,
          shadowColor: Colors.black,
          backgroundColor:Colors.white,
          actions: <Widget>[
          TextButton(onPressed: ()async{
                 if(keyframe<=widget.trailmark!.length){
                  Timer _animate;
                  _animate= Timer.periodic(Duration(seconds: 1 ), (timer) {
                    setState(() {
                        keyframe++;
                        lat = widget.trailmark![keyframe].lat;
                        long = widget.trailmark![keyframe].long;
                        addPolyline();
                        _goToLocation();
                        if(isTimerRun==false){
                          isTimerRun=true;
                          _starTimer();
                        }

                    });
                  });
                  }
                
                
                }, child: Text((runOnBackground==false)?"START":"STOP", style: TextStyle(color:(runOnBackground==false)?Colors.green[700]:Colors.red[700]),)),
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
                          Icon(Icons.timer_outlined,color:(runOnBackground==false)? Colors.red:Colors.green,),
                          SizedBox(width: 8,),
                          Text("Location change", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),)
                        ],
                      ),
                      Text("${_twoDigitFormat(_hours)}:${_twoDigitFormat(_mins)}:${_twoDigitFormat(_seconds)}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color:(runOnBackground==false)? Colors.black54:Colors.black),)
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