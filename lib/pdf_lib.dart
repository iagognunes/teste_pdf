import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class PdfLib extends StatefulWidget {
  const PdfLib({Key? key}) : super(key: key);

  @override
  State<PdfLib> createState() => _PdfLibState();
}

class _PdfLibState extends State<PdfLib> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          height: 1500,
          width: 1000,
          child: PdfPreview(
            build: (format) => _generatePdf(format),
            pdfFileName: 'Lista',
            allowSharing: false,
            canChangeOrientation: false,
            canChangePageFormat: false,
            canDebug: false,
          ),
        ),
      ),
    );
  }
}

Future<Uint8List> _generatePdf(PdfPageFormat format) async {
  final ByteData logo = await rootBundle.load('assets/images/marcadagua.png');
  final Uint8List marcadagua = logo.buffer.asUint8List();

  final ByteData qr = await rootBundle.load('assets/images/qrcode.png');
  final Uint8List qrcode = qr.buffer.asUint8List();

  final pdf = pw.Document(
    version: PdfVersion.pdf_1_5,
    compress: true,
  );

  pdf.addPage(
    pw.Page(
      pageTheme: pw.PageTheme(
        orientation: pw.PageOrientation.natural,
        buildBackground: (context) => pw.Center(
          child: pw.Container(
            child: pw.Opacity(
              opacity: 0.3,
              child: pw.Image(
                pw.MemoryImage(marcadagua),
                height: 400,
                width: 400,
              ),
            ),
          ),
        ),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(0),
      ),
      build: (pw.Context context) => pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('#71ad46'),
            width: 30,
          ),
        ),
        child: pw.Container(
          margin: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(
              color: PdfColor.fromHex('#385623'),
              width: 5,
            ),
          ),
          child: pw.Center(
            child: pw.Stack(
              children: [
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Image(
                      pw.MemoryImage(marcadagua),
                      height: 150,
                      width: 150,
                    ),
                    pw.SizedBox(
                      width: 300,
                      child: pw.Column(
                        children: [
                          pw.Divider(),
                          pw.Text('LEGAL VERIFICATION PROGRAM'),
                          pw.Text(
                              'verification of origin and legal compliance'),
                          pw.Divider(),
                        ],
                      ),
                    ),
                    pw.Container(
                      decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                              color: PdfColor.fromHex('#71ad46'), width: 2)),
                      width: 300,
                      height: 40,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text('BLUE LAKE LUMBER'),
                          pw.Text('1146/22'),
                        ],
                      ),
                    ),
                    pw.SizedBox(
                      width: 300,
                      child: pw.Column(
                        children: [
                          pw.Image(
                            pw.MemoryImage(qrcode),
                            height: 100,
                            width: 100,
                          ),
                          pw.Text(
                              'Scan Qr code to access the documents analyzed on this report',
                              style: const pw.TextStyle(fontSize: 8)),
                          pw.Divider(),
                          pw.Text('Belém, May 2, 2022'),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Positioned(
                  left: 120,
                  bottom: 1,
                  child: pw.Text(' UniConsult\nteste rodapé'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  pdf.addPage(pw.MultiPage(build: (context) {
    return [
      pw.Text('Hello'),
      pw.Wrap(children: [
        pw.Text('One'),
        pw.Text('Two'),
        pw.Text('Three'),
      ]),
    ];
  }));

  return pdf.save();
}
