import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../utils/seed_data.dart';

// ═══════════════════════════════════════════════════════
//  TWENDE MARKITI — App-wide State Providers
// ═══════════════════════════════════════════════════════

// ── Language Provider ──────────────────────────────────
class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('sw');

  Locale get locale => _locale;
  Language get language => _localeToLang(_locale);

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void setLanguage(Language lang) {
    _locale = _langToLocale(lang);
    notifyListeners();
  }

  Language _localeToLang(Locale locale) {
    switch (locale.languageCode) {
      case 'sw': return Language.swahili;
      case 'en': return Language.english;
      case 'fr': return Language.french;
      case 'ar': return Language.arabic;
      default:   return Language.swahili;
    }
  }

  Locale _langToLocale(Language lang) {
    switch (lang) {
      case Language.swahili: return const Locale('sw');
      case Language.english: return const Locale('en');
      case Language.french:  return const Locale('fr');
      case Language.arabic:  return const Locale('ar');
    }
  }

  static const Map<Language, Map<String, String>> _meta = {
    Language.swahili: {'flag': '🇹🇿', 'name': 'Kiswahili', 'native': 'Tanzania, Kenya'},
    Language.english: {'flag': '🇬🇧', 'name': 'English',   'native': 'International'},
    Language.french:  {'flag': '🇫🇷', 'name': 'Français',  'native': 'France, Belgique'},
    Language.arabic:  {'flag': '🇸🇦', 'name': 'العربية',   'native': 'الشرق الأوسط'},
  };

  Map<String, String> getMeta(Language lang) => _meta[lang] ?? {};
}

// ── Auth Provider ──────────────────────────────────────
class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  bool _isLoading = false;
  String? _error;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.role == UserRole.admin;
  String? get error => _error;

  Future<bool> login(String email, String password, {bool asAdmin = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    // Simulate network call
    await Future.delayed(const Duration(milliseconds: 800));

    _user = asAdmin ? SeedData.demoAdmin : SeedData.demoCustomer;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    _user = AppUser(
      id: 'u_new',
      name: name,
      email: email,
      phone: phone,
      role: UserRole.customer,
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

// ── Cart Provider ──────────────────────────────────────
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? _appliedCoupon;
  double _discountPercent = 0;
  String? _selectedPayment;
  String? _selectedAddressId;

  List<CartItem> get items => List.unmodifiable(_items);
  String? get appliedCoupon => _appliedCoupon;
  String? get selectedPayment => _selectedPayment;
  String? get selectedAddressId => _selectedAddressId;

  int get count => _items.fold(0, (sum, i) => sum + i.quantity);
  double get subtotal => _items.fold(0, (sum, i) => sum + i.total);
  double get discountAmount => subtotal * (_discountPercent / 100);
  double get deliveryFee => subtotal > 15000 ? 0 : 1500;
  double get total => subtotal - discountAmount + deliveryFee;

  void add(Product product) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void updateQty(String productId, int qty) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx >= 0) {
      if (qty <= 0) {
        _items.removeAt(idx);
      } else {
        _items[idx].quantity = qty;
      }
      notifyListeners();
    }
  }

  bool applyCoupon(String code) {
    final coupon = SeedData.coupons.firstWhere(
      (c) => c.code == code.toUpperCase() && c.isValid,
      orElse: () => Coupon(
        code: '', discountPercent: 0, expiryDate: DateTime(2000), isActive: false,
      ),
    );
    if (coupon.code.isNotEmpty && (coupon.minOrder == null || subtotal >= coupon.minOrder!)) {
      _appliedCoupon = coupon.code;
      _discountPercent = coupon.discountPercent;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setPaymentMethod(String method) {
    _selectedPayment = method;
    notifyListeners();
  }

  void setAddress(String addressId) {
    _selectedAddressId = addressId;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _appliedCoupon = null;
    _discountPercent = 0;
    notifyListeners();
  }

  bool contains(String productId) => _items.any((i) => i.product.id == productId);
}

// ── Wishlist Provider ──────────────────────────────────
class WishlistProvider extends ChangeNotifier {
  final Set<String> _ids = {};

  bool contains(String id) => _ids.contains(id);
  int get count => _ids.length;
  List<Product> getProducts() => SeedData.products.where((p) => _ids.contains(p.id)).toList();

  void toggle(Product product) {
    if (_ids.contains(product.id)) {
      _ids.remove(product.id);
    } else {
      _ids.add(product.id);
    }
    notifyListeners();
  }
}

// ── Products Provider ──────────────────────────────────
class ProductsProvider extends ChangeNotifier {
  List<Product> _all = List.from(SeedData.products);
  String _selectedCategory = 'all';
  String _searchQuery = '';
  String _sortBy = 'popular';

  List<Product> get all => _all;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  List<Product> get filtered {
    var list = _all.where((p) => p.isActive).toList();
    if (_selectedCategory != 'all') {
      list = list.where((p) => p.categoryId == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) => p.name.toLowerCase().contains(q) || p.nameEn.toLowerCase().contains(q)).toList();
    }
    switch (_sortBy) {
      case 'price_asc':  list.sort((a, b) => a.price.compareTo(b.price));
      case 'price_desc': list.sort((a, b) => b.price.compareTo(a.price));
      case 'rating':     list.sort((a, b) => b.rating.compareTo(a.rating));
      case 'name':       list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  List<Product> get featured => _all.where((p) => p.isFeatured && p.isActive).take(6).toList();
  List<Product> get onSale    => _all.where((p) => p.isOnSale && p.isActive).toList();

  void setCategory(String catId) {
    _selectedCategory = catId;
    notifyListeners();
  }

  void search(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    notifyListeners();
  }

  void addProduct(Product p) {
    _all.add(p);
    notifyListeners();
  }

  void updateProduct(Product p) {
    final idx = _all.indexWhere((x) => x.id == p.id);
    if (idx >= 0) { _all[idx] = p; notifyListeners(); }
  }

  void deleteProduct(String id) {
    _all.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}

// ── Orders Provider ────────────────────────────────────
class OrdersProvider extends ChangeNotifier {
  final List<AppOrder> _orders = _generateSeedOrders();

  List<AppOrder> get all => List.unmodifiable(_orders);

  List<AppOrder> getByStatus(OrderStatus status) =>
      _orders.where((o) => o.status == status).toList();

  List<AppOrder> getByCustomer(String userId) =>
      _orders.where((o) => o.customer.id == userId).toList();

  void updateStatus(String orderId, OrderStatus newStatus) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx] = AppOrder(
        id: _orders[idx].id,
        orderNumber: _orders[idx].orderNumber,
        customer: _orders[idx].customer,
        items: _orders[idx].items,
        status: newStatus,
        paymentMethod: _orders[idx].paymentMethod,
        subtotal: _orders[idx].subtotal,
        discount: _orders[idx].discount,
        deliveryFee: _orders[idx].deliveryFee,
        total: _orders[idx].total,
        deliveryAddress: _orders[idx].deliveryAddress,
        createdAt: _orders[idx].createdAt,
      );
      notifyListeners();
    }
  }

  void placeOrder(CartProvider cart, AppUser customer) {
    final order = AppOrder(
      id: 'o${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'TM-2024-${(_orders.length + 1).toString().padLeft(4, '0')}',
      customer: customer,
      items: List.from(cart.items),
      status: OrderStatus.pending,
      paymentMethod: PaymentMethod.mpesa,
      subtotal: cart.subtotal,
      discount: cart.discountAmount,
      deliveryFee: cart.deliveryFee,
      total: cart.total,
      deliveryAddress: 'Msasani Road 14, Dar es Salaam',
      couponCode: cart.appliedCoupon,
      createdAt: DateTime.now(),
    );
    _orders.insert(0, order);
    cart.clear();
    notifyListeners();
  }

  static List<AppOrder> _generateSeedOrders() {
    final customer = SeedData.demoCustomer;
    final items1 = [
      CartItem(product: SeedData.products[0], quantity: 2),
      CartItem(product: SeedData.products[1], quantity: 1),
    ];
    final items2 = [
      CartItem(product: SeedData.products[2], quantity: 1),
      CartItem(product: SeedData.products[3], quantity: 1),
    ];
    final items3 = [
      CartItem(product: SeedData.products[6], quantity: 2),
      CartItem(product: SeedData.products[7], quantity: 1),
    ];
    return [
      AppOrder(
        id: 'o001', orderNumber: 'TM-2024-0042', customer: customer,
        items: items1, status: OrderStatus.shipping,
        paymentMethod: PaymentMethod.mpesa,
        subtotal: 9800, deliveryFee: 1500, total: 11300,
        deliveryAddress: 'Msasani Road 14, Dar es Salaam',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppOrder(
        id: 'o002', orderNumber: 'TM-2024-0038', customer: customer,
        items: items2, status: OrderStatus.delivered,
        paymentMethod: PaymentMethod.card,
        subtotal: 13200, deliveryFee: 0, total: 13200,
        deliveryAddress: 'Msasani Road 14, Dar es Salaam',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        deliveredAt: DateTime.now().subtract(const Duration(hours: 18)),
      ),
      AppOrder(
        id: 'o003', orderNumber: 'TM-2024-0031', customer: customer,
        items: items3, status: OrderStatus.pending,
        paymentMethod: PaymentMethod.airtel,
        subtotal: 20500, deliveryFee: 0, total: 20500,
        deliveryAddress: 'Samora Avenue 7, CBD',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }
}

// ── Customers Provider (Admin) ─────────────────────────
class CustomersProvider extends ChangeNotifier {
  final List<AppUser> _customers = _seedCustomers();
  String _query = '';

  List<AppUser> get all => _customers
      .where((c) => _query.isEmpty ||
          c.name.toLowerCase().contains(_query) ||
          c.email.toLowerCase().contains(_query))
      .toList();

  void search(String q) {
    _query = q.toLowerCase();
    notifyListeners();
  }

  void toggleActive(String userId) {
    final idx = _customers.indexWhere((c) => c.id == userId);
    if (idx >= 0) {
      final c = _customers[idx];
      _customers[idx] = AppUser(
        id: c.id, name: c.name, email: c.email, phone: c.phone,
        role: c.role, isActive: !c.isActive,
        totalOrders: c.totalOrders, totalSpending: c.totalSpending,
        rating: c.rating, loyaltyPoints: c.loyaltyPoints,
        membershipLevel: c.membershipLevel, createdAt: c.createdAt,
      );
      notifyListeners();
    }
  }

  static List<AppUser> _seedCustomers() => [
    AppUser(id: 'u001', name: 'Amina Hassan',  email: 'amina@gmail.com',   phone: '+255 712 345 678', role: UserRole.customer, totalOrders: 47, totalSpending: 284500, rating: 4.8, membershipLevel: 'Mteja Mkuu',  createdAt: DateTime(2023, 6, 15)),
    AppUser(id: 'u002', name: 'Hassan Omar',   email: 'hassan@gmail.com',  phone: '+255 758 234 567', role: UserRole.customer, totalOrders: 32, totalSpending: 198200, rating: 4.5, membershipLevel: 'Mteja Mkuu',  createdAt: DateTime(2023, 8, 20)),
    AppUser(id: 'u003', name: 'Fatuma Juma',   email: 'fatuma@gmail.com',  phone: '+255 784 567 890', role: UserRole.customer, totalOrders: 18, totalSpending: 87400,  rating: 4.2, membershipLevel: 'Mteja Mpya', createdAt: DateTime(2024, 1, 10), isActive: false),
    AppUser(id: 'u004', name: 'Ali Mwangi',    email: 'ali@gmail.com',     phone: '+255 743 456 789', role: UserRole.customer, totalOrders: 8,  totalSpending: 34200,  rating: 4.6, membershipLevel: 'Mteja Mpya', createdAt: DateTime(2024, 2, 5)),
    AppUser(id: 'u005', name: 'Zainab Salim',  email: 'zainab@gmail.com',  phone: '+255 712 876 543', role: UserRole.customer, totalOrders: 61, totalSpending: 421000, rating: 4.9, membershipLevel: 'Mteja Mkuu',  createdAt: DateTime(2023, 3, 22)),
  ];
}

// ── Notification Provider ──────────────────────────────
class NotificationProvider extends ChangeNotifier {
  final List<AppNotification> _notifications = _seedNotifications();

  List<AppNotification> get all => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notifications[idx] = AppNotification(
        id: _notifications[idx].id,
        title: _notifications[idx].title,
        body: _notifications[idx].body,
        emoji: _notifications[idx].emoji,
        color: _notifications[idx].color,
        createdAt: _notifications[idx].createdAt,
        isRead: true,
      );
      notifyListeners();
    }
  }

  void markAllRead() {
    for (int i = 0; i < _notifications.length; i++) {
      final n = _notifications[i];
      _notifications[i] = AppNotification(
        id: n.id, title: n.title, body: n.body,
        emoji: n.emoji, color: n.color, createdAt: n.createdAt, isRead: true,
      );
    }
    notifyListeners();
  }

  static List<AppNotification> _seedNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(id: 'n1', title: 'Agizo linasafirishwa!', body: 'Agizo #TM-2024-0042: Dereva wako yuko karibu. Tarajiwa saa 1 ijayo.', emoji: '🚚', color: const Color(0xFF3B82F6), createdAt: now.subtract(const Duration(minutes: 15))),
      AppNotification(id: 'n2', title: 'Agizo limefikishwa!', body: '#TM-2024-0038 limefikishwa. Piga kura bidhaa zako.', emoji: '✅', color: const Color(0xFF10B981), createdAt: now.subtract(const Duration(hours: 2))),
      AppNotification(id: 'n3', title: 'Flash Sale Inaanza!', body: 'Punguzo hadi 50% kwa matunda. Inaisha saa 2 ijayo!', emoji: '⚡', color: const Color(0xFFFF4757), createdAt: now.subtract(const Duration(hours: 3))),
      AppNotification(id: 'n4', title: 'Mkopo Umewekwa!', body: 'Mkopo wa TZS 500 umewekwa kwenye akaunti yako.', emoji: '🎁', color: const Color(0xFFF5A623), createdAt: now.subtract(const Duration(days: 2)), isRead: true),
      AppNotification(id: 'n5', title: 'Bidhaa Mpya!', body: 'Blueberry za import sasa zinapatikana. Nunua mapema!', emoji: '🫐', color: const Color(0xFF8B5CF6), createdAt: now.subtract(const Duration(days: 3)), isRead: true),
    ];
  }
}
