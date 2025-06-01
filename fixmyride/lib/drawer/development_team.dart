import 'package:flutter/material.dart';

class DevelopmentTeam extends StatelessWidget {
  const DevelopmentTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Development Team"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: const [
            SectionTitle(title: "Developer"),
            SectionContent(content: "Muhammad Fayis K M"),

            SizedBox(height: 20),

            SectionTitle(title: "Vision"),
            SectionContent(content:
              "An all-in-one app for solving vehicle maintenance issues "
              "and providing critical emergency support whenever needed. "
              "We aim to simplify vehicle care through smart service booking and real-time help."
            ),

            SizedBox(height: 20),

            SectionTitle(title: "Mission"),
            SectionContent(content:
              "We are on a mission to build a reliable platform that brings vehicle support "
              "to users' fingertips — from routine services to emergency assistance, "
              "with a seamless and efficient experience."
            ),

            SizedBox(height: 20),

            SectionTitle(title: "Contact"),
            SectionContent(content: "Email: muhammadfayiskm31@gmail.com"),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SectionContent extends StatelessWidget {
  final String content;
  const SectionContent({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        height: 1.4,
      ),
    );
  }
}
