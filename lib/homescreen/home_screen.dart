import 'package:fishcab_system_admin/homescreen/register_sellers.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Widget tab(String title, Color color, EdgeInsets padding) {
    return Container(
      width: 200,
      child: Padding(
        padding: padding,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: color
          ),),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // create a navigation rail
          NavigationRail(
            useIndicator: false,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            leading: Container(
              width: 200,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
                child: Text(
                    'Fishcab Admin',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
              ),
            ),
            destinations: <NavigationRailDestination>
            [
              // navigation destinations
              NavigationRailDestination(
                icon: tab('Add seller', Colors.black, const EdgeInsets.symmetric(horizontal: 15.0)),
                selectedIcon: tab('Add seller', Colors.blue, const EdgeInsets.symmetric(horizontal: 15.0)),
                label: const SizedBox.shrink(),
              ),
              NavigationRailDestination(
                icon: tab('Manage users', Colors.black, const EdgeInsets.symmetric(horizontal: 15.0)),
                selectedIcon: tab('Manage users', Colors.blue, const EdgeInsets.symmetric(horizontal: 15.0)),
                label: const SizedBox.shrink(),
              ),
            ],

          ),
          const VerticalDivider(thickness: 1, width: 2),
          Expanded(
            child: buildPages(),
          )
        ],
      ),
    );
  }

  Widget buildPages() {
    switch(_selectedIndex) {
      case 0:
        return const RegisterSellerView();
      default:
        return MyHomePage(title: 'huh');
    }
  }
}

