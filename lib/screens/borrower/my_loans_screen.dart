import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/loan.dart';
import '../../services/loan_service.dart';

class MyLoansScreen extends StatefulWidget {
  const MyLoansScreen({super.key});

  @override
  State<MyLoansScreen> createState() => _MyLoansScreenState();
}

class _MyLoansScreenState extends State<MyLoansScreen> {
  final _loanService = LoanService();
  late Future<List<Loan>> _loansFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    _loansFuture = _loanService.fetchMyLoans(userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Loans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
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
            return const Center(child: Text('No loans yet.'));
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
                              loan.loanType ?? 'Loan',
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
                          _LoanInfo(label: 'Principal', value: '₱${loan.principalAmount.toStringAsFixed(2)}'),
                          _LoanInfo(label: 'Interest', value: '₱${(loan.interestAmount ?? 0).toStringAsFixed(2)}'),
                          _LoanInfo(label: 'Total', value: '₱${(loan.totalRepayment ?? 0).toStringAsFixed(2)}'),
                          _LoanInfo(label: 'Remaining', value: '₱${(loan.remainingBalance ?? 0).toStringAsFixed(2)}'),
                          _LoanInfo(label: 'Term', value: '${loan.loanTermWeeks} week(s)'),
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

class _LoanInfo extends StatelessWidget {
  const _LoanInfo({required this.label, required this.value});

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
