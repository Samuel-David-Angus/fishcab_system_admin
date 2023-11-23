import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterSellerModel {
  String sellerEmail = "";
  String sellerPassword = "";
  String sellerFname = "";
  String sellerLname = "";
  registerSeller(context) async {
    User? seller;
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: sellerEmail,
        password: sellerPassword).then((result) {
          seller = result.user;
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

    if (seller != null) {
      await FirebaseFirestore.instance.collection("users").doc(seller!.uid).set(
          {
            'email': sellerEmail,
            'firstName': sellerFname,
            'lastName': sellerLname,
            'type': 'seller'
          });
      const snackBar = SnackBar(
        content: Text(
          "Successfully added seller",
          style: TextStyle (
            fontSize: 36,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

class RegisterSellerController {
  final RegisterSellerModel model = RegisterSellerModel();
  registerUser(String fname, String lname, String email, String password, context) {
    model.sellerEmail = email;
    model.sellerPassword = password;
    model.sellerFname = fname;
    model.sellerLname = lname;
    model.registerSeller(context);
  }
}

class RegisterSellerView extends StatefulWidget {
  const RegisterSellerView({super.key});

  @override
  State<RegisterSellerView> createState() => _RegisterSellerViewState();
}

class _RegisterSellerViewState extends State<RegisterSellerView> {
  final RegisterSellerController controller = RegisterSellerController();
  String sellerEmail = "";
  String sellerPassword = "";
  String sellerFname = "";
  String sellerLname = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                sellerEmail = value;
              },
              style: const TextStyle(fontSize: 16, color: Colors.black),
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

              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                sellerPassword = value;
              },
              obscureText: true,
              style: const TextStyle(fontSize: 16, color: Colors.black),
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

              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                sellerFname = value;
              },
              style: const TextStyle(fontSize: 16, color: Colors.black),
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
                hintText: "First name",
                hintStyle: TextStyle(color: Colors.grey),

              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                sellerLname = value;
              },
              style: const TextStyle(fontSize: 16, color: Colors.black),
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
                hintText: "Last name",
                hintStyle: TextStyle(color: Colors.grey),

              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                controller.registerUser(sellerFname, sellerLname, sellerEmail, sellerPassword, context);
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 100, vertical: 20)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.pinkAccent)
              ),
              child: const Text (
                "Register",
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
    );
  }
}

