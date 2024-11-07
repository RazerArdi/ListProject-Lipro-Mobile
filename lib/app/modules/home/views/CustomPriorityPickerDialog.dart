
// CustomPriorityPickerDialog allows the user to select a priority for the task.
import 'package:flutter/material.dart';
import 'package:lipro_mobile/app/modules/home/controllers/task_controller.dart';

class CustomPriorityPickerDialog extends StatefulWidget {
  final TaskController controller;  // Reference to the controller to update the selected priority.

  CustomPriorityPickerDialog({required this.controller});

  @override
  _CustomPriorityPickerDialogState createState() =>
      _CustomPriorityPickerDialogState();
}

class _CustomPriorityPickerDialogState
    extends State<CustomPriorityPickerDialog> {
  String? _selectedPriority;  // Variable to track the selected priority.

  // Builds the dialog UI for selecting a task priority
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFF2C2B3A),  // Background color of the dialog.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),  // Rounded corners for the dialog.
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Allowing the dialog to shrink-wrap based on content.
          children: [
            Text(
              'Select Priority',  // Heading for the dialog
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 20),  // Space between heading and priority options
            GridView.count(
              crossAxisCount: 3,  // Display 3 priority options in a grid layout
              childAspectRatio: 3,  // Aspect ratio to control the size of each grid item
              crossAxisSpacing: 10,  // Horizontal spacing between grid items
              mainAxisSpacing: 10,  // Vertical spacing between grid items
              shrinkWrap: true,  // Prevents the grid from taking up extra space
              physics: NeverScrollableScrollPhysics(),  // Disables scrolling in the grid
              children: [
                _buildPriorityOption('Low', Colors.green),  // Low priority option
                _buildPriorityOption('Medium', Colors.orange),  // Medium priority option
                _buildPriorityOption('High', Colors.red),  // High priority option
              ],
            ),
            SizedBox(height: 16),
            _buildPriorityDialogButtons(),  // Buttons for saving or canceling the selection
          ],
        ),
      ),
    );
  }

  // Builds individual priority options within the grid
  Widget _buildPriorityOption(String priority, Color color) {
    bool isSelected = _selectedPriority == priority;  // Check if this priority is selected
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriority = priority;  // Set the selected priority when tapped
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.2),  // Change color based on selection
          borderRadius: BorderRadius.circular(12),  // Rounded corners for each option
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,  // Highlight selected option with a border
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            priority,  // Display priority name
            style: TextStyle(
              color: Colors.white,  // Text color for priority options
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Builds the Save and Cancel buttons in the dialog
  Widget _buildPriorityDialogButtons() {
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
            if (_selectedPriority != null) {
              widget.controller.selectPriority(_selectedPriority!);  // Save the selected priority to the controller
              Navigator.pop(context);  // Close the dialog after saving
            }
          },
          child: Text('Save', style: TextStyle(color: Colors.white)),  // Save button
        ),
      ],
    );
  }
}