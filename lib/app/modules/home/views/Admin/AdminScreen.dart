import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lipro_mobile/app/modules/home/controllers/AdminController.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminAppBar.dart';
import 'package:lipro_mobile/app/modules/home/views/Admin/AdminBottomBar.dart';


class AdminScreen extends StatelessWidget {
  final AdminController controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AdminAppBar(
        title: 'Admin Dashboard',
        showCrudActions: true, // Show CRUD buttons
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: 24),
              _buildMetricsGrid(),
              const SizedBox(height: 24),
              _buildFeedbackChart(),
              const SizedBox(height: 24),
              _buildRecentActivitySection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdminBottomBar(),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.admin_panel_settings, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back, Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Here\'s an overview of your platform',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Obx(() => GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildMetricCard(
          title: 'Total Users',
          value: controller.totalUsers.value.toString(),
          icon: Icons.people,
          color: Colors.green,
        ),
        _buildMetricCard(
          title: 'Pending Feedbacks',
          value: controller.pendingFeedbacks.value.toString(),
          icon: Icons.pending,
          color: Colors.orange,
        ),
        _buildMetricCard(
          title: 'Resolved Feedbacks',
          value: controller.resolvedFeedbacks.value.toString(),
          icon: Icons.check_circle,
          color: Colors.blue,
        ),
        _buildMetricCard(
          title: 'Active Sessions',
          value: '24',
          icon: Icons.timer,
          color: Colors.purple,
        ),
      ],
    ));
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackChart() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Feedback Status Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() => PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: controller.pendingFeedbacks.value.toDouble(),
                    color: Colors.orange,
                    title: 'Pending',
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: controller.resolvedFeedbacks.value.toDouble(),
                    color: Colors.green,
                    title: 'Resolved',
                    radius: 60,
                  ),
                ],
                centerSpaceRadius: 40,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, __) => Divider(color: Colors.grey[800]),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                  ),
                ),
                title: Text(
                  'New user feedback submitted',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '2 hours ago',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}