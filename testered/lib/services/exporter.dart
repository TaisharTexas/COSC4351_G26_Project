import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import 'package:universal_html/html.dart' as html;

import '../models/event_model.dart';

// PDF Export and Preview
Future<void> exportHiveBoxToPdf(BuildContext context, String boxName) async {
  try {
    final box = await Hive.openBox(boxName);
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: box.keys.toList(),
            data: box.toMap().entries.map((entry) {
              final values = entry.value is Map
                  ? (entry.value as Map).values.toList()
                  : [entry.key, entry.value];
              return values.map((value) => value.toString()).toList();
            }).toList(),
          );
        },
      ),
    );

    // Open PDF preview inside the app
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  } catch (e) {
    print("Error exporting Hive box to PDF: $e");
  }
}

// CSV Export and Preview
Future<void> exportEventBoxToCsvWeb(List<Event> events) async {
  try {
    // Define CSV headers
    List<List<dynamic>> rows = [
      ["ID", "Name", "Description", "Location", "Date", "Address", "Urgency", "Skills", "Volunteers"]
    ];

    // Populate rows with event data
    for (var event in events) {
      rows.add([
        event.id,
        event.name,
        event.description,
        event.location,
        DateFormat('MM/dd/yyyy').format(event.eventDate),
        event.address,
        event.urgency,
        event.requiredSkills.join(', '),
        event.assignedVolunteers.join(', '),
      ]);
    }

    // Convert the rows to CSV format
    String csvData = const ListToCsvConverter().convert(rows);

    // Create a blob and trigger a download
    final blob = html.Blob([csvData], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "events.csv")
      ..click();

    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print("Error exporting events to CSV: $e");
  }
}