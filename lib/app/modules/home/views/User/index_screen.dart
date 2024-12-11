import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/IndexController.dart';

class IndexScreen extends StatelessWidget {
  final IndexController controller = Get.put(IndexController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // SliverAppBar to make the search bar sticky
          SliverAppBar(
            backgroundColor: Colors.black,
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search for your task...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // The content of the screen
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              // Date Range Dropdown
              _buildDateRangeDropdown(),
              const SizedBox(height: 16),
              // Task List based on Date Range
              _buildTaskList(),
              const SizedBox(height: 16),
              // Task Status Dropdown
              _buildTaskStatusDropdown(),
              const SizedBox(height: 16),
              // Task List based on Task Status
              _buildTaskList(),
            ]),
          ),
        ],
      ),
    );
  }

// Build the Date Range Dropdown
  Widget _buildDateRangeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Padding for left and right sides
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8), // Ensuring no extra padding around the dropdown itself
          decoration: BoxDecoration(
            color: Colors.grey[850]?.withOpacity(0.5), // Transparent grey background
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: DropdownButton<String>(
            dropdownColor: Colors.grey[850],
            value: controller.selectedDateRange.value,
            items: ['Today', 'This Week', 'This Month']
                .map((value) => DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedDateRange.value = value;
                controller.fetchTasks(); // Fetch tasks when dropdown changes
              }
            },
            underline: Container(), // Remove underline
          ),
        );
      }),
    );
  }

// Build the Task Status Dropdown
  Widget _buildTaskStatusDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16), // Padding for left and right sides
      child: Obx(() {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8), // Ensuring no extra padding around the dropdown itself
          decoration: BoxDecoration(
            color: Colors.grey[850]?.withOpacity(0.5), // Transparent grey background
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          width: 10,
          child: DropdownButton<String>(
            dropdownColor: Colors.grey[850],
            value: controller.selectedTaskStatus.value,
            items: ['Completed', 'Uncompleted']
                .map((value) => DropdownMenuItem(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedTaskStatus.value = value;
                controller.fetchTasks(); // Fetch tasks when dropdown changes
              }
            },
            underline: Container(), // Remove underline
          ),
        );
      }),
    );
  }


  // Build Task List (unifies both task lists into one)
  Widget _buildTaskList() {
    return // Inside _buildTaskList method
      Obx(() {
        var filteredTasks = controller.filteredTasks;
        if (filteredTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/emptyTask.png', height: 200),
                const SizedBox(height: 20),
                const Text(
                  "What do you want to do today?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Tap + to add your tasks",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final task = filteredTasks[index];
              return TaskCard(
                title: task['title'] as String,
                time: task['time'] as String,
                category: task['category'] as String,
                taskCount: (task['taskCount'] ?? 0) as int,
              );
            },
          );
        }
      });
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String category;
  final int taskCount;

  const TaskCard({
    Key? key,
    required this.title,
    required this.time,
    required this.category,
    required this.taskCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color categoryColor;
    IconData categoryIcon;

    // Customize category colors and icons based on category type
    switch (category) {
      case 'University':
        categoryColor = Colors.blue;
        categoryIcon = Icons.school;
        break;
      case 'Home':
        categoryColor = Colors.red;
        categoryIcon = Icons.home;
        break;
      case 'Work':
        categoryColor = Colors.orange;
        categoryIcon = Icons.work;
        break;
      default:
        categoryColor = Colors.grey;
        categoryIcon = Icons.label;
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Added horizontal margin
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.radio_button_unchecked, color: Colors.grey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          Icon(categoryIcon, size: 16, color: categoryColor),
                          const SizedBox(width: 4),
                          Text(
                            category,
                            style: TextStyle(color: categoryColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$taskCount',
                        style: const TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

