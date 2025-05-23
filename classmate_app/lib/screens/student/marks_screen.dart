import 'package:flutter/material.dart';

class DiemSoScreen extends StatefulWidget {
  @override
  _DiemSoScreenState createState() => _DiemSoScreenState();
}

class _DiemSoScreenState extends State<DiemSoScreen> {
  final List<String> students = ['Nguyễn Văn A', 'Trần Thị B', 'Lê Hoàng C'];
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    for (var student in students) {
      controllers[student] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void saveScores() {
    controllers.forEach((student, controller) {
      print('Điểm của $student là: ${controller.text}');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã lưu điểm thành công!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xem điểm số'),
        backgroundColor: Colors.deepPurple.shade100,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nhập điểm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            student,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: controllers[student],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Điểm',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveScores,
        backgroundColor: Colors.deepPurple.shade100,
        child: Icon(Icons.save, color: Colors.black),
      ),
    );
  }
}
