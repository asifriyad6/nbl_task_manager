import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/edit_task_screen.dart';

class TaskDetails extends StatelessWidget {
  final String title;
  final String details;
  final String date;
  final String createdAt;
  final String status;
  final String docID;
  final String from;
  final String to;
  const TaskDetails({
    super.key,
    required this.title,
    required this.details,
    required this.date,
    required this.status,
    required this.docID,
    required this.from,
    required this.to,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 5),
            Text(details, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Date: $date'),
                Spacer(),
                Text('Created: $createdAt'),
              ],
            ),
            const SizedBox(height: 5),
            Row(children: [Text('From: $from'), Spacer(), Text('To: $to')]),
            Row(
              children: [
                Chip(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  backgroundColor: status == 'Processing'
                      ? Colors.blue
                      : status == 'Completed'
                      ? Colors.green
                      : status == 'Cancelled'
                      ? Colors.red
                      : Colors.grey,

                  labelPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  label: Text(
                    status,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmation(context, docID);
                  },
                  icon: Icon(Icons.delete, color: Colors.red),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to edit task screen
                    Navigator.pushNamed(
                      context,
                      EditTaskScreen.name,
                      arguments: {
                        'id': docID,
                        'title': title,
                        'details': details,
                        'date': date,
                        'status': status,
                        'from': from,
                        'to': to,
                      },
                    );
                  },
                  icon: Icon(Icons.edit_document, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String docID) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // align to the right
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12), // space between buttons
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop(); // close the dialog first
                      try {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(docID)
                            .delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Task deleted successfully'),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Delete failed: $e')),
                        );
                      }
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
