import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:project_assignment/controller/invoice_controller.dart';
import 'package:project_assignment/screens/invoicepage.dart';
import '../controller/invoice_controller.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Invoice Template',
      home: InvoiceHomePage(),
    );
  }
}

class InvoiceHomePage extends StatelessWidget {
  final InvoiceController controller = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Sidebar(controller: controller),
              Expanded(
                child: InvoiceCanvas(),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: ElevatedButton.icon(
                    label: const Text('Print Invoice'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                    onPressed: () => generatePDF(controller),
                    icon: const Icon(Icons.print),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void generatePDF(InvoiceController controller) async {
    final pdf = pw.Document();

    var termsCondition = 'Terms & Conditions:'.obs;
    var paymentTerms =
        'Payment is due within 30days\nPlease include invoice in payments\nAll prices are in USD'
            .obs;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 40,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text('Invoice Name: ${controller.invoiceNumber.value}',
                style: pw.TextStyle(fontSize: 18)),
            pw.Text('Company Name: ${controller.customerName.value}',
                style: pw.TextStyle(fontSize: 16)),
            pw.Text('Company Location: ${controller.customerAddress.value}',
                style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 20),
            pw.Text('Items:', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            ...controller.items2.map(
              (item) => pw.Text(
                '${item.description} - Quantity: ${item.quantity}, Unit Price: \$${item.unitPrice.toStringAsFixed(2)}',
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Text(
              'Total Amount: \$${controller.getTotalCost().toStringAsFixed(2)}',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.red,
              ),
            ),
            pw.SizedBox(
              height: 300,
            ),
            pw.Divider(),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    '$termsCondition',
                    style: pw.TextStyle(
                      fontSize: 20,
                      color: PdfColors.blue,
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              '$paymentTerms',
              style: pw.TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}

class Sidebar extends StatefulWidget {
  final InvoiceController controller;

  Sidebar({required this.controller});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return selectedTemplate == 'Template 2'
        ? SingleChildScrollView(
            primary: true,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Template 2",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                const Divider(),
                Text(
                  'Printable Template',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  width: 300,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: templates.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TemplatePreviewCard(
                                template: templates[index],
                                isSelected:
                                    selectedTemplate == templates[index].name,
                                onSelect: () {
                                  setState(() {
                                    selectedTemplate = templates[index].name;
                                  });
                                  print(selectedTemplate);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                          child: Text('Company Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ))),
                      SizedBox(height: 20),
                      Draggable<String>(
                        data: 'Invoice Number: INV-2024-001',
                        feedback: DragFeedback(text: 'Invoice Number'),
                        child: DragItem(text: 'Invoice Number'),
                        onDragEnd: (_) =>
                            widget.controller.setInvoiceName('INV-2024-001'),
                      ),
                      SizedBox(height: 10),
                      Draggable<String>(
                        data: 'Company Name: ANOSH SOFTWARE',
                        feedback: DragFeedback(text: 'Company Name'),
                        child: DragItem(text: 'Company Name'),
                        onDragEnd: (_) =>
                            widget.controller.setCompanyName('ANOSH SOFTWARE'),
                      ),
                      SizedBox(height: 10),
                      Draggable<String>(
                        data:
                            'Company Location: 123 Business Street, City, State 12345',
                        feedback: DragFeedback(text: 'Company Location'),
                        child: DragItem(text: 'Company Location'),
                        onDragEnd: (_) => widget.controller.setCompanyLocation(
                            '123 Business Street, City, State 12345'),
                      ),
                      Center(
                        child: Text(
                          'Items',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Draggable<InvoiceItem>(
                        data: InvoiceItem(
                            description: 'Widget Type A',
                            quantity: 5,
                            unitPrice: 300.0),
                        feedback: DragFeedback(text: 'Widget Type A'),
                        child: DragItem(text: 'Widget Type A'),
                        onDragEnd: (_) => widget.controller.addItem(
                          InvoiceItem(
                              description: 'Widget Type A',
                              quantity: 5,
                              unitPrice: 300.0),
                        ),
                      ),
                      Draggable<InvoiceItem>(
                        data: InvoiceItem(
                            description: 'Service Package B',
                            quantity: 2,
                            unitPrice: 450.0),
                        feedback: DragFeedback(text: 'Service Package B'),
                        child: DragItem(text: 'Service Package B'),
                        onDragEnd: (_) => widget.controller.addItem(
                          InvoiceItem(
                              description: 'Service Package B',
                              quantity: 2,
                              unitPrice: 450.0),
                        ),
                      ),
                      Draggable<InvoiceItem>(
                        data: InvoiceItem(
                            description: 'Consultation',
                            quantity: 3,
                            unitPrice: 550.0),
                        feedback: DragFeedback(text: 'Consultation'),
                        child: DragItem(text: 'Consultation'),
                        onDragEnd: (_) => widget.controller.addItem(
                          InvoiceItem(
                              description: 'Consultation',
                              quantity: 3,
                              unitPrice: 550.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : InvoicePage();
  }

  generatePDF(InvoiceController controller) async {}
}

class InvoiceCanvas extends StatelessWidget {
  final InvoiceController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Container(
        color: Colors.white,
        child: DragTarget<String>(
          onAccept: (data) => print('Dropped: $data'),
          builder: (context, candidateData, rejectedData) => Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INVOICE',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (controller.invoiceNumber.value.isNotEmpty)
                    Text('Invoice Number: ${controller.invoiceNumber.value}',
                        style: TextStyle(fontSize: 16)),
                  if (controller.customerName.value.isNotEmpty)
                    Text('Company Name: ${controller.customerName.value}',
                        style: TextStyle(fontSize: 16)),
                  if (controller.customerAddress.value.isNotEmpty)
                    Text(
                        'Company Location: ${controller.customerAddress.value}',
                        style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  Text('Items:', style: TextStyle(fontSize: 16)),
                  ...controller.items2.map((item) => Text(
                      '${item.description} - Quantity: ${item.quantity}, Unit Price: \$${item.unitPrice.toStringAsFixed(2)}')),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Text(
                    'Total: \$${controller.getTotalCost().toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  SizedBox(
                    height: 300,
                  ),
                  Divider(),
                  Text(
                    "Term & Condition",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "Payment is due within 30days\nPlease include invoice in payments\nAll prices are in USD",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DragItem extends StatelessWidget {
  final String text;

  DragItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(bottom: 10.0),
      color: Colors.blue[100],
      child: Text(text),
    );
  }
}

class DragFeedback extends StatelessWidget {
  final String text;

  DragFeedback({required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.blue[300],
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
