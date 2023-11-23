import 'package:flutter/material.dart';

class RegisterSellerView extends StatefulWidget {
  const RegisterSellerView({super.key});

  @override
  State<RegisterSellerView> createState() => _RegisterSellerViewState();
}

class _RegisterSellerViewState extends State<RegisterSellerView> {
  String sellerEmail = "";
  String sellerPassword = "";
  String sellerUsername = "";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                sellerEmail = value;
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

              ),
            ),
            TextField(
              onChanged: (value) {
                sellerPassword = value;
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

              ),
            ),
            TextField(
              onChanged: (value) {
                sellerUsername = value;
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
                hintText: "Username",
                hintStyle: TextStyle(color: Colors.grey),

              ),
            ),
            ElevatedButton(
              onPressed: () {

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
    );
  }
}

