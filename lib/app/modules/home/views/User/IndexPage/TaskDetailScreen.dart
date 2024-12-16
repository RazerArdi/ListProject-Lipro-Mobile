import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> taskData;

  const TaskDetailScreen({Key? key, required this.taskData}) : super(key: key);

  // Color mapping for priority
  Color _getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle date
    Timestamp? timestamp = taskData['date'];
    DateTime taskDate = timestamp?.toDate() ?? DateTime.now();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                taskData['title'] ?? "      Task Details",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black54,
                      offset: Offset(2.0, 2.0),
                    )
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade500,
                      Colors.deepPurple.shade900,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.task_alt,
                    size: 100,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Description Card
                _buildInfoCard(
                  icon: Icons.description,
                  title: 'Description',
                  content: taskData['description'] ?? "No description provided.",
                  iconColor: Colors.blue,
                ),

                SizedBox(height: 16),

                // Additional Details
                Row(
                  children: [
                    // Date Card
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.calendar_today,
                        title: 'Due Date',
                        content: DateFormat('dd MMM yyyy').format(taskDate),
                        iconColor: Colors.green,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Priority Card
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.priority_high,
                        title: 'Priority',
                        content: taskData['priority'] ?? "Not Set",
                        iconColor: _getPriorityColor(taskData['priority']),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Category and Status
                Row(
                  children: [
                    // Category Card
                    Expanded(
                      child: _buildInfoCard(
                        icon: Icons.label,
                        title: 'Category',
                        content: taskData['category'] ?? "Uncategorized",
                        iconColor: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 16),
                    // Status Card
                    Expanded(
                      child: _buildInfoCard(
                        icon: taskData['isCompleted'] == true
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        title: 'Status',
                        content: taskData['isCompleted'] == true
                            ? "Completed"
                            : "In Progress",
                        iconColor: taskData['isCompleted'] == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create consistent info cards
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white10,
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}