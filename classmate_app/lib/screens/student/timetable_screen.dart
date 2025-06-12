import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/schedule_service.dart';
import '../../provider/user_provider.dart';

class ThoiKhoaBieuScreen extends StatefulWidget {
  const ThoiKhoaBieuScreen({super.key});

  @override
  State<ThoiKhoaBieuScreen> createState() => _ThoiKhoaBieuScreenState();
}

class _ThoiKhoaBieuScreenState extends State<ThoiKhoaBieuScreen> {
  Map<String, List<Map<String, dynamic>>> scheduleByDay = {};
  bool isLoading = true;
  String? classId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      if (provider.role == 'student' && provider.classId != null) {
        classId = provider.classId;
        loadSchedule();
      } else {
        // Không phải học sinh hoặc thiếu classId
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> loadSchedule() async {
    try {
      final grouped = await ScheduleService.getScheduleByClass(classId!);
      setState(() {
        scheduleByDay = grouped;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi tải lịch: $e');
      setState(() => isLoading = false);
    }
  }

  Widget _buildDaySchedule(String day, List<Map<String, dynamic>> subjects) {
    final subjectList = subjects.map((s) => 'Tiết ${s['slot']}: ${s['subject']}').join(' - ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$day: $subjectList',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          classId != null ? 'Thời khóa biểu - Lớp $classId' : 'Thời khóa biểu',
        ),
        backgroundColor: Colors.deepPurple.shade100,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : classId == null
                ? const Center(child: Text('Không xác định được lớp học'))
                : scheduleByDay.isEmpty
                    ? const Center(child: Text('Không có dữ liệu thời khóa biểu'))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thời khóa biểu',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView(
                              children: scheduleByDay.entries
                                  .map((e) => _buildDaySchedule(e.key, e.value))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}
