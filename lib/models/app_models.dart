// ═══════════════════════════════════════════════════════
//  TWENDE MARKITI — All Models
// ═══════════════════════════════════════════════════════

import 'package:flutter/material.dart';

// ── Enums ──────────────────────────────────────────────

enum UserRole { customer, admin }

enum OrderStatus { pending, confirmed, preparing, shipping, delivered, cancelled }

enum PaymentMethod { mpesa, airtel, card, cash, bank }

enum StockStatus { inStock, lowStock, outOfStock }

enum Language { swahili, english, french, arabic }

// ── User Model ─────────────────────────────────────────

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final UserRole role;
  final bool isActive;
  final int totalOrders;
  final double totalSpending;
  final double rating;
  final int loyaltyPoints;
  final String membershipLevel;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl = '',
    required this.role,
    this.isActive = true,
    this.totalOrders = 0,
    this.totalSpending = 0,
    this.rating = 5.0,
    this.loyaltyPoints = 0,
    this.membershipLevel = 'Mteja Mpya',
    required this.createdAt,
  });

  String get initials => name.isNotEmpty
      ? name.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : '?';

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        avatarUrl: json['avatarUrl'] ?? '',
        role: UserRole.values.firstWhere(
          (e) => e.name == json['role'],
          orElse: () => UserRole.customer,
        ),
        isActive: json['isActive'] ?? true,
        totalOrders: json['totalOrders'] ?? 0,
        totalSpending: (json['totalSpending'] ?? 0).toDouble(),
        rating: (json['rating'] ?? 5.0).toDouble(),
        loyaltyPoints: json['loyaltyPoints'] ?? 0,
        membershipLevel: json['membershipLevel'] ?? 'Mteja Mpya',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}

// ── Product Model ──────────────────────────────────────

class Product {
  final String id;
  final String name;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final double price;
  final double? originalPrice;
  final String categoryId;
  final String categoryName;
  final String unit;
  final String imageEmoji;
  final String imageUrl;
  final int stockQuantity;
  final bool isOrganic;
  final bool isFeatured;
  final bool isOnSale;
  final double rating;
  final int reviewCount;
  final List<String> badges;
  final Map<String, String> nutrition;
  final bool isActive;

  const Product({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.description,
    this.descriptionEn = '',
    required this.price,
    this.originalPrice,
    required this.categoryId,
    required this.categoryName,
    this.unit = 'kg',
    this.imageEmoji = '🥦',
    this.imageUrl = '',
    this.stockQuantity = 0,
    this.isOrganic = false,
    this.isFeatured = false,
    this.isOnSale = false,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.badges = const [],
    this.nutrition = const {},
    this.isActive = true,
  });

  StockStatus get stockStatus {
    if (stockQuantity == 0) return StockStatus.outOfStock;
    if (stockQuantity < 10) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  double get discountPercent {
    if (originalPrice == null || originalPrice! <= price) return 0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        nameEn: json['nameEn'] ?? json['name'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        originalPrice: json['originalPrice'] != null
            ? (json['originalPrice']).toDouble()
            : null,
        categoryId: json['categoryId'] ?? '',
        categoryName: json['categoryName'] ?? '',
        unit: json['unit'] ?? 'kg',
        imageEmoji: json['imageEmoji'] ?? '🥦',
        stockQuantity: json['stockQuantity'] ?? 0,
        isOrganic: json['isOrganic'] ?? false,
        isFeatured: json['isFeatured'] ?? false,
        isOnSale: json['isOnSale'] ?? false,
        rating: (json['rating'] ?? 4.5).toDouble(),
        reviewCount: json['reviewCount'] ?? 0,
        badges: List<String>.from(json['badges'] ?? []),
        nutrition: Map<String, String>.from(json['nutrition'] ?? {}),
        isActive: json['isActive'] ?? true,
      );
}

// ── Category Model ─────────────────────────────────────

class Category {
  final String id;
  final String name;
  final String nameEn;
  final String emoji;
  final Color color;
  final int productCount;

  const Category({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.emoji,
    required this.color,
    this.productCount = 0,
  });
}

// ── Cart Item ──────────────────────────────────────────

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

// ── Order Model ────────────────────────────────────────

class AppOrder {
  final String id;
  final String orderNumber;
  final AppUser customer;
  final List<CartItem> items;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final String deliveryAddress;
  final String? couponCode;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? trackingNote;

  const AppOrder({
    required this.id,
    required this.orderNumber,
    required this.customer,
    required this.items,
    required this.status,
    required this.paymentMethod,
    required this.subtotal,
    this.discount = 0,
    this.deliveryFee = 1500,
    required this.total,
    required this.deliveryAddress,
    this.couponCode,
    required this.createdAt,
    this.deliveredAt,
    this.trackingNote,
  });

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:     return '⏳ Inasubiri';
      case OrderStatus.confirmed:   return '✓ Imethibitishwa';
      case OrderStatus.preparing:   return '👨‍🍳 Inatayarishwa';
      case OrderStatus.shipping:    return '🚚 Inasafirishwa';
      case OrderStatus.delivered:   return '✅ Imefikishwa';
      case OrderStatus.cancelled:   return '❌ Imefutwa';
    }
  }
}

// ── Review Model ───────────────────────────────────────

class Review {
  final String id;
  final String userId;
  final String userName;
  final String productId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.productId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

// ── Address Model ──────────────────────────────────────

class DeliveryAddress {
  final String id;
  final String label;
  final String street;
  final String area;
  final String city;
  final bool isDefault;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.area,
    required this.city,
    this.isDefault = false,
  });

  String get full => '$street, $area, $city';
}

// ── Coupon Model ───────────────────────────────────────

class Coupon {
  final String code;
  final double discountPercent;
  final double? minOrder;
  final DateTime expiryDate;
  final bool isActive;

  const Coupon({
    required this.code,
    required this.discountPercent,
    this.minOrder,
    required this.expiryDate,
    this.isActive = true,
  });

  bool get isValid => isActive && expiryDate.isAfter(DateTime.now());
}

// ── Notification Model ─────────────────────────────────

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String emoji;
  final Color color;
  final DateTime createdAt;
  final bool isRead;
  final String? actionRoute;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.emoji,
    required this.color,
    required this.createdAt,
    this.isRead = false,
    this.actionRoute,
  });
}

// ── Dashboard Stats ────────────────────────────────────

class DashboardStats {
  final double todayRevenue;
  final double totalRevenue;
  final int newOrders;
  final int totalOrders;
  final int totalCustomers;
  final int newCustomers;
  final int pendingOrders;
  final int totalProducts;
  final List<double> weeklyRevenue;

  const DashboardStats({
    required this.todayRevenue,
    required this.totalRevenue,
    required this.newOrders,
    required this.totalOrders,
    required this.totalCustomers,
    required this.newCustomers,
    required this.pendingOrders,
    required this.totalProducts,
    required this.weeklyRevenue,
  });
}

// ── Banner Model ───────────────────────────────────────

class PromoBanner {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String tag;
  final Color startColor;
  final Color endColor;
  final String? actionRoute;

  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.tag,
    required this.startColor,
    required this.endColor,
    this.actionRoute,
  });
}
