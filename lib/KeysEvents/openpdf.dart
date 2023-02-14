import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OpenPdf extends StatefulWidget {
  const OpenPdf({super.key});

  @override
  State<OpenPdf> createState() => _OpenPdfState();
}

class _OpenPdfState extends State<OpenPdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pdf Viewer'),
        backgroundColor: blue,
      ),
      body: SfPdfViewer.asset('assets/Jammu_Smart_City_Limited.pdf'),
    );
  }
}
