import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/Model/users_model.dart';

class UsersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<UserModel?> selectedUser = Rx<UserModel?>(null);

  // Fetch users from Firestore
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      final querySnapshot = await _firestore.collection('users').get();
      final userList = querySnapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      users.value = userList;
      filteredUsers.value = List.from(userList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add new user to Firestore
  Future<void> addUser(UserModel user) async {
    try {
      final docRef = _firestore.collection('users').doc(user.id);
      await docRef.set(user.toMap());
      users.add(user);
      filteredUsers.add(user);
      update();
      Get.snackbar('Success', 'User added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add user: $e');
    }
  }

  // Update existing user in Firestore
  Future<void> updateUser(UserModel updatedUser) async {
    try {
      final docRef = _firestore.collection('users').doc(updatedUser.id);
      await docRef.update(updatedUser.toMap());

      int index = users.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        users[index] = updatedUser;

        // Update filtered list as well
        int filteredIndex = filteredUsers.indexWhere((user) => user.id == updatedUser.id);
        if (filteredIndex != -1) {
          filteredUsers[filteredIndex] = updatedUser;
        }
        update();
      }

      Get.snackbar('Success', 'User updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e');
    }
  }

  // Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      final docRef = _firestore.collection('users').doc(userId);
      await docRef.delete();

      users.removeWhere((user) => user.id == userId);
      filteredUsers.removeWhere((user) => user.id == userId);
      update();
      Get.snackbar('Success', 'User deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e');
    }
  }

  // Filter users based on search query
  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = List.from(users);
    } else {
      filteredUsers.value = users.where((user) {
        return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.role.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  // Select user for editing
  void selectUser(UserModel user) {
    selectedUser.value = user;
  }

  // Clear selected user
  void clearSelectedUser() {
    selectedUser.value = null;
  }
}
