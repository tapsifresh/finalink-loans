# FinaLink Loans

Flutter Web/iOS/Android loan management app backed by Supabase.

## Core MVP

- Email/password authentication
- Responsive routing:
  - Large screens: Admin dashboard
  - Small screens: Borrower dashboard
- Borrower can apply for a loan
- Loan interest is calculated automatically by a Supabase trigger
- Borrower can view their loans
- Admin can view all loans
- Admin can approve loans
- Admin can mark loans as paid

## Supabase setup

1. Open Supabase SQL Editor.
2. Run:
   - `loan_interest_migration.sql`, or
   - `finalink_full_migration.sql`
3. Make your account an admin:

```sql
update public.profiles
set role = 'admin'
where id = 'YOUR_AUTH_USER_UUID';
```

## Flutter setup

1. Replace placeholders in `lib/main.dart`:

```dart
const String supabaseUrl = 'https://YOUR_PROJECT_REF.supabase.co';
const String supabasePublishableKey = 'YOUR_SUPABASE_PUBLISHABLE_KEY';
```

2. Install dependencies:

```powershell
flutter pub get
```

3. Run on Chrome:

```powershell
flutter run -d chrome
```

## Test flow

1. Create an account.
2. Apply for a loan with principal and term.
3. Confirm interest and total repayment are calculated.
4. Open **My Loans**.
5. Sign in as admin.
6. Open **Manage Loans**.
7. Approve a pending loan.
8. Mark an active loan as paid.

## Production setup

### Web app
- Public landing page: `lib/screens/landing/landing_page.dart`
- Auth gate: `lib/widgets/auth_gate.dart`
- Borrower app: `lib/screens/borrower/`
- Admin app: `lib/screens/admin/`
- Build: `flutter build web --release`
- Output: `build/web`

### Deploy to a free permanent link
1. GitHub Pages (recommended permanent free link):
   - Push this project to GitHub.
   - Enable GitHub Pages for the repository.
   - The included workflow `.github/workflows/deploy-web.yml` builds and deploys `build/web` on push to `main`.
2. Surge (quick free link):
   - `flutter build web --release`
   - `npx surge ./build/web finalink-loans.surge.sh`
3. Netlify Drop:
   - Drag and drop the `build/web` folder into Netlify Drop.

### Supabase production redirects
Add your production domain to Supabase Auth Redirect URLs, for example:
- `https://your-domain.com/**`
- `https://your-github-pages-url/**`

### Mobile apps
- Android package: `com.finalink.loans`
- iOS bundle id: `com.finalink.loans`
- Android build: `flutter build apk --release`
- iOS build requires macOS/Xcode: `flutter build ipa --release`
- Borrower-focused screens are the same responsive Flutter UI; use a phone-sized viewport or device for borrower testing.

### Finance-themed UI
- Teal `#0F766E`
- Blue `#1D4ED8`
- Gold `#D4AF37`
- Surface `#F8FAFC`
