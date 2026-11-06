class Loan {
  final String id;
  final String borrowerId;
  final String? loanType;
  final double principalAmount;
  final int loanTermWeeks;
  final double? interestAmount;
  final double? totalRepayment;
  final double? remainingBalance;
  final String status;
  final DateTime? dueDate;
  final DateTime createdAt;

  const Loan({
    required this.id,
    required this.borrowerId,
    required this.loanType,
    required this.principalAmount,
    required this.loanTermWeeks,
    required this.interestAmount,
    required this.totalRepayment,
    required this.remainingBalance,
    required this.status,
    required this.dueDate,
    required this.createdAt,
  });

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['id'] as String,
      borrowerId: map['borrower_id'] as String,
      loanType: map['loan_type'] as String?,
      principalAmount: (map['principal_amount'] as num).toDouble(),
      loanTermWeeks: map['loan_term_weeks'] as int,
      interestAmount: (map['interest_amount'] as num?)?.toDouble(),
      totalRepayment: (map['total_repayment'] as num?)?.toDouble(),
      remainingBalance: (map['remaining_balance'] as num?)?.toDouble(),
      status: map['status'] as String,
      dueDate: map['due_date'] == null
          ? null
          : DateTime.parse(map['due_date'] as String),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'borrower_id': borrowerId,
      'loan_type': loanType,
      'principal_amount': principalAmount,
      'loan_term_weeks': loanTermWeeks,
    };
  }
}
