import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lipro_mobile/app/modules/home/controllers/SupportUsController.dart';

class SupportUsView extends GetView<SupportUsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Support Our Mission',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
                    fit: BoxFit.cover,
                    color: Colors.black.withOpacity(0.6),
                    colorBlendMode: BlendMode.darken,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Every Support Counts',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Help Us Build a Better Future',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSupportTiers(),
                  SizedBox(height: 24),
                  _buildSupportForm(),
                  SizedBox(height: 24),
                  _buildTransferProofUpload(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTiers() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, Colors.grey[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support Tiers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTierCard('Bronze', '\$10', Icons.star_border),
              _buildTierCard('Silver', '\$50', Icons.star_half),
              _buildTierCard('Gold', '\$100', Icons.star),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierCard(String title, String amount, IconData icon) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 40),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            amount,
            style: TextStyle(color: Colors.green, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportForm() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey[900]!, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Donation Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.nameController,
              label: 'Full Name',
              validator: controller.validateName,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.emailController,
              label: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.amountController,
              label: 'Donation Amount',
              keyboardType: TextInputType.number,
              validator: controller.validateAmount,
              prefixText: '\$ ',
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: controller.messageController,
              label: 'Optional Message',
              maxLines: 3,
              optional: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferProofUpload() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple[900]!, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Upload Transfer Proof',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Obx(() => controller.pickedImage.value != null
              ? Column(
            children: [
              Image.file(
                controller.pickedImage.value!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.pickImage,
                    icon: Icon(Icons.refresh),
                    label: Text('Change Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                ],
              )
            ],
          )
              : GestureDetector(
            onTap: controller.pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent, width: 2),
                image: controller.pickedImage.value != null
                    ? DecorationImage(
                  image: FileImage(controller.pickedImage.value!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Tap to Upload Transfer Proof',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
          SizedBox(height: 24),
          Obx(() => ElevatedButton(
            onPressed: controller.isSubmitting.value
                ? null
                : (controller.pickedImage.value != null
                ? controller.submitSupport
                : null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: controller.isSubmitting.value
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
              'Support Now',
              style: TextStyle(fontSize: 16),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String? prefixText,
    bool optional = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: optional ? null : validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefixText,
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}