import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lipro_mobile/app/modules/home/controllers/UserControllers/FocusController.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// FocusScreen adalah halaman utama yang menampilkan data tentang sesi fokus dan statistik penggunaan aplikasi
class FocusScreen extends StatelessWidget {
  final FocusController controller = Get.put(FocusController()); // Menginisialisasi FocusController dengan Get.put

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tinggi dan lebar layar perangkat
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black, // Mengatur latar belakang halaman menjadi hitam
      body: SingleChildScrollView( // Membuat halaman scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding di sekitar konten
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Menyusun elemen secara vertikal
            children: [
              // CircularPercentIndicator digunakan untuk menampilkan indikator waktu fokus
              Obx(() => GestureDetector(
                onTap: () => _showSetFocusTimeDialog(context), // Menampilkan dialog untuk set waktu fokus ketika indikator diklik
                child: CircularPercentIndicator(
                  radius: 100.0, // Mengatur radius indikator
                  lineWidth: 10.0, // Mengatur ketebalan garis indikator
                  percent: controller.focusTimeRemaining.value /
                      (controller.focusTimeRemaining.value > 0
                          ? controller.focusTimeRemaining.value
                          : 1800), // Menghitung persentase waktu yang tersisa
                  center: Text(
                    "${(controller.focusTimeRemaining.value ~/ 60).toString().padLeft(2, '0')}:${(controller.focusTimeRemaining.value % 60).toString().padLeft(2, '0')}", // Menampilkan waktu yang tersisa dalam format MM:SS
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  progressColor: Colors.blue, // Warna progress indikator
                ),
              )),
              const SizedBox(height: 10),

              // Button untuk mulai/stop fokus dan restart sesi fokus
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: controller.toggleFocusMode, // Menangani toggle fokus
                      child: Text(controller.isFocusing.value ? "Stop" : "Start"), // Mengubah teks tombol berdasarkan status fokus
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: controller.restartFocus, // Tombol untuk memulai ulang sesi fokus
                      child: const Text("Restart"),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 20),

              // Dropdown untuk memilih periode tampilan statistik (Hari Ini, Minggu Ini, Bulan Ini, Tahun Ini)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Overview", style: TextStyle(color: Colors.white, fontSize: 18)),
                  Obx(() => DropdownButton<String>(
                    value: controller.selectedView.value, // Menampilkan pilihan yang dipilih
                    dropdownColor: Colors.grey[800],
                    style: TextStyle(color: Colors.white),
                    onChanged: (String? newValue) {
                      controller.changeView(newValue!); // Mengubah periode tampilan statistik
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

              // Menampilkan grafik bar untuk statistik mingguan penggunaan
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kolom untuk label sumbu Y (jam)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.025),
                        child: Text(
                          "${5 - index}h", // Label jam untuk sumbu Y
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  // Grafik bar dengan garis grid
                  Expanded(
                    child: SizedBox(
                      height: screenHeight * 0.25,
                      child: CustomPaint(
                        painter: GridPainter(), // Menggambar grid
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal, // Membuat grafik scrollable secara horizontal
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(controller.weeklyUsage.length, (index) {
                              double usage = controller.weeklyUsage[index];
                              Color barColor = usage == controller.weeklyUsage.reduce((a, b) => a > b ? a : b)
                                  ? Colors.purple
                                  : (usage == controller.weeklyUsage.reduce((a, b) => a < b ? a : b)
                                  ? Colors.green
                                  : Colors.orange); // Menentukan warna berdasarkan penggunaan tertinggi dan terendah
                              int hours = (usage ~/ 3600); // Menghitung jam dari total detik
                              int minutes = ((usage % 3600) ~/ 60); // Menghitung menit

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${hours}h ${minutes}m", // Menampilkan jam dan menit
                                      style: TextStyle(color: Colors.white, fontSize: 10),
                                    ),
                                    const SizedBox(height: 2),
                                    ClipRect(
                                      child: Container(
                                        width: (screenWidth / controller.weeklyUsage.length) - 16,
                                        height: usage * 2 > screenHeight * 0.2 ? screenHeight * 0.2 : usage * 2, // Menentukan tinggi bar
                                        color: barColor, // Menentukan warna bar
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][index], // Menampilkan hari dalam minggu
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

              // Menampilkan daftar aplikasi dan waktu yang dihabiskan untuk setiap aplikasi
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Applications", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              const SizedBox(height: 10),

              Obx(() => ListView(
                physics: NeverScrollableScrollPhysics(), // Menonaktifkan scroll di dalam ListView
                shrinkWrap: true,
                children: controller.appUsage.keys.map((appName) {
                  int usageTime = controller.appUsage[appName]!;
                  return ListTile(
                    leading: Icon(Icons.apps, color: Colors.white),
                    title: Text(appName, style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      "You spent ${usageTime ~/ 60000}m ${(usageTime % 60000) ~/ 1000}s on $appName today", // Menampilkan waktu penggunaan aplikasi
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

  // Widget untuk input waktu (jam, menit, detik)
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

  // Menampilkan dialog untuk mengatur waktu fokus
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
              _timeInputField(controller: hourController, hint: "HH"), // Input untuk jam
              const SizedBox(width: 10),
              Text(":", style: TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(width: 10),
              _timeInputField(controller: minuteController, hint: "MM"), // Input untuk menit
              const SizedBox(width: 10),
              Text(":", style: TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(width: 10),
              _timeInputField(controller: secondController, hint: "SS"), // Input untuk detik
            ],
          ),
        ],
      ),
      onConfirm: () {
        int hours = int.tryParse(hourController.text) ?? 0;
        int minutes = int.tryParse(minuteController.text) ?? 0;
        int seconds = int.tryParse(secondController.text) ?? 0;

        controller.setFocusTime(hours, minutes, seconds); // Mengatur waktu fokus berdasarkan input
        Get.back();
      },
      textConfirm: "Set Time",
      confirmTextColor: Colors.white,
      barrierDismissible: false,
    );
  }
}

// Custom painter untuk menggambar garis grid dan sumbu pada grafik
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke;

    // Menggambar garis horizontal untuk sumbu X
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), paint);

    // Menggambar garis vertikal untuk sumbu Y
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);

    // Menggambar garis grid horizontal
    for (int i = 0; i <= 5; i++) {
      double y = size.height * (i / 5); // Membagi tinggi menjadi 5 bagian
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
