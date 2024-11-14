import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/event_model.dart';

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
Future<void> exportEventBoxToCsv(BuildContext context) async {
  try {
    // Ensure the box is open
    var box = Hive.isBoxOpen('events') ? Hive.box<Event>('events') : await Hive.openBox<Event>('events');

    // Debugging: Print the number of entries in the box
    print("Number of entries in 'events' box: ${box.length}");

    // Define the headers
    List<List<dynamic>> rows = [
      ["ID", "Name", "Description", "Location", "Date", "Address", "Urgency", "Skills", "Volunteers"]
    ];

    // Populate rows with event data
    for (var event in box.values) {
      if (event != null) {
        rows.add([
          event.id,
          event.name,
          event.description,
          event.location,
          DateFormat('MM/dd/yyyy').format(event.eventDate),
          event.address,
          event.urgency,
          event.requiredSkills.join(', '),
          event.assignedVolunteers.join(', ')
        ]);
      }
    }

    // Debugging: Print the generated CSV rows
    print("Generated CSV rows:");
    for (var row in rows) {
      print(row);
    }

    // Check if there is data to export
    if (rows.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No data available for CSV export")),
      );
      return;
    }

    // Generate CSV content
    String csvData = const ListToCsvConverter().convert(rows);

    // Get a directory to save the CSV file
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/events.csv";
    final file = File(path);

    // Write the CSV data to a file
    await file.writeAsString(csvData);

    // Show a preview in a dialog with DataTable
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("CSV Preview"),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: rows.first.map((header) => DataColumn(label: Text(header.toString()))).toList(),
              rows: rows.skip(1).map((row) {
                return DataRow(
                  cells: row.map((cell) => DataCell(Text(cell.toString()))).toList(),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Open CSV"),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("CSV file saved at $path")),
                );
                // Open the file in the default viewer
                OpenFile.open(path); // Requires the `open_file` package
              },
            ),
          ],
        );
      },
    );
  } catch (e) {
    print("Error exporting events to CSV: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error exporting events to CSV: $e")),
    );
  }
}