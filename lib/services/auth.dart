import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:realtimelocation_admin/models/User.dart';
import 'package:realtimelocation_admin/services/database_service.dart';

class AuthService {
  
  //databse crud
  final _auth=FirebaseAuth.instance;
  
  //create rider model
  UserObj? _UserFromFirebase(User? user)
  {
    
    return user!=null?UserObj(user.uid):null;
  }
  //listen to authentication changes
  Stream<UserObj?> get user{
    return _auth.authStateChanges().map(_UserFromFirebase);
  }
  //authentication
  
  //signup with email and password
   Future signUp(String email, String pw) async
   {
      // ignore: unrelated_type_equality_checks
      
        try{
          UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: pw);
          User? user=result.user;
          DatabaseService _db= DatabaseService(userId: user!.uid);
          await _db.storeDetails("John", "Cruz");
          //create a document for the user with uid in firebase
          //await DatabaseService(user?.uid,user?.email,null).updateUserData(fn, ln, profile,accType);
          return _UserFromFirebase(user);
      }catch(e)
      {
          print(e.toString());
          return null;
      }
      
   }
 Future signIn(String email, String password) async
   {
      // ignore: unrelated_type_equality_checks
      
        try{
          UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
          User? user=result.user;
          return _UserFromFirebase(user);
      }catch(e)
      {
          return null;
      }
      
   }

   //signout
  Future signOut() async
    { 
      try
      {
          return await _auth.signOut();
      }catch(e)
      {
          print(e.toString());
          return null;
      }
    }

}