
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDataFetch extends StatefulWidget {
  const FirebaseDataFetch({super.key});
  @override
  State<StatefulWidget> createState() {
    return _FirebaseDataFetchState();
  }
}

class _FirebaseDataFetchState extends State<FirebaseDataFetch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Data Fetch")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      // backgroundColor: Colors
                      //     .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Text(
                        snapshot.data!.docs[index]['name']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase(),
                      ),
                    ),
                    title: Text(snapshot.data!.docs[index]['name']),
                    subtitle: Text(
                      snapshot.data!.docs[index]['number'].toString(),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.hasError.toString()));
            } else {
              return Center(child: Text("No Data Found"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
