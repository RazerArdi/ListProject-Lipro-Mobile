import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/ThemeController.dart';
import 'package:lipro_mobile/app/modules/home/controllers/UserControllers/task_controller.dart';
import 'package:lipro_mobile/app/modules/home/views/CustomDatePickerDialog.dart';
import 'package:lipro_mobile/app/modules/home/views/CustomPriorityPickerDialog.dart';
class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

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

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.put(TaskController());  // Using GetX for state management.
  final TextEditingController titleController = TextEditingController();  // Controller for task title input.
  final TextEditingController descriptionController = TextEditingController();  // Controller for task description input.
  final ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    themeController.selectThemeByCurrentDate();  // Set theme based on current date
    print('Initial Theme: ${themeController.currentTheme.value?.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentTheme = themeController.currentTheme.value!; // Ensure theme is selected
      return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: currentTheme.backgroundColor,  // Use theme's background color
          appBar: AppBar(
            title: Text(
                "Add Task",
                style: TextStyle(color: currentTheme.secondaryColor)
            ),
            backgroundColor: currentTheme.backgroundColor, // Use theme's background color
            actions: [
              IconButton(
                icon: Icon(Icons.close, color: currentTheme.secondaryColor),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                      titleController,
                      "Task Title",
                      primaryColor: currentTheme.primaryColor,
                      secondaryColor: currentTheme.secondaryColor
                  ),
                  SizedBox(height: 16),
                  _buildLabel("Description", color: currentTheme.secondaryColor),
                  SizedBox(height: 8),
                  _buildTextField(
                      descriptionController,
                      "Description",
                      maxLines: 3,
                      primaryColor: currentTheme.primaryColor,
                      secondaryColor: currentTheme.secondaryColor
                  ),
                  SizedBox(height: 16),
                  _buildDateTimeDisplay(context, textColor: currentTheme.secondaryColor),
                  SizedBox(height: 20),
                  _buildIconRow(context, iconColor: currentTheme.primaryColor),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      {int maxLines = 1,
        Color? primaryColor,
        Color? secondaryColor}
      ) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: secondaryColor ?? Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor ?? Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor ?? Colors.white, width: 2),
        ),
      ),
      style: TextStyle(color: secondaryColor ?? Colors.white),
      cursorColor: primaryColor,
    );
  }

  Widget _buildLabel(String text, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color ?? Colors.white,
      ),
    );
  }

  Widget _buildIconRow(BuildContext context, {Color? iconColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildIconButton(Icons.access_time, () => _showCustomDatePicker(context), color: iconColor),
        SizedBox(width: 16),
        _buildIconButton(Icons.label, () => _showCategoryPicker(context), color: iconColor),
        SizedBox(width: 16),
        _buildIconButton(Icons.flag, () => _showPriorityPicker(context), color: iconColor),
        Spacer(),
        _buildIconButton(Icons.send, () => _handleSendTask(), color: iconColor ?? Colors.purple),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color ?? Colors.white),
    );
  }

  Widget _buildDateTimeDisplay(BuildContext context, {Color? textColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date: ${controller.selectedDate.value.year}-${controller.selectedDate.value.month}-${controller.selectedDate.value.day}',
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          'Time: ${controller.selectedTime.value.format(context)}',
          style: TextStyle(color: textColor ?? Colors.white),
        ),
      ],
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
      isCompleted: false,
    );

    controller.addTask(newTask);
    Get.back();

    Get.snackbar(
      'Task Saved',
      'Your task has been successfully saved to the database.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  void _showCustomDatePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDatePickerDialog(controller: controller),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    final currentTheme = themeController.currentTheme.value!;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: currentTheme.backgroundColor.withOpacity(0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryOption(
                  categories[index]['name'],
                  categories[index]['icon'],
                  primaryColor: currentTheme.primaryColor,
                  secondaryColor: currentTheme.secondaryColor,
                );
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
        return CustomPriorityPickerDialog(controller: controller);
      },
    );
  }

  Widget _buildCategoryOption(
      String category,
      IconData icon,
      {Color? primaryColor,
        Color? secondaryColor}
      ) {
    return GestureDetector(
      onTap: () {
        controller.selectCategory(category);
        Get.back();
      },
      child: Container(
        decoration: BoxDecoration(
          color: primaryColor?.withOpacity(0.2) ?? Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: secondaryColor ?? Colors.white),
            SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(color: secondaryColor ?? Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}