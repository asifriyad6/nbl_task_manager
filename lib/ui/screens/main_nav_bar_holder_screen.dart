import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/new_task_list_screen.dart';
import 'package:task_manager/ui/screens/processing_task_screen.dart';

import '../widgets/tm_app_bar.dart';
import 'cancelled_task_screen.dart';
import 'completed_task_screen.dart';

class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});
  static String name = '/main-nav-bar-holder';

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {
  final List<Widget> _screens = [
    NewTaskListScreen(),
    ProcessingTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.green.shade200,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          _selectedIndex = value;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: 'All Task',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Processing',
          ),
          NavigationDestination(
            icon: Icon(Icons.done_all_outlined),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            label: 'Cancelled',
          ),
        ],
      ),
    );
  }
}
