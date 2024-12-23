import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:image/image.dart' as img;

Future<void> exportToPdf({
  required String title,
  required List<DataColumn> columns,
  required List<DataRow> rows,
}) async {
  final pdf = pw.Document();

  // Load image from assets
  final ByteData bytes =
      await rootBundle.load('assets/images/logo_principal.png');
  final Uint8List imageBytes = bytes.buffer.asUint8List();
  final img.Image image = img.decodeImage(imageBytes)!;

  // Create PDF
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        // Convert DataColumns to headers
        final headers = columns.map((col) {
          // Verificar si col.label es un Text
          if (col.label is Text) {
            final label = (col.label as Text).data ?? ''; // Extract actual text
            return pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            );
          }
          return pw.Text(
            'N/A', // Default value if it's not a Text widget
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          );
        }).toList();

        // Convert DataRows to row data
        final tableRows = rows.map((row) {
          return row.cells.map((cell) {
            // Verificar si cell.child es un Text
            if (cell.child is Text) {
              final value =
                  (cell.child as Text).data ?? ''; // Extract actual text
              return pw.Text(
                value,
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
              );
            }
            return pw.Text(
              'N/A', // Default value if it's not a Text widget
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            );
          }).toList();
        }).toList();

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with image
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(
                  pw.MemoryImage(imageBytes),
                  width: 100, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                ),
                pw.Text(
                  'IEP. Santa Maria School',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Title
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),

            // Table
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
              ),
              headerDecoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#db5623'),
              ),
              cellHeight: 30,
              cellAlignments: Map.fromIterables(
                List.generate(columns.length - 1, (index) => index),
                List.generate(
                    columns.length - 1, (index) => pw.Alignment.centerLeft),
              ),
              headerHeight: 40,
              headers: headers.map((header) => (header as pw.Text)).toList(),
              data: tableRows
                  .map((row) => row.map((cell) => (cell as pw.Text)).toList())
                  .toList(),
            ),
          ],
        );
      },
    ),
  );

  // Show print preview
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
