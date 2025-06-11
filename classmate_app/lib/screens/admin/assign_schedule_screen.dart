import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AssignScheduleScreen extends StatefulWidget {
  const AssignScheduleScreen({super.key});

  @override
  State<AssignScheduleScreen> createState() => _AssignScheduleScreenState();
}

class _AssignScheduleScreenState extends State<AssignScheduleScreen> {
  static final String _baseUrl = kIsWeb
      ? 'http://localhost:8080'
      : 'http://10.0.2.2:8080';

  List<dynamic> schedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/schedules/schedules'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          schedules = data is List ? data : data['data'] ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load schedules');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm nhóm các môn học theo ngày
  Map<String, List<dynamic>> _groupByDay(List<dynamic> dailySchedules) {
    final Map<String, List<dynamic>> grouped = {};
    
    for (var item in dailySchedules) {
      final day = item['day'];
      if (!grouped.containsKey(day)) {
        grouped[day] = [];
      }
      grouped[day]!.add(item);
    }
    
    // Sắp xếp các môn trong mỗi ngày theo slot
    grouped.forEach((day, subjects) {
      subjects.sort((a, b) => (a['slot'] as int).compareTo(b['slot'] as int));
    });
    
    return grouped;
  }

  Widget _buildDaySchedule(String day, List<dynamic> subjects) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // Hiển thị các môn học theo slot
            for (var subject in subjects)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('Tiết ${subject['slot']}: ${subject['subject']}'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSchedule(Map<String, dynamic> schedule) {
    final classId = schedule['classId'] ?? 'Chưa rõ lớp';
    final week = schedule['week'] ?? 'Tuần không xác định';
    final dailySchedules = schedule['schedule'] as List<dynamic>? ?? [];

    // Nhóm các môn học theo ngày
    final groupedSchedules = _groupByDay(dailySchedules);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lớp: $classId - $week',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Hiển thị các ngày theo thứ tự từ Thứ Hai đến Thứ Sáu
            if (groupedSchedules.containsKey('Thứ Hai'))
              _buildDaySchedule('Thứ Hai', groupedSchedules['Thứ Hai']!),
            if (groupedSchedules.containsKey('Thứ Ba'))
              _buildDaySchedule('Thứ Ba', groupedSchedules['Thứ Ba']!),
            if (groupedSchedules.containsKey('Thứ Tư'))
              _buildDaySchedule('Thứ Tư', groupedSchedules['Thứ Tư']!),
            if (groupedSchedules.containsKey('Thứ Năm'))
              _buildDaySchedule('Thứ Năm', groupedSchedules['Thứ Năm']!),
            if (groupedSchedules.containsKey('Thứ Sáu'))
              _buildDaySchedule('Thứ Sáu', groupedSchedules['Thứ Sáu']!),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sắp xếp lịch học'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : schedules.isEmpty
              ? const Center(child: Text('Không có thời khóa biểu nào'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    return _buildClassSchedule(schedules[index]);
                  },
                ),
    );
  }
}