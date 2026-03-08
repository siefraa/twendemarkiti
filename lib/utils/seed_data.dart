import 'package:flutter/material.dart';
import '../models/app_models.dart';
import 'app_theme.dart';

// ═══════════════════════════════════════════════════════
//  TWENDE MARKITI — Seed Data
// ═══════════════════════════════════════════════════════

class SeedData {
  // ── Categories ────────────────────────────────────────
  static const List<Category> categories = [
    Category(id: 'all',      name: 'Zote',        nameEn: 'All',        emoji: '🌟', color: TM.primary,   productCount: 156),
    Category(id: 'fruits',   name: 'Matunda',     nameEn: 'Fruits',     emoji: '🍎', color: TM.catFruits, productCount: 42),
    Category(id: 'veg',      name: 'Mbogamboga',  nameEn: 'Vegetables', emoji: '🥦', color: TM.catVeg,    productCount: 35),
    Category(id: 'meat',     name: 'Nyama',       nameEn: 'Meat',       emoji: '🥩', color: TM.catMeat,   productCount: 18),
    Category(id: 'fish',     name: 'Samaki',      nameEn: 'Fish',       emoji: '🐟', color: TM.catFish,   productCount: 22),
    Category(id: 'dairy',    name: 'Maziwa',      nameEn: 'Dairy',      emoji: '🥛', color: TM.catDairy,  productCount: 14),
    Category(id: 'grains',   name: 'Nafaka',      nameEn: 'Grains',     emoji: '🌾', color: TM.catGrains, productCount: 12),
    Category(id: 'bev',      name: 'Vinywaji',    nameEn: 'Beverages',  emoji: '🧃', color: TM.catBev,    productCount: 9),
    Category(id: 'spices',   name: 'Viungo',      nameEn: 'Spices',     emoji: '🌶️', color: TM.catSpices, productCount: 16),
  ];

  // ── Products ──────────────────────────────────────────
  static final List<Product> products = [
    Product(
      id: 'p001', name: 'Embe la Alphonso', nameEn: 'Alphonso Mango',
      description: 'Embe bora zaidi duniani. Tamu, laini, na yenye harufu nzuri. Safi kabisa bila dawa.',
      price: 3500, originalPrice: 4500, categoryId: 'fruits', categoryName: 'Matunda',
      unit: 'kg', imageEmoji: '🥭', stockQuantity: 142,
      isOrganic: true, isFeatured: true, isOnSale: true,
      rating: 4.8, reviewCount: 120, badges: ['Organic', 'Bestseller'],
      nutrition: {'Kalori': '60 kcal', 'Wanga': '15g', 'Vit C': '36mg', 'Maji': '82%'},
    ),
    Product(
      id: 'p002', name: 'Parachichi Hass', nameEn: 'Hass Avocado',
      description: 'Parachichi ya aina ya Hass. Ina mafuta mazuri, vitamini E, na potasiamu.',
      price: 2800, categoryId: 'fruits', categoryName: 'Matunda',
      unit: '500g', imageEmoji: '🥑', stockQuantity: 8,
      isOrganic: false, isFeatured: true,
      rating: 4.5, reviewCount: 89, badges: ['Safi'],
      nutrition: {'Kalori': '160 kcal', 'Mafuta': '15g', 'Vit E': '2mg', 'Potasiamu': '485mg'},
    ),
    Product(
      id: 'p003', name: 'Strawberry Safi', nameEn: 'Fresh Strawberry',
      description: 'Strawberry tamu na safi kutoka mashambani. Inafaa kwa dessert na juisi.',
      price: 5200, categoryId: 'fruits', categoryName: 'Matunda',
      unit: '250g', imageEmoji: '🍓', stockQuantity: 67,
      isOrganic: true, isFeatured: true,
      rating: 4.9, reviewCount: 204, badges: ['Organic', 'Fresh'],
      nutrition: {'Kalori': '32 kcal', 'Vit C': '59mg', 'Sukari': '4.9g'},
    ),
    Product(
      id: 'p004', name: 'Blueberry Import', nameEn: 'Imported Blueberry',
      description: 'Blueberry ya import kutoka nje. Ina antioxidants nyingi sana.',
      price: 8000, categoryId: 'fruits', categoryName: 'Matunda',
      unit: '200g', imageEmoji: '🫐', stockQuantity: 34,
      isOrganic: false, isFeatured: false,
      rating: 4.6, reviewCount: 67, badges: ['Import'],
      nutrition: {'Kalori': '57 kcal', 'Vit C': '9.7mg', 'Fiber': '2.4g'},
    ),
    Product(
      id: 'p005', name: 'Broccoli Safi', nameEn: 'Fresh Broccoli',
      description: 'Broccoli safi kutoka shambani. Ina vitamini C, K, na foliki asidi.',
      price: 2200, categoryId: 'veg', categoryName: 'Mbogamboga',
      unit: '500g', imageEmoji: '🥦', stockQuantity: 89,
      isOrganic: true, isFeatured: false,
      rating: 4.3, reviewCount: 45, badges: ['Organic', 'Local'],
      nutrition: {'Kalori': '34 kcal', 'Vit C': '89mg', 'Vit K': '101mcg'},
    ),
    Product(
      id: 'p006', name: 'Nyanya Ndizi', nameEn: 'Plum Tomato',
      description: 'Nyanya nzuri na tamu. Inafaa kwa kupika mchuzi na saladi.',
      price: 1800, categoryId: 'veg', categoryName: 'Mbogamboga',
      unit: 'kg', imageEmoji: '🍅', stockQuantity: 200,
      isOrganic: false, isFeatured: false,
      rating: 4.4, reviewCount: 156, badges: ['Local'],
      nutrition: {'Kalori': '18 kcal', 'Vit C': '14mg', 'Potasiamu': '237mg'},
    ),
    Product(
      id: 'p007', name: 'Nyama ya Ng\'ombe Safi', nameEn: 'Fresh Beef',
      description: 'Nyama ya ng\'ombe safi iliyochinjwa leo. Ni bora kwa kuchoma na kupika.',
      price: 12000, categoryId: 'meat', categoryName: 'Nyama',
      unit: '500g', imageEmoji: '🥩', stockQuantity: 0,
      isOrganic: false, isFeatured: false,
      rating: 4.7, reviewCount: 88, badges: ['Fresh Cut'],
      nutrition: {'Kalori': '250 kcal', 'Protini': '26g', 'Mafuta': '17g'},
    ),
    Product(
      id: 'p008', name: 'Samaki Tilapia', nameEn: 'Tilapia Fish',
      description: 'Samaki wa Tilapia safi kutoka ziwa. Una protini nyingi na harufu nzuri.',
      price: 8500, categoryId: 'fish', categoryName: 'Samaki',
      unit: 'kg', imageEmoji: '🐟', stockQuantity: 45,
      isOrganic: false, isFeatured: false,
      rating: 4.5, reviewCount: 67, badges: ['Bahari'],
      nutrition: {'Kalori': '128 kcal', 'Protini': '26g', 'Mafuta': '2.7g'},
    ),
    Product(
      id: 'p009', name: 'Maziwa Safi', nameEn: 'Fresh Milk',
      description: 'Maziwa safi ya ng\'ombe. Yamepasteurizwa na yana vitamini D.',
      price: 2500, categoryId: 'dairy', categoryName: 'Maziwa',
      unit: 'lita', imageEmoji: '🥛', stockQuantity: 150,
      isOrganic: false, isFeatured: false,
      rating: 4.6, reviewCount: 234, badges: ['Safi', 'Fresh'],
      nutrition: {'Kalori': '61 kcal', 'Kalsiamu': '276mg', 'Protini': '3.2g'},
    ),
    Product(
      id: 'p010', name: 'Pilipili Hoho', nameEn: 'Bell Pepper',
      description: 'Pilipili hoho nyekundu tamu. Inafaa kwa kupika na kula moja kwa moja.',
      price: 3000, categoryId: 'veg', categoryName: 'Mbogamboga',
      unit: '3 pieces', imageEmoji: '🫑', stockQuantity: 76,
      isOrganic: true, isFeatured: false,
      rating: 4.2, reviewCount: 38, badges: ['Organic'],
      nutrition: {'Kalori': '31 kcal', 'Vit C': '128mg', 'Vit B6': '0.3mg'},
    ),
    Product(
      id: 'p011', name: 'Machungwa', nameEn: 'Orange',
      description: 'Machungwa matamu ya Tanzania. Yana vitamini C nyingi. Bora kwa juisi.',
      price: 1500, originalPrice: 2000, categoryId: 'fruits', categoryName: 'Matunda',
      unit: 'kg', imageEmoji: '🍊', stockQuantity: 320,
      isOrganic: true, isFeatured: true, isOnSale: true,
      rating: 4.7, reviewCount: 445, badges: ['Organic', 'Local', 'Sale'],
      nutrition: {'Kalori': '47 kcal', 'Vit C': '53mg', 'Fiber': '2.4g'},
    ),
    Product(
      id: 'p012', name: 'Nanasi', nameEn: 'Pineapple',
      description: 'Nanasi tamu na kubwa. Una enzyme ya bromelain inayosaidia usagaji wa chakula.',
      price: 3500, categoryId: 'fruits', categoryName: 'Matunda',
      unit: 'mzima', imageEmoji: '🍍', stockQuantity: 28,
      isOrganic: false, isFeatured: false,
      rating: 4.8, reviewCount: 167, badges: ['Fresh', 'Local'],
      nutrition: {'Kalori': '50 kcal', 'Vit C': '47mg', 'Bromelain': '✓'},
    ),
  ];

  // ── Seed Users ────────────────────────────────────────
  static final AppUser demoCustomer = AppUser(
    id: 'u001',
    name: 'Amina Hassan',
    email: 'amina.hassan@gmail.com',
    phone: '+255 712 345 678',
    role: UserRole.customer,
    totalOrders: 47,
    totalSpending: 284500,
    rating: 4.8,
    loyaltyPoints: 1420,
    membershipLevel: 'Mteja Mkuu',
    createdAt: DateTime(2023, 6, 15),
  );

  static final AppUser demoAdmin = AppUser(
    id: 'a001',
    name: 'Juma Msimamizi',
    email: 'admin@twendemarkiti.co.tz',
    phone: '+255 756 789 012',
    role: UserRole.admin,
    createdAt: DateTime(2023, 1, 1),
  );

  // ── Banners ───────────────────────────────────────────
  static const List<PromoBanner> banners = [
    PromoBanner(
      id: 'b1', emoji: '🥭',
      tag: '🔥 Ofa Maalum',
      title: 'Punguzo hadi 40%',
      subtitle: 'Matunda mapya ya msimu • Leo peke yake',
      startColor: Color(0xFF1A1030), endColor: Color(0xFF2A1060),
    ),
    PromoBanner(
      id: 'b2', emoji: '🚚',
      tag: '🎁 Bure',
      title: 'Utoaji Bure!',
      subtitle: 'Kwa maagizo zaidi ya TZS 15,000 leo',
      startColor: Color(0xFF0A2040), endColor: Color(0xFF102060),
    ),
    PromoBanner(
      id: 'b3', emoji: '⚡',
      tag: '⚡ Flash Sale',
      title: 'Mbogamboga -30%',
      subtitle: 'Inaisha saa 2 ijayo tu!',
      startColor: Color(0xFF201010), endColor: Color(0xFF401828),
    ),
  ];

  // ── Coupons ───────────────────────────────────────────
  static final List<Coupon> coupons = [
    Coupon(code: 'TWENDE10', discountPercent: 10, minOrder: 5000, expiryDate: DateTime(2025, 12, 31)),
    Coupon(code: 'KARIBU20', discountPercent: 20, minOrder: 10000, expiryDate: DateTime(2025, 12, 31)),
    Coupon(code: 'SOKO15',   discountPercent: 15, minOrder: 8000,  expiryDate: DateTime(2025, 12, 31)),
  ];

  // ── Addresses ─────────────────────────────────────────
  static const List<DeliveryAddress> addresses = [
    DeliveryAddress(id: 'a1', label: '🏠 Nyumbani', street: 'Msasani Road 14', area: 'Msasani', city: 'Dar es Salaam', isDefault: true),
    DeliveryAddress(id: 'a2', label: '🏢 Kazini', street: 'Samora Avenue 7', area: 'CBD', city: 'Dar es Salaam'),
  ];

  // ── Dashboard Stats ───────────────────────────────────
  static DashboardStats get dashboardStats => DashboardStats(
    todayRevenue: 4280000,
    totalRevenue: 128450000,
    newOrders: 24,
    totalOrders: 3847,
    totalCustomers: 1284,
    newCustomers: 34,
    pendingOrders: 7,
    totalProducts: 156,
    weeklyRevenue: [1850000, 2400000, 1600000, 3200000, 2900000, 4280000, 1200000],
  );
}
