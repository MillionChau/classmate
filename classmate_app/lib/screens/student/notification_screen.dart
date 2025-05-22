import 'package:flutter/material.dart';

void main() {
  runApp(ThongBaoApp());
}

class ThongBaoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ThongBaoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThongBaoScreen extends StatelessWidget {
  final List<String> thongBaoList = [
    'Học sinh lớp 10A1 nghỉ học ngày mai!',
    'Lịch kiểm tra giữa kỳ sẽ diễn ra vào tuần tới.',
    'Giáo viên vui lòng cập nhật điểm số trước ngày 20/03.'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          // Drawer để trống cho đúng giao diện
          ),
      appBar: AppBar(
        title: Text('Xem thông báo'),
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
              'Thông báo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: thongBaoList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.campaign_outlined, color: Colors.black54),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            thongBaoList[index],
                            style: TextStyle(fontSize: 16),
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
        onPressed: () {
          // Xử lý khi nhấn nút +
        },
        backgroundColor: Colors.deepPurple.shade100,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
