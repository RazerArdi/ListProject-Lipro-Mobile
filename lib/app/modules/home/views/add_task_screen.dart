import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/calendar_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class AddTaskScreen extends StatelessWidget {
  final CalendarController controller = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Define a list of categories with their icons
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
    return WillPopScope(
      onWillPop: () async {
        return true; // Allow pop
      },
      child: Scaffold(
        backgroundColor: Color(0xFF1F1D2B),
        appBar: AppBar(
          title: Text("Add Task", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xFF1F1D2B),
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Get.back(),
            )
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Task Title",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  maxLines: 3,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16),
                // Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showCustomDatePicker(context),
                      child: Icon(Icons.access_time, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _showCategoryPicker(context),
                      child: Icon(Icons.label, color: Colors.white),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // Handle flag tap
                        _showPriorityPicker(context);
                      },
                      child: Icon(Icons.flag, color: Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // Handle send task
                        _handleSendTask();
                      },
                      child: Icon(Icons.send, color: Colors.purple),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _handleSendTask() {
    final newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      date: controller.selectedDate.value,
      time: controller.selectedTime.value,
      category: controller.selectedCategory.value,
      priority: controller.selectedPriority.value,
    );
    controller.addTask(newTask); // Add task to Firestore
    Get.back();
  }


  void _showCustomDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(controller: controller),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF2C2B3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 450,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryOption(categories[index]['name'], categories[index]['icon']);
              },
            ),
          ),
        );
      },
    );
  }

  void _showPriorityPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF2C2B3A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: EdgeInsets.all(16.0),
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Priority',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildPriorityOption('Low', Colors.green),
                    _buildPriorityOption('Medium', Colors.orange),
                    _buildPriorityOption('High', Colors.red),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.back(), // Close the dialog
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Customize color for Cancel
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 10), // Add spacing between buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Logic to save the selected priority if needed
                          Get.back(); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Widget _buildCategoryOption(String category, IconData icon) {
    return GestureDetector(
      onTap: () {
        controller.selectCategory(category);
        Get.back();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOption(String priority, Color color) {
    return GestureDetector(
      onTap: () {
        controller.selectPriority(priority);
        Get.back();
      },
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              priority,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDatePickerDialog extends StatelessWidget {
  final CalendarController controller;

  CustomDatePickerDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1F1D2B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Date',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(2101),
              focusedDay: controller.selectedDate.value,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDate.value, day),
              onDaySelected: (selectedDay, focusedDay) {
                controller.selectDate(selectedDay);
                Navigator.of(context).pop();
                _showTimePicker(context);
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.white70),
                weekdayStyle: TextStyle(color: Colors.white70),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(color: Colors.white),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon:
                Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed to space between
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(), // Close the dialog
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Customize color for Cancel
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => _showTimePicker(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Choose Time'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime.value,
    );
    if (pickedTime != null) {
      controller.selectTime(pickedTime);
    }
  }
}