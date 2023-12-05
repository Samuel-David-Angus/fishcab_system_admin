import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageUsersModel {

  Future<List<dynamic>> getList() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users").get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }
}

class ManageUsersController {
  ManageUsersModel model = ManageUsersModel();

  Future<List<DataRow>> getRowData(context) async{
    List<dynamic> list = await model.getList();

    List<DataRow> rows = <DataRow>[];

    for (var d in list) {
      DataRow dataRow = DataRow(
          onSelectChanged: (bool? selected) {
            showDialog(context: context,
                builder: (BuildContext b) {
                  return Expanded(
                      child: SimpleDialog(
                        title:const Text('Actions'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () async {
                              await FirebaseAuth.instance.sendPasswordResetEmail(email: d['email']);
                            },
                            child:const Text('Reset password'),
                          ),

                        ],
                      ),);
                }
            );
          },
          cells: <DataCell>[
        DataCell(Text(d['firstName'])),
        DataCell(Text(d['lastName'])),
        DataCell(Text(d['email'])),
        DataCell(Text(d['type'])),
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
            return  Center(child: Text('Please wait its loading...'));
          }else{
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              rows = snapshot.data;
              return DataTable(
                showCheckboxColumn: false,
                sortAscending: isAscending,
                  sortColumnIndex: sortColumnIndex,
                  columns: <DataColumn> [
                    DataColumn(
                        label: Text('First Name'),
                        onSort: onSort),
                    DataColumn(
                        label: Text('Last Name'),
                        onSort: onSort),

                    DataColumn(
                        label: Text('Email'),
                        onSort: onSort),
                    DataColumn(
                        label: Text('Type'),
                        onSort: onSort),
                  ],
                  rows: rows);
            }// snapshot.data  :- get your object which is pass from your downloadData() function
          }
        },);
  }


}
