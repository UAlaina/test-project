
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:habittracker/models/user_data.dart';
import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/homescreen.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      var snapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email not found")));
        return;
      }

      var userDoc = snapshot.docs.first;
      if (userDoc['password'] == password) {
        //save docId to Provider
        final docId = userDoc.id;
        Provider.of<UserData>(context, listen: false).setDocId(docId);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('docID: ${docId}')),
        // );
        //EXP WARNING: might not init properly
        await DbService().initialize(docId);
        Navigator.pushReplacement(
          context,
          //MaterialPageRoute(builder: (context) => const DashboardPage()),
          MaterialPageRoute(builder: (context) => HomeScreen(
            isDarkMode: false,
            toggleDarkMode: () {
              setState(() {
                // Logic to toggle dark mode
              });
            },
          ),
          ),

        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect password")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error occurred during login")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 40),

                  _buildTextField(_emailController, 'Email'),
                  const SizedBox(height: 16),

                  _buildTextField(_passwordController, 'Password', obscureText: true),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Create a new account',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.blueGrey),
          ),
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }
}











//OLD LOGIN
/*


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:habittracker/models/user_data.dart';
import 'package:habittracker/models/db_service.dart';
import 'package:habittracker/Views/EX_dashboard_page.dart';
import 'package:habittracker/habits/addhabit_page.dart';
import 'package:habittracker/homescreen.dart';
//import 'package:habittracker/views/dashboard_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      var snapshot = await _firestore.collection('users').where('email', isEqualTo: email).get();

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email not found")));
        return;
      }

      var userDoc = snapshot.docs.first;
      if (userDoc['password'] == password) {
        //save docId to Provider
        final docId = userDoc.id;
        Provider.of<UserData>(context, listen: false).setDocId(docId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('docID: ${docId}')),
        );
        //EXP WARNING: might not init properly
        await DbService().initialize(docId);
        Navigator.pushReplacement(
          context,
          //MaterialPageRoute(builder: (context) => const DashboardPage()),
          MaterialPageRoute(builder: (context) => HomeScreen(
            isDarkMode: false,
            toggleDarkMode: () {
              setState(() {
                // Logic to toggle dark mode
              });
            }
          ),
          ),

        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Incorrect password")));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error occurred during login")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('Create a new account'),
            ),
          ],
        ),
      ),
    );
  }
}



// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }
//
// class _AuthWrapperState extends State<AuthWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     print('!EXP2');
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           User? user = snapshot.data;
//           print('!EXP HERE1');
//           if (user != null) {
//             // User is signed in, but now we'll wait for initialization
//             print('!EXP HERE');
//             return FutureBuilder<void>(
//               future: _initializeUserData(context, user),
//               builder: (context, asyncSnapshot) {
//                 if (asyncSnapshot.connectionState == ConnectionState.done) {
//                   // Initialization is complete, now show HomeScreen
//                   return HomeScreen(
//                     isDarkMode: false,
//                     toggleDarkMode: () {
//                       setState(() {
//                         // Logic to toggle dark mode
//                       });
//                     },
//                   );
//                 } else {
//                   // Still initializing, show loading
//                   return Scaffold(
//                     body: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(),
//                           SizedBox(height: 16),
//                           Text("Initializing app data..."),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//               },
//             );
//           } else {
//             // User is not signed in
//             return LoginPage();
//           }
//         }
//
//         // Loading state
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _initializeUserData(BuildContext context, User user) async {
//     final userData = Provider.of<UserData>(context, listen: false);
//
//     // Set user data in provider
//     //Provider.of<UserData>(context, listen: false).setDocId('etsydu');
//     userData.setDocId(user.uid);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('user.uid ${user.uid}')),
//     );
//
//     try {
//       // Initialize DB service with user ID
//       await DbService().initialize(user.uid);
//       // DbService().dbHelper.deleteDB(); //////////////////THIS LINE
//       print('DB service initialized for user: ${user.uid}');
//     } catch (e) {
//       print('Error initializing DB service: $e');
//     }
//   }
//
// }






//
// class AuthWrapper extends StatefulWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   State<AuthWrapper> createState() => _AuthWrapperState();
// }
//
// class _AuthWrapperState extends State<AuthWrapper> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           User? user = snapshot.data;
//
//           if (user != null) {
//             // User is signed in
//             // Initialize user data and DB service
//             _initializeUserData(context, user); //I want this line to run completely
//             return HomeScreen(
//                 isDarkMode: false,
//                 toggleDarkMode: () {
//                   setState(() {
//                     // Logic to toggle dark mode
//                   });
//                 }
//             ); //This should only run when prev line is done
//           } else {
//             // User is not signed in
//             return LoginPage(); // Your login screen
//           }
//         }
//
//         // Loading state
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> _initializeUserData(BuildContext context, User user) async {
//     final userData = Provider.of<UserData>(context, listen: false);
//
//     // Set user data in provider
//     //Provider.of<UserData>(context, listen: false).setDocId('etsydu');
//     userData.setDocId(user.uid);
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('user.uid ${user.uid}')),
//     );
//
//     try {
//       // Initialize DB service with user ID
//       await DbService().initialize(user.uid);
//       // DbService().dbHelper.deleteDB(); //////////////////THIS LINE
//       print('DB service initialized for user: ${user.uid}');
//     } catch (e) {
//       print('Error initializing DB service: $e');
//     }
//   }
//
// }


 */