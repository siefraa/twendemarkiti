# 🛒 Twende Markiti v2.0
### Soko Lako la Mtandaoni · Your Complete Online Market App

---

## 📱 Overview

**Twende Markiti** is a full-featured Flutter e-commerce application with two sides:
- **👤 Customer App** — Browse, purchase, and track orders
- **🔧 Admin Panel** — Complete store management dashboard

Built with Flutter 3.16+, Provider state management, and a dark-themed East African design aesthetic.

---

## ✨ Features

### 👤 Customer Side
| Screen | Features |
|---|---|
| 🌍 Language Selection | Swahili 🇹🇿, English 🇬🇧, French 🇫🇷, Arabic 🇸🇦 |
| 🔐 Login / Register | Email, Phone, Google, Facebook • Admin/Customer roles |
| 🏠 Home | Carousel banners, categories, flash sale countdown, featured products |
| 🏪 Shop | Filter by category, search, sort (price/rating/name), grid view |
| 📦 Product Detail | Images, description, nutrition, ratings/reviews, quantity picker |
| 🛒 Cart | Swipe to remove, coupon codes, payment methods, order summary |
| 📋 Orders | Order tracking with status steps, history, cancel/reorder |
| 🔔 Notifications | Real-time alerts with read/unread state |
| 👤 Profile | Stats, loyalty points, addresses, settings, logout |

### 🔧 Admin Side
| Screen | Features |
|---|---|
| 📊 Dashboard | Revenue stats, weekly chart, quick actions, recent orders |
| 📦 Orders | All orders, status management, filter by status, update in realtime |
| 🏪 Products | CRUD operations, stock management, category filter, search |
| 👥 Customers | Customer list, activate/deactivate, spending stats |
| ⚙️ Settings | Store config, payment setup, delivery zones, language, security |

### 🌍 Internationalization
- **Kiswahili** (default) — Full app translation
- **English** — Complete translation
- **Français** — Framework ready
- **العربية** — Framework ready (RTL support)

### 💳 Payment Methods
- 📱 M-Pesa (Tanzania)
- 📲 Airtel Money
- 💳 Bank Card (Visa/Mastercard)
- 💵 Cash on Delivery
- 🏦 Bank Transfer

---

## 🗂 Project Structure

```
lib/
├── main.dart                          # Entry point + routing + providers
├── l10n/
│   ├── app_sw.arb                     # Kiswahili translations (100+ strings)
│   └── app_en.arb                     # English translations (100+ strings)
├── models/
│   └── app_models.dart                # All data models
├── providers/
│   └── app_providers.dart             # 8 ChangeNotifier providers
├── utils/
│   ├── app_theme.dart                 # Design system, colors, typography
│   └── seed_data.dart                 # Demo data (12 products, categories)
├── widgets/
│   └── common_widgets.dart            # Reusable UI components
└── screens/
    ├── auth/
    │   ├── splash_screen.dart
    │   ├── language_screen.dart
    │   ├── login_screen.dart
    │   └── register_screen.dart
    ├── customer/
    │   ├── shell_screens.dart          # Bottom nav + notifications
    │   ├── home_screen.dart
    │   ├── shop_screen.dart
    │   ├── product_detail_screen.dart
    │   ├── cart_screen.dart
    │   └── orders_profile_screen.dart
    └── admin/
        ├── admin_dashboard_screen.dart
        └── admin_screens.dart          # Orders, Products, Customers, Settings
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.16+
- Dart 3.2+
- Android Studio / VS Code

### Installation

```bash
# 1. Navigate to project
cd twende_markiti

# 2. Install dependencies
flutter pub get

# 3. Generate localizations
flutter gen-l10n

# 4. Run app
flutter run
```

### Demo Credentials
| Role | Email | Password |
|---|---|---|
| 👤 Customer | amina@gmail.com | 123456 |
| 🔧 Admin | admin@twendemarkiti.co.tz | admin123 |

---

## 🎨 Design System

```dart
// Colors
TM.primary   = #F5A623  // Gold Orange
TM.primary2  = #FF6B35  // Coral
TM.bg        = #0A0A0F  // Deep Dark
TM.card      = #141420  // Card Dark
TM.green     = #00D4AA  // Success
TM.red       = #FF4757  // Error / Sale

// Admin Colors
TM.aBlue     = #3B82F6
TM.aGreen    = #10B981
TM.aYellow   = #F59E0B
TM.aPurple   = #8B5CF6
```

---

## 📦 Key Dependencies

```yaml
provider: ^6.1.1           # State management
go_router: ^13.0.1         # Navigation
google_fonts: ^6.1.0       # Typography
fl_chart: ^0.66.2          # Charts
carousel_slider: ^4.2.1    # Banners
hive_flutter: ^1.1.0       # Local storage
dio: ^5.4.0                # HTTP client
```

---

## 🔮 Future Features (Backend Integration Ready)

- [ ] Firebase Auth (Google/Facebook sign-in)
- [ ] Firestore real-time database
- [ ] Firebase Cloud Messaging (push notifications)
- [ ] M-Pesa Daraja API integration
- [ ] Google Maps delivery tracking
- [ ] Stripe/Flutterwave payment gateway
- [ ] Image upload with Firebase Storage
- [ ] Analytics dashboard with real data
- [ ] Multi-vendor marketplace support
- [ ] WhatsApp order notifications

---

## 📄 License
MIT License — Free to use for commercial projects.

---

**Built with ❤️ for East Africa 🇹🇿🇰🇪🇺🇬**
# twendemarkiti
