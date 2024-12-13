import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lipro_mobile/app/modules/home/Model/FeedbackModel.dart';
import 'package:lipro_mobile/app/modules/home/controllers/AdminFeedbackController.dart';
import 'package:lipro_mobile/app/routes/app_pages.dart';

class AdminFeedback extends StatelessWidget {
  final AdminFeedbackController controller = Get.put(AdminFeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Feedbacks', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          );
        }

        if (controller.feedbackList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.feedback_outlined,
                  size: 100,
                  color: Colors.grey.shade300,
                ),
                SizedBox(height: 20),
                Text(
                  'No feedbacks received yet',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Feedback List
            Expanded(
              child: ListView.builder(
                itemCount: controller.feedbackList.length,
                itemBuilder: (context, index) {
                  var feedback = controller.feedbackList[index];
                  return _buildFeedbackCard(context, feedback);
                },
              ),
            ),

            // Response Section
            Obx(() => controller.selectedFeedback.value != null
                ? _buildResponseSection()
                : SizedBox.shrink()),
          ],
        );
      }),
    );
  }


  Widget _buildFeedbackCard(BuildContext context, FeedbackModel feedback) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                feedback.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(feedback.status),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                feedback.status.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(
              feedback.email,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            SizedBox(height: 8),
            Text(
              feedback.message,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat('dd MMM yyyy, HH:mm').format(feedback.timestamp),
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.reply, color: Colors.blueAccent),
              onPressed: () => controller.selectFeedbackForResponse(feedback),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _showDeleteConfirmation(context, feedback.id!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.responseController,
              decoration: InputDecoration(
                hintText: 'Write your response...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed: controller.respondToFeedback,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Send Response'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String feedbackId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Feedback'),
        content: Text('Are you sure you want to delete this feedback?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteFeedback(feedbackId);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in-progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
