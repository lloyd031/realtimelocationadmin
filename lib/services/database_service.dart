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
  DatabaseService({required this.userId, this.adId});
 

  Future storeDetails(String fn, String ln,)async{
     return await riderCollection.doc(userId).set({
      'fn':fn,
      'ln':ln,
      'acc_type':'admin'
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
    
    return AdData(snapshot.get("name"),);
  }
 
  
  Future createAd(String name)async{
     return await adCollection.doc(userId).set({
      'name':name,
     });
  }
  
  }
  