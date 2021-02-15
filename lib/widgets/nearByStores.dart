import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:restaurants_app/constants.dart';
import 'package:restaurants_app/providers/locationProvider.dart';
import '../services/storeService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/storeProvider.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class NearByStores extends StatefulWidget {
  @override
  _NearByStoresState createState() => _NearByStoresState();
}

class _NearByStoresState extends State<NearByStores> {
  StoreService _storeService = StoreService();
  PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    final _location = Provider.of<LocationProvider>(context);

    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('vendors').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShot) {
            if (!snapShot.hasData)
              return Padding(
                padding: EdgeInsets.all(15),
                child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Colors.deepOrangeAccent)),
              );
//            List shopDistance = [];
//            for (int i = 0; i <= snapShot.data.docs.length; i++) {
//              var dist = Geolocator.distanceBetween(
//                  _storeData.userLatitude,
//                  _storeData.userLongitude,
//                  snapShot.data.docs[i]['location'].latitude,
//                  snapShot.data.docs[i]['location'].longitude);
//              var distanceInKm = dist / 1000;
//              shopDistance.add(distanceInKm);
//            }
//            shopDistance.sort();
//            if (shopDistance[0] >= 10) {
//              return Container();
//            }
            final List<DocumentSnapshot> documents = snapShot.data.docs;
            return Expanded(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
//                    var dist = Geolocator.distanceBetween(
//                        _storeData.userLatitude,
//                        _storeData.userLongitude,
//                        documents[index]['location'].latitude,
//                        documents[index]['location'].longitude);
//                    if (dist < 10) {
//                      return Card(
//                        child: ListTile(
//                          title: Text(documents[index]['shopName']),
//                        ),
//                      );
//                    }
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 180,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20)),
                                child: Image.network(documents[index]['url'])),
                            Container(
                              width: 10,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    documents[index]['shopName'],
                                    style: kNearByCardText,
                                  ),
                                  documents[index]['isTopPicked']
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              CupertinoIcons.star,
                                              size: 12,
                                              color: Colors.green,
                                            ),
                                            Text(
                                              ' Verified',
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        )
                                      : null,
                                  SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 80,
                                    child: Text(
                                      documents[index]['address'],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.phone_solid,
                                        color: Colors.deepOrange,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '+91 ${documents[index]['mobile']}',
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapShot.data.docs.length,
                ),
              ),
            );
          }),
    );
  }
}
