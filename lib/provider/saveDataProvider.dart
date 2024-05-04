import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../Model/FavListDataModel.dart';

class SaveDataProvider with ChangeNotifier {
  var auth = FirebaseAuth.instance.currentUser;

  saveToFav(id, url, photoGrapherName, photoGrapherId, photoGrapherUrl) async {
    var set = FirebaseFirestore.instance
        .collection('PixelVibe')
        .doc('UserImages')
        .collection(auth!.uid.toString())
        .doc(id.toString())
        .set({
      'images': url,
      'photoGrapherName': photoGrapherName,
      'photoGrapherId': photoGrapherId,
      'photoGrapherUrl': photoGrapherUrl,
      'favBool': true,
      'id': id.toString(),
    });
  }

  // Getting WishList Data
  List<FavListDataModel> favListDataList = [];
  void getFavListData() async {
    List<FavListDataModel> newList = [];
    QuerySnapshot favData = await FirebaseFirestore.instance
        .collection('PixelVibe')
        .doc('UserImages')
        .collection(auth!.uid.toString())
        .get();
    favData.docs.forEach((element) {
      FavListDataModel favModel = FavListDataModel(
        name: element.get('photoGrapherName'),
        images: element.get('images'),
        photoGrapherid: element.get('photoGrapherId'),
        url: element.get('photoGrapherUrl'),
        favBool: element.get('favBool'),
        id: element.get('id'),
      );
      newList.add(favModel);
    });
    favListDataList = newList;
    notifyListeners();
  }

  List<FavListDataModel> get getFavList {
    return favListDataList;
  }

  delete(id) {
    FirebaseFirestore.instance
        .collection('PixelVibe')
        .doc('UserImages')
        .collection(auth!.uid.toString())
        .doc(id)
        .delete();
  }
}
