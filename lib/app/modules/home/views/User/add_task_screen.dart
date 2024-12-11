import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/task_controller.dart';
import 'package:lipro_mobile/app/modules/home/views/CustomDatePickerDialog.dart';
import 'package:lipro_mobile/app/modules/home/views/CustomPriorityPickerDialog.dart';
import 'package:table_calendar/table_calendar.dart';

// The AddTaskScreen is a StatefulWidget that allows users to add a task with details.
class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.put(TaskController());  // Using GetX for state management.
  final TextEditingController titleController = TextEditingController();  // Controller for task title input.
  final TextEditingController descriptionController = TextEditingController();  // Controller for task description input.

  // A list of predefined categories for tasks along with their icons.
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

  // Builds the widget tree for the screen
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true, // Allows the user to pop the screen
      child: Scaffold(
        backgroundColor: Color(0xFF1F1D2B),  // Background color of the screen
        appBar: AppBar(
          title: Text("Add Task", style: TextStyle(color: Colors.white)),  // Title in the app bar
          backgroundColor: Color(0xFF1F1D2B),  // AppBar background color
          actions: [
            // Close button in the app bar to exit the screen
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Get.back(),  // Pops the screen when pressed
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,  // Adjusts the UI when the keyboard appears
        body: Padding(
          padding: const EdgeInsets.all(16.0),  // Padding around the screen content
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(titleController, "Task Title"),  // Task title input field
                SizedBox(height: 16),
                _buildLabel("Description"),  // Label for the description
                SizedBox(height: 8),
                _buildTextField(descriptionController, "Description", maxLines: 3),  // Task description input field with multiple lines
                SizedBox(height: 16),
                _buildDateTimeDisplay(context),  // Displays the selected date and time
                SizedBox(height: 20),
                // Icons Row for interacting with the task (for date, category, priority, and saving)
                _buildIconRow(context),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // A helper method to build text input fields
  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return Builder(
      builder: (BuildContext context) {
        return TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: TextStyle(color: Colors.white),  // Text color for input fields
          onSubmitted: (_) {
            FocusScope.of(context).unfocus();  // Close the keyboard when enter is pressed
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();  // Close the keyboard
          },
        );
      },
    );
  }

  // A helper method to build labels for input fields
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,  // Label text color
      ),
    );
  }

  // A method to build the row of icons that allow users to interact with the task
  Widget _buildIconRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildIconButton(Icons.access_time, () => _showCustomDatePicker(context)),  // Date picker icon
        SizedBox(width: 16),
        _buildIconButton(Icons.label, () => _showCategoryPicker(context)),  // Category picker icon
        SizedBox(width: 16),
        _buildIconButton(Icons.flag, () => _showPriorityPicker(context)),  // Priority picker icon
        Spacer(),
        _buildIconButton(Icons.send, () => _handleSendTask(), color: Colors.purple),  // Send/save task icon
      ],
    );
  }

  // A helper method to create an individual icon button for interactions
  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color),  // An icon button that reacts to taps
    );
  }

  // A method to display the selected date and time for the task
  Widget _buildDateTimeDisplay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date: ${controller.selectedDate.value.year}-${controller.selectedDate.value.month}-${controller.selectedDate.value.day}',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          'Time: ${controller.selectedTime.value.format(context)}',  // Formats time as hh:mm AM/PM
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  // Method to handle the saving of the task
  void _handleSendTask() {
    final newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      date: controller.selectedDate.value,  // Only stores the date part (not time)
      time: controller.selectedTime.value,  // Stores the selected time as TimeOfDay
      category: controller.selectedCategory.value,
      priority: controller.selectedPriority.value,
      isCompleted: false,  // Default is false
    );

    controller.addTask(newTask);  // Adds the new task using the controller
    Get.back();  // Goes back to the previous screen

    // Shows a success snackbar after saving the task
    Get.snackbar(
      'Task Saved',
      'Your task has been successfully saved to the database.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  // Opens a custom date picker dialog
  void _showCustomDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(controller: controller),  // Custom date picker dialog
    );
  }

  // Opens a category picker dialog to select a task category
  void _showCategoryPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF2C2B3A),  // Background color of the dialog
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),  // Rounded corners
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,  // 3 columns for categories
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryOption(categories[index]['name'], categories[index]['icon']);  // Each category option
              },
            ),
          ),
        );
      },
    );
  }

  // Opens a priority picker dialog to select the task priority
  void _showPriorityPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomPriorityPickerDialog(controller: controller);  // Custom priority picker dialog
      },
    );
  }

  // Builds an individual category option for the category picker dialog
  Widget _buildCategoryOption(String category, IconData icon) {
    return GestureDetector(
      onTap: () {
        controller.selectCategory(category);  // Updates the selected category
        Get.back();  // Close the dialog
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),  // Light background color for each option
          borderRadius: BorderRadius.circular(12),  // Rounded corners for each option
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
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
}
