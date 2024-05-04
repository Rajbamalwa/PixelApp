import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixelsvibe/Views/HomePage.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pix',
                  style: GoogleFonts.alata(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  'elsV',
                  style: GoogleFonts.alata(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700),
                ),
                Text(
                  'ibe',
                  style: GoogleFonts.alata(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                Text(
                  '.',
                  style: GoogleFonts.alata(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade700),
                ),
              ],
            ),
            Text(
              'Unlock the World of Endless Images: Download. Explore. Create.',
              textAlign: TextAlign.center,
              style: GoogleFonts.alata(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            if (isLoading == true) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                      content: Center(child: CircularProgressIndicator()));
                },
              );
            } else {
              return;
            }
            await FirebaseAuth.instance.signInAnonymously().then((value) {
              setState(() {
                isLoading = false;
              });
              Permission.storage.request();
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const HomePage()));
            });
            setState(() {
              isLoading = false;
            });
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Login Anonymously',
                style: GoogleFonts.alata(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
