import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventManagementScreen extends StatefulWidget {
  @override
  _EventManagementScreenState createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  // Save the event
  void _saveEvent() {
    // Here you would typically save the event data to a backend or local storage
    final String eventName = eventNameController.text;
    final String location = locationController.text;
    final String description = descriptionController.text;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event "$eventName" created successfully!'))
    );
  }

  // Function to pick date
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Function to pick time
  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  void dispose() {
    eventNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Management')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              Text('Date: ${DateFormat('MM/dd/yyyy').format(selectedDate)}'),
              ElevatedButton(
                onPressed: _pickDate,
                child: Text('Select Date'),
              ),
              SizedBox(height: 16.0),
              Text('Time: ${selectedTime.format(context)}'),
              ElevatedButton(
                onPressed: _pickTime,
                child: Text('Select Time'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
