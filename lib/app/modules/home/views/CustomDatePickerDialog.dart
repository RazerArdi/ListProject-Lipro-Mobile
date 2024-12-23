import 'package:flutter/material.dart';
import 'package:lipro_mobile/app/modules/home/controllers/UserControllers/task_controller.dart';
import 'package:table_calendar/table_calendar.dart';

// CustomDatePickerDialog allows the user to select a date for the task.
class CustomDatePickerDialog extends StatelessWidget {
  final TaskController controller;  // Reference to the controller to update the selected date.

  CustomDatePickerDialog({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF1F1D2B),  // Background color of the dialog
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),  // Rounded corners for the dialog
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Allowing the dialog to shrink-wrap based on content
          children: [
            Text('Select Date', style: TextStyle(color: Colors.white, fontSize: 20)),  // Heading for the dialog
            SizedBox(height: 16),  // Space between heading and calendar widget
            TableCalendar(
              firstDay: DateTime.now(),  // The earliest available date
              lastDay: DateTime(2101),  // The latest available date
              focusedDay: controller.selectedDate.value,  // The currently selected date
              selectedDayPredicate: (day) => isSameDay(controller.selectedDate.value, day),  // Predicate to check if a day is selected
              onDaySelected: (selectedDay, focusedDay) {
                controller.selectDate(selectedDay);  // Set the selected date in the controller
                Navigator.of(context).pop();  // Close the dialog
                _showTimePicker(context);  // Show the time picker after selecting the date
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
                defaultTextStyle: TextStyle(color: Colors.white),  // Text color for default days
                weekendTextStyle: TextStyle(color: Colors.white),  // Text color for weekend days
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.white70),  // Style for weekend day labels
                weekdayStyle: TextStyle(color: Colors.white70),  // Style for weekday labels
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,  // Hide the "format" button in the header
                titleCentered: true,  // Center the title in the header
                titleTextStyle: TextStyle(color: Colors.white),  // Title text color
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),  // Left chevron icon (for going back)
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),  // Right chevron icon (for going forward)
              ),
            ),
            SizedBox(height: 16),  // Space between calendar and buttons
            _buildDateDialogButtons(context),  // Buttons for saving or canceling the selection
          ],
        ),
      ),
    );
  }

  // Builds the Cancel and Save buttons for the date picker dialog
  Widget _buildDateDialogButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Space between buttons
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);  // Close the dialog without saving
          },
          child: Text('Cancel', style: TextStyle(color: Colors.white)),  // Cancel button
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);  // Close the dialog
          },
          child: Text('Save', style: TextStyle(color: Colors.white)),  // Save button
        ),
      ],
    );
  }

  // Displays the time picker after the user selects a date
  void _showTimePicker(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),  // Default initial time is the current time
    ).then((time) {
      if (time != null) {
        controller.selectTime(time);  // Save the selected time to the controller
      }
    });
  }
}