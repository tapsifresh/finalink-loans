import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'loan_application_screen.dart';
import 'my_loans_screen.dart';

class BorrowerDashboard extends StatelessWidget {
  const BorrowerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FinaLink Borrower Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'Borrower account',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Quick actions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 260,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.add_card, color: Theme.of(context).colorScheme.primary, size: 36),
                          const SizedBox(height: 12),
                          Text('Apply for Loan', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          const Text('Submit a new loan application and choose your preferred term.'),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const LoanApplicationScreen()),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Apply Now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 260,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.receipt_long, color: Theme.of(context).colorScheme.secondary, size: 36),
                          const SizedBox(height: 12),
                          Text('My Loans', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          const Text('View loan status, repayment amount, and payment progress.'),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const MyLoansScreen()),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('View Loans'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

