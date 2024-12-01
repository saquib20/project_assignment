import 'package:flutter/material.dart';
import 'package:project_assignment/screens/invoicepage.dart';

class Printscreen extends StatefulWidget {
  const Printscreen({super.key});

  @override
  State<Printscreen> createState() => _PrintscreenState();
}

class _PrintscreenState extends State<Printscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Print Preview",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: FloatingActionButton.extended(
          label: const Text('Print Preview'),
          backgroundColor: Colors.blue,
          icon: const Icon(
            Icons.print,
            size: 24.0,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const InvoicePage()));
          },
        ),
      ),
    );
  }
}
