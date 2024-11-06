import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/task_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.put(TaskController());
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
      onWillPop: () async => true, // Allow pop
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
                _buildTextField(titleController, "Task Title"),
                SizedBox(height: 16),
                _buildLabel("Description"),
                SizedBox(height: 8),
                _buildTextField(descriptionController, "Description", maxLines: 3),
                SizedBox(height: 16),
                _buildDateTimeDisplay(context),
                SizedBox(height: 20),
                // Icons Row
                _buildIconRow(context),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          style: TextStyle(color: Colors.white),
          onSubmitted: (_) {
            // Ensure the text is saved when the user presses enter
            FocusScope.of(context).unfocus();  // Use 'context' from the Builder widget
          },
          onEditingComplete: () {
            // Handle other actions if needed
            FocusScope.of(context).unfocus();  // Use 'context' from the Builder widget
          },
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildIconRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildIconButton(Icons.access_time, () => _showCustomDatePicker(context)),
        SizedBox(width: 16),
        _buildIconButton(Icons.label, () => _showCategoryPicker(context)),
        SizedBox(width: 16),
        _buildIconButton(Icons.flag, () => _showPriorityPicker(context)),
        Spacer(),
        _buildIconButton(Icons.send, () => _handleSendTask(), color: Colors.purple),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color),
    );
  }

  // Build a widget that shows the selected date and time
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
          'Time: ${controller.selectedTime.value.format(context)}',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  void _handleSendTask() {
    final newTask = Task(
      title: titleController.text,
      description: descriptionController.text,
      date: controller.selectedDate.value,  // Date hanya berisi tanggal
      time: controller.selectedTime.value,  // Waktu disimpan sebagai TimeOfDay
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
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color(0xFF2C2B3A),
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
        return CustomPriorityPickerDialog(controller: controller);
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
            Text(category, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class CustomPriorityPickerDialog extends StatefulWidget {
  final TaskController controller;

  CustomPriorityPickerDialog({required this.controller});

  @override
  _CustomPriorityPickerDialogState createState() =>
      _CustomPriorityPickerDialogState();
}

class _CustomPriorityPickerDialogState
    extends State<CustomPriorityPickerDialog> {
  String? _selectedPriority;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF2C2B3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            _buildPriorityDialogButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOption(String priority, Color color) {
    bool isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            priority,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityDialogButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            if (_selectedPriority != null) {
              widget.controller.selectPriority(_selectedPriority!);
              Navigator.pop(context);
            }
          },
          child: Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class CustomDatePickerDialog extends StatelessWidget {
  final TaskController controller;

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
            Text('Select Date', style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(2101),
              focusedDay: controller.selectedDate.value,
              selectedDayPredicate: (day) => isSameDay(controller.selectedDate.value, day),
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
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            _buildDateDialogButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDialogButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      if (time != null) {
        controller.selectTime(time);
      }
    });
  }
}
