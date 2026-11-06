import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import '../models/loan.dart';

import 'csv_download_stub.dart'
    if (dart.library.html) 'csv_download_web.dart' as platform;

class CsvExportService {
  static const List<String> _headers = <String>[
    'Loan ID',
    'Borrower ID',
    'Loan Type',
    'Principal Amount',
    'Interest Amount',
    'Total Repayment',
    'Remaining Balance',
    'Term (Weeks)',
    'Status',
    'Due Date',
    'Created At',
  ];

  static String loansToCsv(List<Loan> loans) {
    final rows = <List<String>>[
      _headers,
      ...loans.map((loan) => <String>[
            loan.id,
            loan.borrowerId,
            loan.loanType ?? '',
            loan.principalAmount.toStringAsFixed(2),
            (loan.interestAmount ?? 0).toStringAsFixed(2),
            (loan.totalRepayment ?? 0).toStringAsFixed(2),
            (loan.remainingBalance ?? 0).toStringAsFixed(2),
            loan.loanTermWeeks.toString(),
            loan.status,
            loan.dueDate?.toIso8601String() ?? '',
            loan.createdAt.toIso8601String(),
          ]),
    ];

    return rows.map((row) => row.map(_escapeCsv).join(',')).join('\n');
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String buildFilename() {
    final now = DateTime.now().toIso8601String().replaceAll(':', '-');
    return 'finalink_loans_export_$now.csv';
  }

  /// Returns true when a browser download was triggered.
  static Future<bool> download(String csv, String filename) async {
    if (kIsWeb) {
      platform.downloadCsvWeb(csv, filename);
      return true;
    }
    await Clipboard.setData(ClipboardData(text: csv));
    return false;
  }
}
