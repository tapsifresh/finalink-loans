# FinaLink Loans — Go-to-Market and White-Label Plan

## 1. Product Positioning
FinaLink Loans is a ready-to-deploy loan management portal for small lenders, cooperatives, pawnshops, salary-loan providers, and microfinance teams. It includes a public marketing site, borrower portal, admin dashboard, Supabase backend, interest automation, and Android app packaging.

## 2. Core Value Proposition
- Faster loan intake and approval
- Automated interest and repayment calculation
- Borrower self-service status tracking
- Admin visibility over pending, active, and paid loans
- Web + mobile access
- White-label ready: logo, colors, copy, domain, and Supabase project can be changed per client

## 3. Target Customers
### Primary
- Small lending businesses
- Salary-loan providers
- Pawnshop/lending kiosks
- Cooperatives and credit unions
- Microfinance startups
- HR departments offering employee loans

### Secondary
- Freelance loan brokers
- Accounting/bookkeeping firms serving lenders
- Local finance consultants

## 4. Offer Packages
### Starter — Web Only
- Landing page + borrower/admin web app
- Supabase setup
- Basic branding
- 1 admin user
- 30-day support

### Pro — Web + Android
- Everything in Starter
- Branded Android app
- Borrower-focused mobile experience
- Play Store publishing assistance
- 60-day support

### White-Label Agency Package
- Full rebrand for client loan business
- Custom domain
- Custom interest rules
- Custom forms/documents
- Multi-admin setup
- Training and handover

## 5. Pricing Ideas
- Starter: $299–$799 one-time
- Pro: $799–$1,999 one-time
- White-label: $1,500–$5,000+
- Optional monthly support: $49–$199/month
- Optional hosting/setup: $29–$99/month

## 6. Marketing Channels
### Fastest
- Facebook groups for small business owners
- Local lending/finance communities
- LinkedIn outreach to microfinance founders
- Direct outreach to pawnshops and cooperatives
- WhatsApp/Telegram business communities
- Freelance platforms: Fiverr, Upwork, Contra

### Content
- “How to automate your loan business” posts
- Demo videos showing apply → approve → paid flow
- Before/after spreadsheets vs. portal
- Case studies from first clients
- Short TikTok/Reels demos

### SEO / Long-Tail
- Loan management software for small lenders
- Microfinance loan tracking app
- Borrower portal for lending business
- Loan interest calculator app
- White-label loan management system

## 7. Sales Pitch
“Stop tracking loans in notebooks and spreadsheets. FinaLink gives your borrowers a professional portal and gives you a clean admin dashboard to approve, track, and mark loans paid — with automated interest and a mobile app.”

## 8. Demo Flow for Sales
1. Show landing page
2. Borrower applies for a 1/2/4-week loan
3. Admin sees pending loan
4. Admin approves loan
5. Borrower sees active status
6. Admin marks loan paid
7. Borrower sees paid status
8. Show mobile app

## 9. White-Label / Multi-Client Strategy
For each loan business, create:
- New Supabase project
- New branding: logo, colors, business name
- New domain or subdomain
- New Android app name/package ID
- Optional custom interest rules
- Optional custom loan terms and documents

This keeps client data isolated and makes the product feel custom.

## 10. Records and Tracking for Loan Business Owners
Current system stores:
- Borrower profiles
- Loan applications
- Principal, term, interest, total repayment, remaining balance
- Loan status: Pending, Active, Paid, Overdue
- Created dates

For spreadsheet-style reporting, owners can:
- Export from Supabase Table Editor as CSV
- Use SQL queries to generate reports
- Connect Google Sheets via Supabase API or scheduled export
- Add an in-app “Export to CSV” button later

Recommended future feature:
- Admin “Export Loans” button generating CSV for Excel/Google Sheets

## 11. Portfolio Use
Yes. This project works well as a portfolio piece because it demonstrates:
- Flutter Web + Android
- Supabase Auth + RLS
- Role-based routing
- Loan lifecycle workflow
- Responsive UI
- Production deployment setup

## 12. Next Business Steps
1. Deploy web build to a permanent free link
2. Record a 60-second demo video
3. Create 3 branded variants for different loan business names
4. Offer setup to 3 beta clients at discounted price
5. Add CSV export and overdue reminders
6. Add payment history and borrower documents
