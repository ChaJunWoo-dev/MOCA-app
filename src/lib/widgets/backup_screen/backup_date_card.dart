import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BackupDateCard extends StatelessWidget {
  final Session? session;
  final DateTime? lastBackupDate;

  const BackupDateCard({
    super.key,
    required this.session,
    this.lastBackupDate,
  });

  @override
  Widget build(BuildContext context) {
    final isLogged = session != null && !(session?.isExpired ?? true);

    return Card(
      elevation: 0,
      color: const Color(0xFFF2F4F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '최근 백업 날짜',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 14),
            isLogged
                ? _AuthBackupDateView(
                    lastBackupDate: lastBackupDate,
                  )
                : _UnAuthNoticeCard(),
          ],
        ),
      ),
    );
  }
}

class _UnAuthNoticeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock,
          size: 20,
          color: Colors.black54,
        ),
        Text(
          '로그인 후에 확인 가능해요',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _AuthBackupDateView extends StatelessWidget {
  final DateTime? lastBackupDate;

  const _AuthBackupDateView({
    required this.lastBackupDate,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      lastBackupDate == null
          ? '아직 백업 데이터가 없어요'
          : DateFormat('yyyy년 MM월 dd일 HH:mm').format(lastBackupDate!),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
    ));
  }
}
