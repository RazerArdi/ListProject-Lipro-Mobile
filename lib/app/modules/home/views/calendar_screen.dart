import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lipro_mobile/app/modules/home/controllers/calendar_controller.dart';

class CalendarScreen extends StatelessWidget {
  final CalendarController controller = Get.put(CalendarController());

  // Definisikan daftar kategori dan ikon
  final List<Map<String, dynamic>> categories = [
    {'name': 'Grocery', 'icon': Icons.shopping_cart},
    {'name': 'Work', 'icon': Icons.work},
    {'name': 'Sport', 'icon': Icons.sports_baseball},
    {'name': 'Design', 'icon': Icons.design_services},
    {'name': 'University', 'icon': Icons.school},
    {'name': 'Social', 'icon': Icons.group},
    {'name': 'Music', 'icon': Icons.music_note},
    {'name': 'Health', 'icon': Icons.health_and_safety},
    {'name': 'Movie', 'icon': Icons.movie},
    {'name': 'Home', 'icon': Icons.home},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildMonthYearHeader(),
          _buildDateSelector(),
          // Horizontal date selector with scrollable boxes
          _buildTabButtons(),
          // Wraps "Today" and "Completed" buttons in a bordered container
          Expanded(child: _buildTaskList()),
          // Task list
        ],
      ),
    );
  }

  // Month and year header with month navigation
  Widget _buildMonthYearHeader() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left, color: Colors.white),
              onPressed: controller.previousMonth,
            ),
            Text(
              controller.selectedMonth,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right, color: Colors.white),
              onPressed: controller.nextMonth,
            ),
          ],
        );
      }),
    );
  }

  // Scrollable horizontal date selector that updates dynamically based on the month
  Widget _buildDateSelector() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        final selectedDay = controller.selectedDate.value.day;
        final daysInMonth = controller.daysInSelectedMonth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(daysInMonth, (index) {
              final date = controller.startDate.value.add(
                  Duration(days: index));
              final isSelected = date.day == selectedDay;

              return GestureDetector(
                onTap: () => controller.selectDate(date),
                child: Container(
                  width: 50,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.purple : Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat.E().format(date).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  // Tab buttons with wrapper and selection functionality
  Widget _buildTabButtons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[700]!, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            final isTodaySelected = controller.selectedTab.value == 'Today';
            return ElevatedButton(
              onPressed: () => controller.selectTab('Today'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isTodaySelected ? Colors.purple : Colors
                    .grey[800],
                foregroundColor: Colors.white,
              ),
              child: Text("Today"),
            );
          }),
          SizedBox(width: 10),
          Obx(() {
            final isCompletedSelected = controller.selectedTab.value ==
                'Completed';
            return ElevatedButton(
              onPressed: () => controller.selectTab('Completed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompletedSelected ? Colors.purple : Colors
                    .grey[800],
                foregroundColor: Colors.white,
              ),
              child: Text("Completed"),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return _buildTaskCard(context, task);
        },
      );
    });
  }

  // Create task card with updated category icons and default priority icon
  Widget _buildTaskCard(BuildContext context, Task task) {
    // Get category icon from categories list
    final categoryIcon = categories.firstWhere(
          (category) => category['name'] == task.category,
      orElse: () => {'icon': Icons.help}, // Default icon if not found
    )['icon'];

    // Priority icon
    IconData priorityIcon;
    switch (task.priority) {
      case 'Low':
        priorityIcon = Icons.looks_one;
        break;
      case 'Medium':
        priorityIcon = Icons.looks_two;
        break;
      case 'High':
        priorityIcon = Icons.looks_3;
        break;
      default:
        priorityIcon = Icons.priority_high;
    }

    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(categoryIcon, color: Colors.grey),
        ),
        title: Text(
          task.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          "At ${task.time.format(context)}",
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task.category,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            SizedBox(width: 8),
            Icon(priorityIcon, color: Colors.grey),
            // Icon priority tetap seperti sebelumnya
          ],
        ),
        onTap: () => _showTaskDialog(context, task),
      ),
    );
  }

  // Function to show the dialog with task details and options to "Complete" or "Uncomplete"
  void _showTaskDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Task Details',
              style: TextStyle(color: Colors.white)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Description: ${task.description}",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "At: ${task.time.format(context)}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: <Widget>[
            // Button to toggle completion status
            TextButton(
              onPressed: () {
                // Toggle task completion status
                controller.toggleTaskCompletion(
                    task); // Call the toggleTaskCompletion method
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                task.isCompleted ? 'Mark as Uncompleted' : 'Mark as Completed',
                style: TextStyle(
                    color: task.isCompleted ? Colors.red : Colors.green),
              ),
            ),
            // Button to cancel the action
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close the dialog without making changes
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
