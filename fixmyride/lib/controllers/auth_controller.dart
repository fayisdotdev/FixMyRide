// import 'package:fixmyride/screens/home_page.dart';
// import 'package:fixmyride/screens/login_screen.dart';
// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthController extends GetxController {
//   static AuthController instance = Get.find();
//   late Rx<User?> firebaseUser;

//   @override
//   void onReady() {
//     super.onReady();
//     firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
//     firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
//     ever(firebaseUser, _setInitialScreen);
//   }

//   _setInitialScreen(User? user) {
//     if (user == null) {
//       // user NOT logged in
//       Get.offAll(() => LoginScreen());
//     } else {
//       // user IS logged in
//       Get.offAll(() => HomePage());
//     }
//   }

//   void signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// }
