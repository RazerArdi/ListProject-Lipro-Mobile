import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/UserControllers/IndexController.dart';
import 'package:lipro_mobile/app/modules/home/views/User/IndexPage/TaskCard.dart';
import 'package:lipro_mobile/app/modules/home/views/User/IndexPage/TaskCard.dart';
import 'package:lipro_mobile/app/modules/home/views/User/IndexPage/TaskDetailScreen.dart';

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
                taskCount: (task['taskCount'] ?? 0) as int, taskData: {}, description: '',
              );
            },
          );
        }
      });
  }
}


