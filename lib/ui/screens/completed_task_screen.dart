import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/task_details_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  static const String name = '/completed-task';
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              'All Completed Task',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: fireStore
                    .collection('tasks')
                    .where('status', isEqualTo: 'Completed')
                    .orderBy('date', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text('An Error Occurred on Server!'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No tasks available'));
                  } else {
                    final tasks = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskDetails(
                          title: task['title'] ?? 'No Title',
                          details: task['details'] ?? 'No Details',
                          date: task['date'] ?? DateTime.now().toString(),
                          status: task['status'] ?? 'No Status',
                          docID: task.id,
                          from: task['from'],
                          to: task['to'],
                          createdAt: DateFormat(
                            'yyyy-MM-dd',
                          ).format(task['createdAt'].toDate()),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
