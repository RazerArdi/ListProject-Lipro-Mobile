import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/FocusController.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FocusScreen extends StatelessWidget {
  final FocusController controller = Get.put(FocusController());

  @override
  Widget build(BuildContext context) {
    // Get the screen height and width
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => GestureDetector(
                onTap: () => _showSetFocusTimeDialog(context),
                child: CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: controller.focusTimeRemaining.value /
                      (controller.focusTimeRemaining.value > 0
                          ? controller.focusTimeRemaining.value
                          : 1800),
                  center: Text(
                    "${(controller.focusTimeRemaining.value ~/ 60).toString().padLeft(2, '0')}:${(controller.focusTimeRemaining.value % 60).toString().padLeft(2, '0')}",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  progressColor: Colors.blue,
                ),
              )),
              const SizedBox(height: 10),

              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: controller.toggleFocusMode,
                      child: Text(controller.isFocusing.value ? "Stop" : "Start"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: controller.restartFocus,
                      child: const Text("Restart"),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overview", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Obx(() => DropdownButton<String>(
                    value: controller.selectedView.value,
                    dropdownColor: Colors.grey[800],
                    style: TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      controller.changeView(newValue!);
                    },
                    items: ["This Day", "This Week", "This Month", "This Year"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
                ],
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Y-Axis Labels (hours)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.025),
                        child: Text(
                          "${5 - index}h",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  // Bar Chart with Grid Lines
                  Expanded(
                    child: SizedBox(
                      height: screenHeight * 0.25,
                      child: CustomPaint(
                        painter: GridPainter(),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(controller.weeklyUsage.length, (index) {
                              double usage = controller.weeklyUsage[index];
                              Color barColor = usage == controller.weeklyUsage.reduce((a, b) => a > b ? a : b)
                                  ? Colors.purple
                                  : (usage == controller.weeklyUsage.reduce((a, b) => a < b ? a : b)
                                  ? Colors.green
                                  : Colors.orange);
                              int hours = (usage ~/ 3600);
                              int minutes = ((usage % 3600) ~/ 60);

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${hours}h ${minutes}m",
                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                    const SizedBox(height: 2),
                                    ClipRect(
                                      child: Container(
                                        width: (screenWidth / controller.weeklyUsage.length) - 16,
                                        height: usage * 2 > screenHeight * 0.2 ? screenHeight * 0.2 : usage * 2,
                                        color: barColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][index],
                                      style: TextStyle(
                                        color: index == 0 || index == 6 ? Colors.red : Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Applications", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const SizedBox(height: 10),

              Obx(() => ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: controller.appUsage.keys.map((appName) {
                  int usageTime = controller.appUsage[appName]!;
                  return ListTile(
                    leading: Icon(Icons.apps, color: Colors.white),
                    title: Text(appName, style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      "You spent ${usageTime ~/ 60000}m ${(usageTime % 60000) ~/ 1000}s on $appName today",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeInputField({required TextEditingController controller, required String hint}) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 2,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white54),
          counterText: '',
          filled: true,
          fillColor: Colors.grey[800],
        ),
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Method to show set focus time dialog
  void _showSetFocusTimeDialog(BuildContext context) {
    final TextEditingController hourController = TextEditingController();
    final TextEditingController minuteController = TextEditingController();
    final TextEditingController secondController = TextEditingController();

    Get.defaultDialog(
      title: "Set Focus Time",
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _timeInputField(controller: hourController, hint: "HH"),
              const SizedBox(width: 10),
              Text(":", style: TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(width: 10),
              _timeInputField(controller: minuteController, hint: "MM"),
              const SizedBox(width: 10),
              Text(":", style: TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(width: 10),
              _timeInputField(controller: secondController, hint: "SS"),
            ],
          ),
        ],
      ),
      onConfirm: () {
        int hours = int.tryParse(hourController.text) ?? 0;
        int minutes = int.tryParse(minuteController.text) ?? 0;
        int seconds = int.tryParse(secondController.text) ?? 0;

        controller.setFocusTime(hours, minutes, seconds);
        Get.back();
      },
      textConfirm: "Set Time",
      confirmTextColor: Colors.white,
      barrierDismissible: false,
    );
  }
}

// Custom painter to draw the grid lines and axes
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke;

    // Draw horizontal line for 0h (x-axis)
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);

    // Draw vertical line for y-axis
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);

    // Draw horizontal grid lines
    for (int i = 0; i <= 5; i++) {
      double y = size.height * (i / 5); // Dividing the height into 5 segments
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
