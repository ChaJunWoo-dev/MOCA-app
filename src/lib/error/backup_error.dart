enum BackupErrorType {
  unauth,
  noBudget,
  noExpenses,
  schema,
  network,
  unknown,
}

class BackupError implements Exception {
  final BackupErrorType type;
  final String? detail;
  const BackupError(this.type, [this.detail]);

  @override
  String toString() => 'BackupError($type${detail != null ? ': $detail' : ''})';
}

String backupErrorMessage(BackupError err) {
  switch (err.type) {
    case BackupErrorType.unauth:
      return '로그인 후 이용해 주세요';
    case BackupErrorType.noBudget:
      return '저장할 예산이 없어요';
    case BackupErrorType.noExpenses:
      return '최근 3개월 지출이 없어요';
    case BackupErrorType.schema:
      return '백업 형식이 올바르지 않아요';
    case BackupErrorType.network:
      return '네트워크 오류가 발생했어요';
    case BackupErrorType.unknown:
      return '알 수 없는 오류가 발생했어요';
  }
}
