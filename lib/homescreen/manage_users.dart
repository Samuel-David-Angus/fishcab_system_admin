import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishcab_system_admin/reviews/see_reviews.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageUsersModel {

  Future<List<dynamic>> getList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users").get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }
  Future<String> getUID(String email) async {
    String uid = "";
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      value.docs.forEach((element) {uid = element.id;});
    });
    return uid;
  }

  Future<String> getToken(String uid) async {
    String token = "";
    await FirebaseFirestore.instance.collection('tokens').doc(uid).get()
        .then((value) => {token = value['token']});
    return token;
  }

  updateStatus(String status, String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update(
        {
          'status': status
        });
  }
}

class ManageUsersController {
  ManageUsersModel model = ManageUsersModel();

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA0t4TDS0:APA91bH2R9XarRRw_e1-UYYnmFvX1FrFGBc7AWAT6u5MVJH5V2NIn5LmoFb70h2UqmW5oluK4A_63xsZV3t74U5KDCNd-WlhAe1kLgUukUjwWg8FgTzKGF6AnbuHpfW_6hKJJB-nw0Nb',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  displayDialog(context, Widget widget) {
    showDialog(context: context,
        builder: (BuildContext context) {
          return Container(child: widget);
        });
  }

    updateUser(String status, String uid, context) async {
      await model.updateStatus(status, uid).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Notice'),
              content: Text('Account status has been $status.'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('confirm'),
                ),
              ],
            );
          },
        );
      });
    }

  Future<List<DataRow>> getRowData(context) async{
    List<dynamic> list = await model.getList();

    List<DataRow> rows = <DataRow>[];
    String message = "";


    for (var d in list) {
      if (d['status'] == null) {
        d['status'] = "not set";
      }
      DataRow dataRow = DataRow(
          onSelectChanged: (bool? selected) {
            displayDialog(
                context,
                SimpleDialog(
                  title:const Text('Actions'),
                  children: <Widget>[
                    SimpleDialogOption(
                      onPressed: () async {
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: d['email']);
                      },
                      child:const Text('Reset Password'),
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        Navigator.pop(context);
                        displayDialog(
                            context,
                            AlertDialog(
                              title: const Text("Send Notification Message"),
                              content: TextField(
                                onChanged: (value){
                                  message = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: "Type message here"
                                ),

                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Send'),
                                  onPressed: () async {
                                    String uid = await model.getUID(d['email']);
                                    String token = await model.getToken(uid);
                                    Navigator.of(context).pop();
                                    sendPushMessage(message, "Message from admin", token);
                                  },
                                ),
                              ],
                            ));
                      },
                      child:const Text('Send Notification Message'),
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        String uid = await model.getUID(d['email']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewReviewView(reviewee: uid)),
                        );
                      },
                      child:const Text('See Reviews'),
                    ),
                    SimpleDialogOption(
                      onPressed: () async {
                        Navigator.pop(context);
                        displayDialog(
                            context,
                            AlertDialog(
                              title: const Text("Update User Account Status"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Enable'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    String uid = await model.getUID(d['email']);
                                    updateUser('enabled', uid, context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('Disable'),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    String uid = await model.getUID(d['email']);
                                    updateUser('disabled', uid, context);
                                  },
                                ),
                              ],
                            ));
                      },
                      child:const Text('Update User Account Status'),
                    ),
                  ],
                ));
          },
          cells: <DataCell>[
        DataCell(Text(d['firstName'])),
        DataCell(Text(d['lastName'])),
        DataCell(Text(d['email'])),
        DataCell(Text(d['type'])),
        DataCell(Text(d['status'])),
      ]);
      rows.add(dataRow);
    }

    return rows;
  }
}

class ManageUsersView extends StatefulWidget {
  const ManageUsersView({super.key});

  @override
  State<ManageUsersView> createState() => _ManageUsersViewState();
}

class _ManageUsersViewState extends State<ManageUsersView> {
  ManageUsersController controller = ManageUsersController();
  late final Future<List<DataRow>> raw_rows = controller.getRowData(context);
  int? sortColumnIndex;
  bool isAscending = false;
  List<DataRow> rows = <DataRow>[];


  void onSort(int columnIndex, bool ascending) {
    rows.sort((r1, r2) {
      String t1 = (r1.cells[columnIndex].child as Text).data!.toLowerCase();
      String t2 = (r2.cells[columnIndex].child as Text).data!.toLowerCase();
      return ascending ? t1.compareTo(t2) : t2.compareTo(t1);
    } );
    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;

    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: raw_rows,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
          if( snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: Text('Please wait its loading...'));
          }else{
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              rows = snapshot.data;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  showCheckboxColumn: false,
                  sortAscending: isAscending,
                    sortColumnIndex: sortColumnIndex,
                    columns: <DataColumn> [
                      DataColumn(
                          label: const Text('First Name'),
                          onSort: onSort),
                      DataColumn(
                          label: const Text('Last Name'),
                          onSort: onSort),

                      DataColumn(
                          label: const Text('Email'),
                          onSort: onSort),
                      DataColumn(
                          label: const Text('Type'),
                          onSort: onSort),
                      DataColumn(
                          label: const Text('Status'),
                          onSort: onSort),

                    ],
                    rows: rows),
              );
            }// snapshot.data  :- get your object which is pass from your downloadData() function
          }
        },);
  }


}
