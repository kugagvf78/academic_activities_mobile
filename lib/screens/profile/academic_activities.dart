  import 'package:academic_activities_mobile/cores/widgets/appbar.dart';
  import 'package:academic_activities_mobile/screens/navigation.dart';
  import 'package:flutter/material.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';

  class AcademicActivitiesScreen extends StatelessWidget {
  final List activities;

  const AcademicActivitiesScreen({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarWidget(
        title: "Hoạt Động Học Thuật",
        action: IconButton(
          icon: const Icon(Icons.home_rounded, color: Colors.white),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigation.changeTab(0);  
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            _buildStatCard(),
            const SizedBox(height: 16),
            _buildActivitiesList(),
          ],
        ),
      ),
    );
  }

    Widget _buildStatCard() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2563EB).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Tham gia', '12', FontAwesomeIcons.calendar),
            Container(width: 1, height: 40, color: Colors.white30),
            _buildStatItem('Đạt giải', '5', FontAwesomeIcons.trophy),
            Container(width: 1, height: 40, color: Colors.white30),
            _buildStatItem('Điểm RL', '85', FontAwesomeIcons.star),
          ],
        ),
      );
    }

    Widget _buildStatItem(String label, String value, IconData icon) {
      return Column(
        children: [
          FaIcon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      );
    }

    Widget _buildActivitiesList() {
      final activities = [
        {
          'title': 'Cuộc thi Lập trình viên 2024',
          'date': '15/03/2024',
          'status': 'Đạt giải Nhì',
          'points': 15,
          'color': Colors.amber,
        },
        {
          'title': 'Hội thảo AI & Machine Learning',
          'date': '20/02/2024',
          'status': 'Hoàn thành',
          'points': 5,
          'color': Colors.blue,
        },
        {
          'title': 'Cuộc thi Khởi nghiệp 2024',
          'date': '10/01/2024',
          'status': 'Tham gia',
          'points': 3,
          'color': Colors.green,
        },
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lịch sử tham gia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          ...activities.map((activity) => _buildActivityCard(activity)).toList(),
        ],
      );
    }

    Widget _buildActivityCard(Map<String, dynamic> activity) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: activity['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.trophy,
                    color: activity['color'],
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['title'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.calendar,
                            size: 11,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            activity['date'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${activity['points']} điểm',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: activity['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                activity['status'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: activity['color'],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }