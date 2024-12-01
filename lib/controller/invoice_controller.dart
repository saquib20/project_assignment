import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:project_assignment/screens/invoicepage.dart';
import 'package:intl/intl.dart';

class InvoiceController extends GetxController {
  var invoiceNumber = 'INV-2024-001'.obs;
  var customerName = 'ANOSH SOFTWARE'.obs;
  var customerAddress = '123 Business Street, City, State 12345'.obs;
  var itemDetails = 'ITEM DETAILS'.obs;
  var termsCondition = 'Terms & Conditions:'.obs;
  var paymentTerms =
      'Payment is due within 30days\nPlease include invoice in payments\nAll prices are in USD'
          .obs;
  var showDigitalSignature = true.obs;
  var emailID = 'ksaquib982@gmail.com'.obs;
  var website = 'www.saquibkhan.com'.obs;

  var items = <InvoiceItem>[
    InvoiceItem(description: 'Widget Type A', quantity: 5, unitPrice: 300.0),
    InvoiceItem(
        description: 'Service Package B', quantity: 2, unitPrice: 450.0),
    InvoiceItem(description: 'Consultation', quantity: 3, unitPrice: 450.0),
  ].obs;

  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.total);

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    final String currentDate =
        DateFormat('MMM dd, yyyy').format(DateTime.now());
    final isLargeScreen = PdfPageFormat.a4.width > 500;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: isLargeScreen ? 40 : 32,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('Invoice #: ${invoiceNumber.value}',
                        style: pw.TextStyle(fontSize: isLargeScreen ? 18 : 16)),
                    pw.Text('Date: $currentDate'),
                  ]),
              pw.SizedBox(height: 10),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(' ${customerName.value}',
                      style: pw.TextStyle(fontSize: isLargeScreen ? 18 : 16)),
                  pw.Text('Address: ${customerAddress.value}',
                      style: pw.TextStyle(fontSize: isLargeScreen ? 18 : 16)),
                  pw.Text('$emailID'),
                  pw.Text('$website'),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    '$itemDetails',
                    style: pw.TextStyle(
                      fontSize: isLargeScreen ? 24 : 20,
                    ),
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Description', 'Quantity', 'Unit Price', 'Total'],
                data: items
                    .map((item) => [
                          item.description,
                          item.quantity.toString(),
                          '\$${item.unitPrice.toStringAsFixed(2)}',
                          '\$${item.total.toStringAsFixed(2)}',
                        ])
                    .toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: isLargeScreen ? 14 : 12,
                ),
                cellStyle: pw.TextStyle(
                  fontSize: isLargeScreen ? 12 : 10,
                ),
                cellAlignment: pw.Alignment.center,
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: \$${totalAmount.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: isLargeScreen ? 20 : 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(
                height: 50,
              ),
              if (showDigitalSignature == true)
                pw.Positioned(
                  bottom: 30,
                  right: 0,
                  child: pw.Column(
                    children: [
                      pw.Container(
                        width: 200,
                        height: 1,
                        color: PdfColors.black,
                      ),
                      pw.Text('Digital Signature'),
                    ],
                  ),
                ),
              pw.SizedBox(height: 150),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Text(
                      '$termsCondition',
                      style: pw.TextStyle(
                        fontSize: isLargeScreen ? 18 : 16,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                '$paymentTerms',
                style: pw.TextStyle(
                  fontSize: isLargeScreen ? 16 : 14,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void printPdf() async {
    final pdfData = await generatePdf();
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  InvoiceItem(
      {required this.description,
      required this.quantity,
      required this.unitPrice});

  double get total => quantity * unitPrice;
}

final List<InvoiceTemplate> templates = [
  InvoiceTemplate(name: 'Template 1', previewAsset: 'assets/template1.png'),
  InvoiceTemplate(name: 'Template 2', previewAsset: 'assets/template2.png'),
  InvoiceTemplate(name: 'Template 3', previewAsset: 'assets/template3.png'),
  InvoiceTemplate(name: 'Template 4', previewAsset: 'assets/template4.png'),
  InvoiceTemplate(name: 'Template 5', previewAsset: 'assets/template5.png'),
];

class InvoiceTemplate {
  final String name;
  final String previewAsset;

  InvoiceTemplate({
    required this.name,
    required this.previewAsset,
  });
}

String selectedTemplate = 'Template 1';
String printSize = 'A4';
bool showValues = true;
bool showDigitalSignature = true;
Orientation pageOrientation = Orientation.portrait;

final List<InvoiceItem> items = [
  InvoiceItem(
    description: 'Widget Type A',
    quantity: 5,
    unitPrice: 300.0,
  ),
  InvoiceItem(
    description: 'Service Package B',
    quantity: 2,
    unitPrice: 550.0,
  ),
  InvoiceItem(
    description: 'Consultation',
    quantity: 3,
    unitPrice: 450.0,
  ),
];
