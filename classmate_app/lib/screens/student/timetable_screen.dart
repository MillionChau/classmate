import 'package:flutter/material.dart';

void main() {
  runApp(ThoiKhoaBieuApp());
}

class ThoiKhoaBieuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ThoiKhoaBieuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThoiKhoaBieuScreen extends StatelessWidget {
  final List<String> tkbList = [
    'Thứ Hai: Toán - Văn - Anh',
    'Thứ Ba: Lý - Hóa - Sinh',
    'Thứ Tư: Sử - Địa - GDCD',
    'Thứ Năm: Công nghệ - Tin học',
    'Thứ Sáu: Thể dục - Âm nhạc',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          // Drawer rỗng
          ),
      appBar: AppBar(
        title: Text('Xem thời khóa biểu'),
        backgroundColor: Colors.deepPurple.shade100,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời khóa biểu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: tkbList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tkbList[index],
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
