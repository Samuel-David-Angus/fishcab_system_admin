import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fishcab_system_admin/home_screen.dart';
import 'package:flutter/material.dart';

class AdminLoginModel {
  //fields
  String? adminEmail;
  String? adminPassword;

  //getters
  String? getAdminEmail() => adminEmail;
  String? getAdminPassword() => adminPassword;

  //setters
  void setAdminEmail(String adminEmail) {
    this.adminEmail = adminEmail;
  }
  void setAdminPassword(String adminPassword) {
    this.adminPassword = adminPassword;
  }
}

class AdminLoginController {

}

class AdminLoginView extends StatefulWidget {
  const AdminLoginView({super.key});

  @override
  State<AdminLoginView> createState() => _AdminLoginViewState();
}
class _AdminLoginViewState extends State<AdminLoginView> {
  String adminEmail = "";
  String adminPassword = "";
  allowAdminToLogin() async {
    User? currentAdmin;
    SnackBar snackBar = const SnackBar(
      content: Text(
        "Checking Credentials...",
        style: TextStyle (
          fontSize: 36,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.pinkAccent,
      duration: Duration(seconds: 5),
    );
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword
    ).then((fAuth){
        currentAdmin = fAuth.user;
    }).catchError((onError) {
      final snackBar = SnackBar(
          content: Text(
              "Error occured: $onError",
              style: const TextStyle (
                fontSize: 36,
                color: Colors.black,
              ),
          ),
          backgroundColor: Colors.pinkAccent,
          duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if (currentAdmin != null) {
      await FirebaseFirestore.instance.collection("admins").doc(currentAdmin!.uid).get().then((snap) {
        if (snap.exists) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "hello")));
        } else {
          SnackBar snackBar = const SnackBar(
            content: Text(
              "Invalid credentials..",
              style: TextStyle (
                fontSize: 36,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.pinkAccent,
            duration: Duration(seconds: 5),
          );
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/admin.png"
                  ),
                  //email field
                  TextField(
                    onChanged: (value) {
                      adminEmail = value;
                    },
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 2,
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.amber,
                          width: 2,
                        )
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      icon: Icon(
                        Icons.email,
                        color: Colors.cyan,
                      )
                    ),
                  ),
                  //password field
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (value) {
                      adminPassword = value;
                    },
                    obscureText: true,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent,
                              width: 2,
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber,
                              width: 2,
                            )
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey),
                        icon: Icon(
                          Icons.admin_panel_settings,
                          color: Colors.cyan,
                        )
                    ),
                  ),
                  //login button
                  const SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () {
                      allowAdminToLogin();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent)
                    ),
                    child: const Text (
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}



