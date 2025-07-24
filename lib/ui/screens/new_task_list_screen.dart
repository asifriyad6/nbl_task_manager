import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/ui/screens/create_task_screen.dart';

import '../widgets/task_count_summary_card.dart';
import '../widgets/task_details_card.dart';
import 'filtered_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  static const String name = '/home-screen';
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  final fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                final processingCount = docs
                    .where((doc) => doc['status'] == 'Processing')
                    .length;
                final chairmanCount = docs
                    .where((doc) => doc['from'] == 'Chairman')
                    .length;
                final mdCount = docs
                    .where((doc) => doc['from'] == 'Managing Director')
                    .length;
                // Prepare data for horizontal list
                final summaryData = [
                  {'title': 'From Chairman', 'count': chairmanCount},
                  {'title': 'From MD', 'count': mdCount},
                  {'title': 'Processing Tasks', 'count': processingCount},
                  {'title': 'All Tasks', 'count': docs.length},
                ];
                return SizedBox(
                  height: 100,
                  child: ListView.separated(
                    itemCount: summaryData.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = summaryData[index];
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilteredTaskListScreen(
                                  filterType: 'from',
                                  filterValue: 'Chairman',
                                  title: 'Tasks From Chairman',
                                ),
                              ),
                            );
                          } else if (index == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilteredTaskListScreen(
                                  filterType: 'from',
                                  filterValue: 'Managing Director',
                                  title: 'Tasks From MD',
                                ),
                              ),
                            );
                          } else if (index == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilteredTaskListScreen(
                                  filterType: 'status',
                                  filterValue: 'Processing',
                                  title: 'All Processing Tasks',
                                ),
                              ),
                            );
                          } else {}
                        },
                        child: TaskSummaryCard(
                          title: item['title'] as String,
                          count: item['count'] as int,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 8);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder(
                stream: fireStore
                    .collection('tasks')
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, CreateTaskScreen.name);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}
