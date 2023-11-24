import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<List<DataRow>> getRowData() async{
    List<dynamic> list = await model.getList();

    List<DataRow> rows = <DataRow>[];

    for (var d in list) {
      DataRow dataRow = DataRow(cells: <DataCell>[
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


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: controller.getRowData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
          if( snapshot.connectionState == ConnectionState.waiting){
            return  Center(child: Text('Please wait its loading...'));
          }else{
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else {
              List<DataRow> rows = snapshot.data;
              return DataTable(
                  columns: const <DataColumn> [
                    DataColumn(label: Text('First Name')),
                    DataColumn(label: Text('Last Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Type')),
                  ],
                  rows: rows);
            }// snapshot.data  :- get your object which is pass from your downloadData() function
          }
        },);
  }


}
