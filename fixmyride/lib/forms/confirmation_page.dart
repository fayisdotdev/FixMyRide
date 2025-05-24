import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmationPage extends StatefulWidget {
  final String formType; // "Emergency" or "Maintenance"
  final Map<String, dynamic> formData;
  final Map<String, dynamic> userData;

  const ConfirmationPage({
    super.key,
    required this.formType,
    required this.formData,
    required this.userData,
  });

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool? isConfirmed; // null = pending, true = approved, false = cancelled
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _showConfirmationDialog();
  }

  Future<void> _showConfirmationDialog() async {
    await Future.delayed(Duration.zero); // Ensures dialog shows after build
    final result = await showDialog<bool>(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Submission"),
            content: const Text(
              "Are you sure you want to submit this request?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes, Submit"),
              ),
            ],
          ),
    );

    setState(() {
      isConfirmed = result;
    });

    if (result == true) {
      _submitToFirestore();
    }
  }

  Future<void> _submitToFirestore() async {
    setState(() => isSubmitting = true);
    final collectionName =
        widget.formType == "Emergency"
            ? "emergency_requests"
            : "maintenance_requests";

    try {
      await FirebaseFirestore.instance.collection(collectionName).add({
        ...widget.formData,
        "userName": widget.userData["name"],
        "userPhone": widget.userData["phone"],
        "userEmail": widget.userData["email"],
        "timestamp": Timestamp.now(),
      });

      setState(() => isSubmitting = false);
    } catch (e) {
      setState(() {
        isConfirmed = false; // treat as cancel/failure
        isSubmitting = false;
      });
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to submit data: $e")));
    }
  }

  List<Widget> buildInfoSection(String title, Map<String, dynamic> data) {
    return [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...data.entries.map(
        (entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                "${entry.key}: ",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Expanded(child: Text(entry.value.toString())),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget icon;
    String statusText;

    if (isConfirmed == null || isSubmitting) {
      icon = const CircularProgressIndicator();
      statusText = "Processing...";
    } else if (isConfirmed == true) {
      icon = const Icon(Icons.check_circle, color: Colors.green, size: 100);
      statusText = "Your request has been successfully submitted!";
    } else {
      icon = const Icon(Icons.cancel, color: Colors.red, size: 100);
      statusText = "Your submission was canceled.";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.formType} Request Status'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              icon,
              const SizedBox(height: 20),
              Text(
                statusText,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ...buildInfoSection("User Information", widget.userData),
              ...buildInfoSection(
                "${widget.formType} Form Details",
                widget.formData,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Go Home"),
              ),
              SizedBox(height: 10),
              Text("You will recieve a mail immediately,\nThank you. (Check on the spam folder too)"),
            ],
          ),
        ),
      ),
    );
  }
}
