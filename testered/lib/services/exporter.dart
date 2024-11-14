import 'dart:io';
import 'package:hive/hive.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

//PDF Export
Future<void> exportHiveBoxToPdf(String boxName) async {
  try {
    // Open the Hive box
    final box = await Hive.openBox(boxName);

    // Create a PDF document
    final pdf = pw.Document();

    // Add a title page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            'Data from $boxName',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
        ),
      ),
    );

    // Add the data table to a new page
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: box.keys.toList(), // Column headers
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

    // Save the PDF file to the device
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/$boxName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("PDF exported to $filePath");
  } catch (e) {
    print("Error exporting Hive box to PDF: $e");
  }
}

// CSV Export
Future<void> exportHiveBoxToCsv(String boxName) async {
  try {
    // Open the Hive box
    final box = await Hive.openBox(boxName);

    // Prepare the CSV data
    List<List<dynamic>> rows = [];

    // Add headers
    rows.add(box.keys.toList()); // Assumes each entry is a Map with the same keys (fields)

    // Add box entries as CSV rows
    box.toMap().forEach((key, value) {
      // If each entry in the box is a Map, convert it to a list of values
      if (value is Map) {
        rows.add(value.values.toList());
      } else {
        rows.add([key, value]);
      }
    });

    // Convert rows to CSV format
    String csvData = const ListToCsvConverter().convert(rows);

    // Get the directory to save the CSV file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/$boxName.csv";

    // Write the CSV data to a file
    final file = File(filePath);
    await file.writeAsString(csvData);

    print("Data exported to $filePath");
  } catch (e) {
    print("Error exporting Hive box to CSV: $e");
  }
}