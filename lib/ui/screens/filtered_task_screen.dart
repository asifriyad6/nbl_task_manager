import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../widgets/task_details_card.dart';

class FilteredTaskListScreen extends StatelessWidget {
  final String filterType; // 'status', 'from', or 'all'
  final String filterValue;
  final String title;

  const FilteredTaskListScreen({
    super.key,
    required this.filterType,
    required this.filterValue,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Build query
    Query query = FirebaseFirestore.instance.collection('tasks');
    if (filterType == 'status') {
      query = query
          .where('status', isEqualTo: filterValue)
          .orderBy('date', descending: false);
    } else if (filterType == 'from') {
      query = query
          .where('from', isEqualTo: filterValue)
          .orderBy('date', descending: false);
    } // 'all' means no filter

    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: query.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No tasks found'));
                  }

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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
