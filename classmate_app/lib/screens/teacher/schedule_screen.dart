import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/user_provider.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  late Future<List<ScheduleItem>> _scheduleFuture;
  late String _teacherId;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _teacherId = userProvider.userId ?? '';
    _scheduleFuture = ScheduleService.getTeacherSchedule(_teacherId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Xem lịch giảng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thời khóa biểu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<ScheduleItem>>(
                future: _scheduleFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có lịch giảng dạy'));
                  } else {
                    return _buildScheduleList(snapshot.data!);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList(List<ScheduleItem> schedules) {
    // Group schedules by day
    final Map<String, List<ScheduleItem>> schedulesByDay = {};
    
    for (var schedule in schedules) {
      schedulesByDay.putIfAbsent(schedule.day, () => []);
      schedulesByDay[schedule.day]!.add(schedule);
    }

    // Sort days
    final daysOrder = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'];
    final sortedDays = schedulesByDay.keys.toList()
      ..sort((a, b) => daysOrder.indexOf(a).compareTo(daysOrder.indexOf(b)));

    return ListView.builder(
      itemCount: sortedDays.length,
      itemBuilder: (context, index) {
        final day = sortedDays[index];
        final daySchedules = schedulesByDay[day]!
          ..sort((a, b) => a.slot.compareTo(b.slot));

        return _buildDayCard(day, daySchedules);
      },
    );
  }

  Widget _buildDayCard(String day, List<ScheduleItem> schedules) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ...schedules.map((schedule) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Text('Tiết ${schedule.slot}: '),
                      Expanded(child: Text(schedule.subject)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}