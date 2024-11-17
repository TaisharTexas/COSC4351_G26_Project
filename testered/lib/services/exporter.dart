
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:typed_data';
import '../models/event_model.dart';
import '../models/user_model.dart';

// PDF Export and Preview
Future<void> exportEventBoxToPdfWeb(List<Event> events) async {
  try {
    final pdf = pw.Document();

    // Add event data with styled table
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter.landscape,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Event Details',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  'ID',
                  'Name',
                  'Description',
                  'Location',
                  'Date',
                  'Address',
                  'Urgency',
                  'Skills',
                  'Volunteers'
                ],
                data: events.map((event) {
                  return [
                    event.id,
                    event.name,
                    event.description,
                    event.location,
                    event.eventDate.toIso8601String(),
                    event.address,
                    event.urgency,
                    event.requiredSkills.join(', '),
                    event.assignedVolunteers.join(', ')
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blue,
                ),
                cellStyle: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.black,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                border: pw.TableBorder.all(
                  color: PdfColors.grey,
                  width: 0.5,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Generate PDF as bytes
    Uint8List pdfBytes = await pdf.save();

    // Create a blob and trigger a download
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'events.pdf')
      ..click();

    // Clean up the URL object
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print("Error exporting events to PDF: $e");
  }
}

Future<void> exportUserBoxToPdfWeb(List<User> users) async {
  try {
    final pdf = pw.Document();

    // Add user data with styled table
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.letter.landscape,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'User Details',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: [
                  'Email',
                  'Full Name',
                  'Address 1',
                  'Address 2',
                  'City',
                  'State',
                  'Zip Code',
                  'Skills',
                  'Preferences',
                  'Availability',
                  'Past Events',
                  'Admin Status'
                ],
                data: users.map((user) {
                  return [
                    user.email,
                    user.fullName,
                    user.address1,
                    user.address2,
                    user.city,
                    user.state,
                    user.zipCode,
                    user.skills.join(', '),
                    user.preferences,
                    user.availability
                        .map((date) => DateFormat('MM/dd/yyyy').format(date))
                        .join(', '),
                    user.pastEvents.join(', '),
                    user.isAdmin ? 'Yes' : 'No'
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.blue,
                ),
                cellStyle: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.black,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                border: pw.TableBorder.all(
                  color: PdfColors.grey,
                  width: 0.5,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Generate PDF as bytes
    Uint8List pdfBytes = await pdf.save();

    // Create a blob and trigger a download
    final blob = html.Blob([pdfBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'users.pdf')
      ..click();

    // Clean up the URL object
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print("Error exporting users to PDF: $e");
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

Future<void> exportUserBoxToCsvWeb(List<User> users) async {
  try {

    // Define CSV headers
    List<List<dynamic>> rows = [
      [
        "Email", "Password", "Full Name", "Address 1", "Address 2", "City", "State", "Zip Code", "Skills", "Preferences", "Availability", "Past Events", "Is Admin"
      ]
    ];

    // Populate rows with user data
    for (var user in users) {
      rows.add([
        user.email,
        user.password,
        user.fullName,
        user.address1,
        user.address2,
        user.city,
        user.state,
        user.zipCode,
        user.skills.join(', '),
        user.preferences,
        user.availability.map((date) => date.toIso8601String()).join(', '),
        user.pastEvents.join(', '),
        user.isAdmin ? "Yes" : "No",
      ]);
    }

    // Convert the rows to CSV format
    String csvData = const ListToCsvConverter().convert(rows);

    // Create a blob and trigger a download
    final blob = html.Blob([csvData], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "users.csv")
      ..click();

    html.Url.revokeObjectUrl(url);
  } catch (e) {
    print("Error exporting users to CSV: $e");
  }
}