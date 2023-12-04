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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          // create a navigation rail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            destinations: const <NavigationRailDestination>[
              // navigation destinations
              NavigationRailDestination(
                icon: SizedBox.shrink(),
                label: Text('Wishlist'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person),
                label: Text('Account'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: Text('Cart'),
              ),
            ],
            selectedIconTheme: IconThemeData(color: Colors.white),
            unselectedIconTheme: IconThemeData(color: Colors.black),
          ),
          const VerticalDivider(thickness: 1, width: 2),
          Expanded(
            child: Center(
              child: Text('Page Number: $_selectedIndex'),
            ),
          )
        ],
      ),
    );
  }
}
