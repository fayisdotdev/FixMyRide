// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ConfirmationPage extends StatelessWidget {
//   final String formType;
//   final Map<String, String> formData;
//   final Map<String, String> userData;

//   const ConfirmationPage({
//     super.key,
//     required this.formType,
//     required this.formData,
//     required this.userData,
//   });

//   Future<void> _submitToFirestore() async {
//     try {
//       // Prepare combined data to save
//       final dataToSave = <String, dynamic>{
//         'formType': formType,
//         'formData': formData,
//         'userData': userData,
//         'timestamp': FieldValue.serverTimestamp(),
//         'status': 'pending', // Optional: track status
//       };

//       // Choose collection name based on form type (optional)
//       String collectionName = formType.toLowerCase() == 'emergency'
//           ? 'emergency_requests'
//           : 'maintenance_requests';

//       await FirebaseFirestore.instance.collection(collectionName).add(dataToSave);

//       Get.snackbar("Success", "Your $formType request has been submitted!");
//     } catch (e) {
//       Get.snackbar("Error", "Failed to submit request: $e");
//       throw e; // Rethrow if needed
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("$formType Confirmation")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text(
//               "Please review your $formType request details:",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             // Display form fields dynamically
//             ...formData.entries.map((entry) => ListTile(
//                   title: Text(entry.key),
//                   subtitle: Text(entry.value),
//                 )),

//             const Divider(height: 32),

//             Text(
//               "User Information:",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             ...userData.entries.map((entry) => ListTile(
//                   title: Text(entry.key),
//                   subtitle: Text(entry.value),
//                 )),

//             const SizedBox(height: 30),

//             ElevatedButton(
//               onPressed: () async {
//                 // Disable button or show loading in production for better UX

//                 try {
//                   await _submitToFirestore();

//                   // After successful submission, go back or to a success screen
//                   Get.back(); // or Get.offAllNamed('/home');
//                 } catch (_) {
//                   // Error snackbar already shown inside _submitToFirestore
//                 }
//               },
//               child: Text("Confirm and Submit"),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 textStyle: const TextStyle(fontSize: 18),
//               ),
//             ),
//             const SizedBox(height: 12),

//             TextButton(
//               onPressed: () {
//                 Get.back(); // Go back to edit form
//               },
//               child: const Text("Edit Details"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
