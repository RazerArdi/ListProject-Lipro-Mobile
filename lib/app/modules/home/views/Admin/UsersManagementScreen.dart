import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/Model/users_model.dart';
import 'package:lipro_mobile/app/modules/home/controllers/AdminControllers/users_controller.dart';

class UsersManagementScreen extends StatelessWidget {
  final UsersController _controller = Get.put(UsersController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch users when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchUsers();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    return _buildLoadingIndicator();
                  }

                  return _buildUserList();
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildAddUserFAB(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1E1E1E),
      title: Text(
        'User Management',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
    );
  }


  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white.withOpacity(0.9)),
        decoration: InputDecoration(
          hintText: 'Search users...',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
        onChanged: (value) {
          _controller.filterUsers(value);
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _controller.filteredUsers.length,
      itemBuilder: (context, index) {
        final user = _controller.filteredUsers[index];
        return _buildUserCard(user, context);
      },
    );
  }

  Widget _buildUserCard(UserModel user, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Text(
            user.fullName[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.email,
              style: TextStyle(color: Colors.grey.withOpacity(0.7)),
            ),
            Text(
              'Role: ${user.role}',
              style: TextStyle(color: Colors.grey.withOpacity(0.6)),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue.withOpacity(0.8)),
              onPressed: () => _showUserForm(context, user),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red.withOpacity(0.8)),
              onPressed: () => _showDeleteConfirmation(context, user),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildAddUserFAB(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(0.2),
      onPressed: () => _showUserForm(context),
      child: Icon(
        Icons.add,
        color: Colors.white.withOpacity(0.9),
      ),
    );
  }

  void _showUserForm(BuildContext context, [UserModel? existingUser]) {
    final fullNameController = TextEditingController(text: existingUser?.fullName ?? '');
    final emailController = TextEditingController(text: existingUser?.email ?? '');
    final roleController = TextEditingController(text: existingUser?.role ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          existingUser == null ? 'Add New User' : 'Edit User',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCustomTextField(
                controller: fullNameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 12),
              _buildCustomTextField(
                controller: emailController,
                labelText: 'Email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _buildCustomTextField(
                controller: roleController,
                labelText: 'Role',
                prefixIcon: Icons.work,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
            onPressed: () {
              final newUser = UserModel(
                id: existingUser?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                fullName: fullNameController.text,
                email: emailController.text,
                role: roleController.text,
                createdAt: existingUser?.createdAt ?? DateTime.now(),
              );

              if (existingUser == null) {
                _controller.addUser(newUser);
              } else {
                _controller.updateUser(newUser);
              }

              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white.withOpacity(0.9)),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.white.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Delete User',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${user.fullName}?',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.8),
            ),
            onPressed: () {
              _controller.deleteUser(user.id);
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }
}
