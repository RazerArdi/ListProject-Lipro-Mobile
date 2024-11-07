import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package for state management and routing
import 'package:lipro_mobile/app/modules/home/controllers/OnboardingController.dart'; // Onboarding controller to manage data

/// OnboardingScreen is the screen that shows the onboarding process of the app.
class OnboardingScreen extends StatelessWidget {
  // Get the instance of the OnboardingController using GetX's Get.find() method
  final OnboardingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting the background color of the screen to black
      backgroundColor: Colors.black,

      // AppBar with a Skip button that allows users to skip the onboarding process
      appBar: AppBar(
        backgroundColor: Colors.black, // Black background for AppBar
        elevation: 0, // No shadow for the AppBar to give a flat design
        leading: TextButton(
          onPressed: () => Get.offNamed('/logreg'), // Navigate to the Log or Register screen when the Skip button is pressed
          child: Text(
            'SKIP', // Text for the Skip button
            style: TextStyle(color: Colors.white), // White text color for the Skip button
          ),
        ),
      ),

      // Main body of the screen with a Column for the layout
      body: Column(
        children: [
          // Expanded widget to allow the PageView to take most of the screen space
          Expanded(
            child: PageView.builder(
              itemCount: controller.onboardingData.length, // The number of pages based on onboardingData
              onPageChanged: (index) {
                controller.currentIndex.value = index; // Update the current index when the page changes
              },
              itemBuilder: (context, index) {
                // Padding for each page in the PageView
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    // Vertically center the content of the page
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(), // Adds space above the image
                      // Display the image for the current onboarding page
                      Image.asset(controller.onboardingData[index]["image"]!, height: 200),
                      SizedBox(height: 20),
                      // Display the title for the current onboarding page
                      Text(
                        controller.onboardingData[index]["title"]!,
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center, // Center the title text
                      ),
                      SizedBox(height: 20),
                      // Display the description for the current onboarding page
                      Text(
                        controller.onboardingData[index]["description"]!,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center, // Center the description text
                      ),
                      Spacer(), // Adds space below the description
                    ],
                  ),
                );
              },
            ),
          ),

          // A row displaying the page indicators (dots) to show the current page
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.onboardingData.length, // Generate a dot for each onboarding page
                  (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0), // Add horizontal margin between dots
                width: controller.currentIndex.value == index ? 12 : 8, // Larger dot for the current page
                height: 8, // Height of the dot
                decoration: BoxDecoration(
                  color: controller.currentIndex.value == index ? Colors.purple : Colors.grey, // Highlight current dot with purple color
                  borderRadius: BorderRadius.circular(4), // Make the dots rounded
                ),
              ),
            ),
          )),

          SizedBox(height: 20), // Add space between the dot indicators and the button

          // Button for navigating to the next page or getting started
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: controller.nextScreen, // Call the nextScreen method from the controller when the button is pressed
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Purple background for the button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                ),
                padding: EdgeInsets.symmetric(vertical: 12), // Vertical padding for the button
              ),
              child: Obx(() => Text(
                controller.currentIndex.value == controller.onboardingData.length - 1
                    ? 'GET STARTED' // If it's the last page, show "GET STARTED"
                    : 'NEXT', // Show "NEXT" for all other pages
                style: TextStyle(color: Colors.white, fontSize: 16), // White text color for the button label
              )),
            ),
          ),

          SizedBox(height: 20), // Add space below the button
        ],
      ),
    );
  }
}
