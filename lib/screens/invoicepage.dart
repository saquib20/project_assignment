import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_assignment/controller/invoice_controller.dart';
import 'package:intl/intl.dart';
import 'package:project_assignment/screens/template_two.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final InvoiceController controller = Get.put(InvoiceController());

  bool isPortrait = true;
  String selectedValue = 'original';
  final List<int> copyOptions = [1, 2, 3, 4, 5];
  int selectedCopies = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Center(child: Text('Invoice Application'))),
        body: selectedTemplate == 'Template 1'
            ? Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isLargeScreen = constraints.maxWidth > 800;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: isLargeScreen
                                ? 300
                                : constraints.maxWidth * 0.4,
                            color: Colors.grey[100],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Text(
                                      "Print Setting",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    primary: true,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Printable Template',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            height: 200,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey[300]!),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: templates.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TemplatePreviewCard(
                                                    template: templates[index],
                                                    isSelected:
                                                        selectedTemplate ==
                                                            templates[index]
                                                                .name,
                                                    onSelect: () {
                                                      setState(() {
                                                        selectedTemplate =
                                                            templates[index]
                                                                .name;
                                                      });
                                                      print(selectedTemplate);
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Text(
                                            'Print Size',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          DropdownButtonFormField<String>(
                                            value: printSize,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                            ),
                                            items: ['A4', 'Letter', 'Legal']
                                                .map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                printSize = newValue!;
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Print Copies',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          Column(
                                            children: [
                                              DropdownButtonFormField<int>(
                                                  value: selectedCopies,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 16,
                                                            vertical: 8),
                                                    labelText: 'Select Copies',
                                                  ),
                                                  items: copyOptions
                                                      .map((int value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value,
                                                      child:
                                                          Text('$value copies'),
                                                    );
                                                  }).toList(),
                                                  onChanged: (int? newValue) {
                                                    if (newValue != null) {
                                                      setState(() {
                                                        selectedCopies =
                                                            newValue;
                                                      });
                                                    }
                                                  }),
                                              const SizedBox(height: 20),
                                              Text(
                                                'Selected Copies: $selectedCopies',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                          Text(
                                            'Additional Options',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          const SizedBox(height: 8),
                                          CheckboxListTile(
                                            title: const Text('Show Values'),
                                            value: showValues,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                showValues = value!;
                                              });
                                            },
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          CheckboxListTile(
                                            title:
                                                const Text('Digital Signature'),
                                            value: showDigitalSignature,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                showDigitalSignature = value!;
                                              });
                                            },
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          CheckboxListTile(
                                            title: const Text('Email Address'),
                                            value: showValues,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                showValues = value!;
                                              });
                                            },
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          CheckboxListTile(
                                            title: const Text('Website'),
                                            value: showValues,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                showValues = value!;
                                              });
                                            },
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          const SizedBox(height: 24),
                                          const SizedBox(height: 16),
                                          ElevatedButton.icon(
                                            onPressed: controller.printPdf,
                                            icon: const Icon(Icons.print),
                                            label: const Text('Print Invoice'),
                                            style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size.fromHeight(50)),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: isLargeScreen
                                ? Container(
                                    color: Colors.white,
                                    child: PdfPreview(
                                      canChangePageFormat: false,
                                      canChangeOrientation: false,
                                      build: (format) => _generatePdf(),
                                      initialPageFormat: PdfPageFormat.a4,
                                      pdfFileName: "invoice.pdf",
                                      allowPrinting: false,
                                      allowSharing: false,
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Text(
                                        "Expand the window for the preview",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )
            : InvoiceHomePage());
  }
}

Future<Uint8List> _generatePdf() async {
  final pdf = pw.Document();

  final String currentDate = DateFormat('MMM dd, yyyy').format(DateTime.now());

  pdf.addPage(
    pw.Page(
      pageFormat: printSize == 'A4'
          ? PdfPageFormat.a4
          : printSize == 'Letter'
              ? PdfPageFormat.letter
              : PdfPageFormat.legal,
      orientation: pageOrientation == Orientation.portrait
          ? pw.PageOrientation.portrait
          : pw.PageOrientation.landscape,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 40,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Invoice #: INV-2024\nDate: $currentDate ',
                      style: const pw.TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'ANOSH SOFTWARE',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text('123 Business Street'),
                    pw.Text('City, State 12345'),
                    pw.Text("www.saquibkhan.com"),
                  ],
                ),
              ],
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Email ID: kaquib982@gmail.com"),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Text(
                "ITEM DETAILS",
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ]),
            pw.SizedBox(height: 40),
            pw.TableHelper.fromTextArray(
              headers: [
                'Description',
                'Quantity',
                'Unit',
                if (showValues) 'Unit Price',
                if (showValues) 'Total'
              ],
              data: items
                  .map((item) => [
                        item.description,
                        item.quantity.toString(),
                        if (showValues)
                          '\$${item.unitPrice.toStringAsFixed(2)}',
                        if (showValues) '\$${item.total.toStringAsFixed(2)}',
                      ])
                  .toList(),
              border: null,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                if (showValues) 3: pw.Alignment.centerRight,
                if (showValues) 4: pw.Alignment.centerRight,
              },
            ),
            pw.SizedBox(height: 20),
            if (showValues)
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Total: \$${items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            pw.SizedBox(height: 70),
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
            pw.SizedBox(
              height: 150,
            ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.SizedBox(height: 10),
                pw.Text(
                  "Terms & Conditions:",
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
              ],
            ),
            pw.Text(
                "Payment is due within 30days\nPlease include invoice in payments\nAll prices are in USD")
          ],
        );
      },
    ),
  );

  return pdf.save();
}

class TemplatePreviewCard extends StatelessWidget {
  final InvoiceTemplate template;
  final bool isSelected;
  final VoidCallback onSelect;

  const TemplatePreviewCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 140,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Icon(Icons.description, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              template.name,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
