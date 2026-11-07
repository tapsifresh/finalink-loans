import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/loan_service.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _loanService = LoanService();

  String _loanType = 'Personal';
  int _termWeeks = 1;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _principalController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to apply.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final loan = await _loanService.createLoan(
        borrowerId: user.id,
        loanType: _loanType,
        principalAmount: double.parse(_principalController.text.trim()),
        loanTermWeeks: _termWeeks,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Loan created. Interest: ${loan.interestAmount}, Total: ${loan.totalRepayment}',
          ),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create loan: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply for Loan')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.request_quote, color: Theme.of(context).colorScheme.primary, size: 32),
                          const SizedBox(width: 12),
                          Text('New Loan Application', style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Choose your loan type, amount, and repayment term.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: _loanType,
                        decoration: const InputDecoration(
                          labelText: 'Loan Type',
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Personal', child: Text('Personal')),
                          DropdownMenuItem(value: 'Emergency', child: Text('Emergency')),
                          DropdownMenuItem(value: 'Business', child: Text('Business')),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _loanType = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _principalController,
                        decoration: const InputDecoration(
                          labelText: 'Principal Amount',
                          prefixIcon: Icon(Icons.payments_outlined),
                          prefixText: '₱ ',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          final amount = double.tryParse(value ?? '');
                          if (amount == null || amount <= 0) {
                            return 'Enter a valid amount greater than 0';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: _termWeeks,
                        decoration: const InputDecoration(
                          labelText: 'Loan Term',
                          prefixIcon: Icon(Icons.schedule_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('1 week')),
                          DropdownMenuItem(value: 2, child: Text('2 weeks')),
                          DropdownMenuItem(value: 4, child: Text('4 weeks')),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _termWeeks = value);
                        },
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isSubmitting ? null : _submit,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send),
                          label: Text(_isSubmitting ? 'Submitting...' : 'Submit Application'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
