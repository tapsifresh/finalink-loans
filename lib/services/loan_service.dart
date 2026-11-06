import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/loan.dart';

class LoanService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Loan> createLoan({
    required String borrowerId,
    required String loanType,
    required double principalAmount,
    required int loanTermWeeks,
  }) async {
    final response = await _client
        .from('loans')
        .insert({
          'borrower_id': borrowerId,
          'loan_type': loanType,
          'principal_amount': principalAmount,
          'loan_term_weeks': loanTermWeeks,
        })
        .select()
        .single();

    return Loan.fromMap(response);
  }

  Future<List<Loan>> fetchMyLoans(String userId) async {
    final response = await _client
        .from('loans')
        .select()
        .eq('borrower_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => Loan.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<List<Loan>> fetchAllLoans() async {
    final response = await _client
        .from('loans')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((row) => Loan.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> approveLoan(String loanId, int termWeeks) async {
    final dueDate = DateTime.now()
        .toUtc()
        .add(Duration(days: termWeeks * 7))
        .toIso8601String();

    await _client.from('loans').update({
      'status': 'Active',
      'due_date': dueDate,
    }).eq('id', loanId);
  }

  Future<void> markPaid(String loanId) async {
    await _client.from('loans').update({
      'status': 'Paid',
      'remaining_balance': 0,
    }).eq('id', loanId);
  }

  Future<void> markOverdue(String loanId) async {
    await _client.from('loans').update({
      'status': 'Overdue',
    }).eq('id', loanId);
  }
}
