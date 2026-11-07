import 'package:flutter/material.dart';

import '../../models/loan.dart';
import '../../services/csv_export_service.dart';
import '../../services/loan_service.dart';

class LoanManagementScreen extends StatefulWidget {
  const LoanManagementScreen({super.key});

  @override
  State<LoanManagementScreen> createState() => _LoanManagementScreenState();
}

class _LoanManagementScreenState extends State<LoanManagementScreen> {
  final _loanService = LoanService();
  late Future<List<Loan>> _loansFuture;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _loansFuture = _loanService.fetchAllLoans();
    setState(() {});
  }

  Future<void> _approve(Loan loan) async {
    try {
      await _loanService.approveLoan(loan.id, loan.loanTermWeeks);
      _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Approve failed: $e')),
        );
      }
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _isExporting = true);
    try {
      final loans = await _loanService.fetchAllLoans();
      if (loans.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No loans to export.')),
          );
        }
        return;
      }

      final csv = CsvExportService.loansToCsv(loans);
      final filename = CsvExportService.buildFilename();
      final downloaded = await CsvExportService.download(csv, filename);

      if (!mounted) return;
      if (downloaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported $filename')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CSV copied to clipboard. Paste it into Excel or Google Sheets.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  Future<void> _markPaid(Loan loan) async {
    try {
      await _loanService.markPaid(loan.id);
      _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mark paid failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Management'),
        actions: [
          IconButton(
            icon: _isExporting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download),
            tooltip: 'Export loans to CSV',
            onPressed: _isExporting ? null : _exportCsv,
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),
      body: FutureBuilder<List<Loan>>(
        future: _loansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final loans = snapshot.data ?? [];
          if (loans.isEmpty) {
            return const Center(child: Text('No loans found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              final statusColor = switch (loan.status) {
                'Paid' => Colors.green,
                'Active' => Colors.blue,
                'Overdue' => Colors.red,
                _ => Colors.orange,
              };

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Loan #${loan.id.substring(0, 8)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          Chip(
                            label: Text(loan.status),
                            backgroundColor: statusColor.withOpacity(0.12),
                            labelStyle: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                            side: BorderSide(color: statusColor.withOpacity(0.3)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 24,
                        runSpacing: 8,
                        children: [
                          _InfoItem(label: 'Borrower', value: loan.borrowerId.substring(0, 8)),
                          _InfoItem(label: 'Type', value: loan.loanType ?? 'N/A'),
                          _InfoItem(label: 'Principal', value: '₱${loan.principalAmount.toStringAsFixed(2)}'),
                          _InfoItem(label: 'Interest', value: '₱${(loan.interestAmount ?? 0).toStringAsFixed(2)}'),
                          _InfoItem(label: 'Total', value: '₱${(loan.totalRepayment ?? 0).toStringAsFixed(2)}'),
                          _InfoItem(label: 'Remaining', value: '₱${(loan.remainingBalance ?? 0).toStringAsFixed(2)}'),
                          _InfoItem(label: 'Term', value: '${loan.loanTermWeeks} week(s)'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (loan.status == 'Pending')
                            FilledButton.icon(
                              onPressed: () => _approve(loan),
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                            ),
                          if (loan.status == 'Active')
                            FilledButton.icon(
                              onPressed: () => _markPaid(loan),
                              icon: const Icon(Icons.payments),
                              label: const Text('Mark Paid'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
