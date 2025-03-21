import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realtimelocation_admin/models/Ad.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/models/rides_model.dart';


class DatabaseService {
  //databse crud
  final _db=FirebaseFirestore.instance;
  final CollectionReference riderCollection=FirebaseFirestore.instance.collection("rider");
  final CollectionReference adCollection=FirebaseFirestore.instance.collection("ad");
  final String? userId;
  final String? adId;
  final String? riderId;
  DatabaseService({required this.userId, this.adId, this.riderId});
 

  Future storeDetails(String fn, String ln,)async{
     return await riderCollection.doc(userId).set({
      'fn':fn,
      'ln':ln,
      'acc_type':'admin',
      'ads':[]
     });
  }

  

  //get ad stream
  Stream<List<Ad_Model>> get getAd{
    return adCollection.snapshots().map(_adFromSnapShot);
  }
  List<Ad_Model> _adFromSnapShot(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc){
      
      return Ad_Model(doc.id);
    }).toList();
  }
 Future createAssignedAdDoc(String ad_id, String riderId)async{
     return await riderCollection.doc(riderId).collection("assigned_ads").doc(ad_id).set({
      'status':'inc',
      
     });
  }
Future addAsignedAds(String ad_id, String riderId)async{
     return await riderCollection.doc(riderId).update({
       'ads':FieldValue.arrayUnion([ad_id])
     });
  }
  
  Stream<List<RiderModel>> get getRiderList{
    return riderCollection.snapshots().map(_riderListFromSnapShot);
  }
  List<RiderModel> _riderListFromSnapShot(QuerySnapshot snapshot)
  {
    return snapshot.docs.where((doc){
      List<dynamic> ads = doc['ads'] ?? [];
          
          // Check if the array does not contain the 'favoriteItem'
      bool isAssigned=  !ads.contains(adId);
      String accType = doc['acc_type'] ?? "";

      return isAssigned && accType!='admin';
    } ).map((doc){
      return RiderModel(doc.id,"","");
    }).toList();
  }
  Stream<List<RiderModel>> get getAssignedRiderList{
    return riderCollection.snapshots().map(_riderListPerAdFromSnapShot);
  }
  List<RiderModel> _riderListPerAdFromSnapShot(QuerySnapshot snapshot)
  {
    return snapshot.docs.where((doc){
      List<dynamic> ads = doc['ads'] ?? [];
          
          // Check if the array does not contain the 'favoriteItem'
      bool isAssigned=  ads.contains(adId);
      String accType = doc['acc_type'] ?? "";

      return isAssigned && accType!='admin';
    } ).map((doc){
      return RiderModel(doc.id,"","");
    }).toList();
  }

  

 Stream<RiderModel?> get riderData
  {
      return riderCollection.doc(riderId).snapshots().map(_riderDataFromSnapshot);  
  }
  RiderModel? _riderDataFromSnapshot(DocumentSnapshot snapshot)
  {
    
    return RiderModel(riderId, snapshot.get("fn"),snapshot.get("ln"));
  }

Stream<UserData?> get userData
  {
      return riderCollection.doc(userId).snapshots().map(_userDataFromSnapshot);  
  }
  //
  UserData? _userDataFromSnapshot(DocumentSnapshot snapshot)
  {
    
    return UserData(snapshot.get("fn"), snapshot.get("ln"), snapshot.get("acc_type"));
  }

  Stream<AdData?> get adData
  {
      return adCollection.doc(adId).snapshots().map(_adDataFromSnapshot);  
  }
  //
  AdData? _adDataFromSnapshot(DocumentSnapshot snapshot)
  {
    
    return AdData(snapshot.get("name"));
  }
 
  
  Future createAd(String name)async{
     return await adCollection.doc().set({
      'name':name,
     });
  }

  }
  