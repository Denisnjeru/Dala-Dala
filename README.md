<p align="center"><a href="" target="_blank"><img src="https://github.com/Denisnjeru/Dala-Dala/blob/main/logo/logo.webp" width="200" alt="Dala-Dala Logo"></a></p>

# Dala-Dala

**Dala-Dala** is a robust Enterprise Resource Planning (ERP) solution tailored for the transportation industry, including matatu operators, taxi services, ride-sharing platforms, and other vehicular fleet businesses. Designed to streamline fleet management and integrate seamlessly with financial platforms like M-Pesa and traditional banking systems, Dala-Dala empowers transportation businesses to efficiently manage their operations, track transactions, and process payments with ease.

## Key Features

### 1. Fleet Management
- **Vehicle Tracking:** Real-time GPS tracking of all vehicles in the fleet.
- **Scheduling & Dispatch:** Efficiently schedule rides and dispatch vehicles based on demand.
- **Maintenance Management:** Track vehicle maintenance schedules and automate reminders for servicing.
- **Driver Management:** Manage driver profiles, schedules, and performance metrics.

### 2. Financial Integration
- **M-Pesa Integration:** Seamlessly integrate with M-Pesa for handling mobile payments and transactions.
- **Banking Integration:** Connect with multiple banking systems to automate and record financial transactions.
- **Expense Tracking:** Monitor and categorize business expenses for accurate financial reporting.
- **Invoicing & Billing:** Generate and manage invoices for services rendered.

### 3. Payment Processing
- **Secure Transactions:** Ensure secure handling of all payment data with industry-standard encryption.
- **Multiple Payment Gateways:** Support for various payment gateways to provide flexibility to customers.
- **Automated Reconciliation:** Automatically reconcile payments with bank statements for accurate financial records.

### 4. Reporting & Analytics
- **Customizable Dashboards:** Create personalized dashboards to monitor key performance indicators (KPIs).
- **Financial Reports:** Generate comprehensive financial reports, including profit & loss statements, balance sheets, and cash flow reports.
- **Operational Analytics:** Gain insights into fleet utilization, driver performance, and customer trends.

### 5. User Management & Security
- **Role-Based Access Control:** Define user roles and permissions to ensure data security.
- **Audit Logs:** Maintain detailed logs of all system activities for accountability and compliance.
- **Data Encryption:** Protect sensitive data with advanced encryption methods.

### 6. Mobile Accessibility
- **Responsive Design:** Access Dala-Dala from any device with an internet connection.
- **Mobile App Integration:** Utilize companion mobile apps for on-the-go management and tracking.

## Technology Stack
- **Frontend:** Vue.js, React Native
- **Backend:** Python, Django, Flask
- **Database:** SQL, Azure SQL Database
- **DevOps:** Docker, Kubernetes, CI/CD pipelines
- **Integrations:** M-Pesa API, Bank APIs, Microsoft Dynamics 365 Business Central

## Getting Started

### Prerequisites
- Microsoft Dynamics 365 Business Central
- Node.js and npm
- Python 3.x 
- Docker and Docker Compose
- Access to M-Pesa and banking APIs

### Installation
1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/Dala-Dala.git
   cd Dala-Dala


### Project Structure

1. **.gitignore** 
List of blobs for git to ignore. Affects commands like git add and git clean. You may use gitignore.io to generate a clean and useful gitignore file.

2. **.alpackages/**
Folder in a Business Central project functions as a local repository for extension packages (.app files) that your project depends on, including Microsoft base extensions, third-party extensions, and your own referenced extensions. This critical directory enables the AL compiler to resolve symbol definitions from dependencies, providing IntelliSense support and ensuring proper code compilation during development.

3. **.test/**
Unit tests, integration tests… go here.