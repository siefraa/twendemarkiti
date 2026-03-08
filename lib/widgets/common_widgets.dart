import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/app_models.dart';

// ═══════════════════════════════════════════════════════
//  TWENDE MARKITI — Common Widgets
// ═══════════════════════════════════════════════════════

// ── TM Button ─────────────────────────────────────────
class TMButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;
  final bool isSmall;
  final Color? color;
  final Color? textColor;
  final IconData? icon;

  const TMButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.isSmall = false,
    this.color,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? TM.primary;
    final h  = isSmall ? 42.0 : 56.0;
    final fs = isSmall ? 13.0 : 15.0;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: h,
        decoration: BoxDecoration(
          gradient: isOutlined ? null : LinearGradient(
            colors: [bg, Color.lerp(bg, Colors.black, .15)!],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          border: isOutlined ? Border.all(color: bg, width: 1.5) : null,
          borderRadius: BorderRadius.circular(TM.r16),
          boxShadow: isOutlined ? null : [
            BoxShadow(color: bg.withOpacity(.3), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22, height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: isOutlined ? bg : Colors.black,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: isSmall ? 16 : 18,
                          color: isOutlined ? bg : (textColor ?? Colors.black)),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: fs, fontWeight: FontWeight.w700,
                        color: isOutlined ? bg : (textColor ?? Colors.black),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ── TM Text Field ─────────────────────────────────────
class TMTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? prefixEmoji;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const TMTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.keyboardType,
    this.prefixEmoji,
    this.suffix,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700,
            color: TM.text2, letterSpacing: .08,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: TM.text, fontSize: 14),
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixEmoji != null ? '$prefixEmoji  ' : null,
            prefixStyle: const TextStyle(fontSize: 16),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

// ── TM Card ────────────────────────────────────────────
class TMCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? color;
  final double? radius;
  final bool hasBorder;

  const TMCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.radius,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(TM.p16),
        decoration: BoxDecoration(
          color: color ?? TM.card,
          borderRadius: BorderRadius.circular(radius ?? TM.r16),
          border: hasBorder ? Border.all(color: TM.border) : null,
        ),
        child: child,
      ),
    );
  }
}

// ── TM Section Header ──────────────────────────────────
class TMSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const TMSectionHeader({
    super.key, required this.title, this.action, this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w800, color: TM.text,
        )),
        const Spacer(),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Text(action!, style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: TM.primary,
            )),
          ),
      ],
    );
  }
}

// ── Status Badge ───────────────────────────────────────
class TMStatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSmall;

  const TMStatusBadge({
    super.key, required this.label, required this.color, this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 12,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: isSmall ? 10 : 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ── Product Card ───────────────────────────────────────
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final bool isFavorite;
  final VoidCallback? onFavToggle;
  final bool isAdminMode;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
    this.isFavorite = false,
    this.onFavToggle,
    this.isAdminMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: TM.card,
          borderRadius: BorderRadius.circular(TM.r20),
          border: Border.all(color: TM.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            SizedBox(
              height: 110,
              child: Stack(
                children: [
                  Container(
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          TM.card2,
                          TM.bg.withOpacity(.5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(TM.r20)),
                    ),
                    child: Center(
                      child: Text(product.imageEmoji, style: const TextStyle(fontSize: 50)),
                    ),
                  ),
                  if (!isAdminMode)
                    Positioned(
                      top: 8, right: 8,
                      child: GestureDetector(
                        onTap: onFavToggle,
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: isFavorite
                                ? TM.red.withOpacity(.2)
                                : Colors.white.withOpacity(.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              isFavorite ? '❤️' : '🤍',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (product.discountPercent > 0)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: TM.red,
                          borderRadius: BorderRadius.circular(TM.r8),
                        ),
                        child: Text(
                          '-${product.discountPercent.toInt()}%',
                          style: const TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (product.stockStatus == StockStatus.lowStock)
                    Positioned(
                      top: 8, left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: TM.aYellow,
                          borderRadius: BorderRadius.circular(TM.r8),
                        ),
                        child: const Text('⚠️ Kidogo', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.black)),
                      ),
                    ),
                ],
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(TM.p12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: TM.text),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('${product.unit} · ${product.badges.first}',
                    style: const TextStyle(fontSize: 10.5, color: TM.text2)),
                  const SizedBox(height: 4),
                  // Rating
                  Row(
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 9)),
                      const SizedBox(width: 2),
                      Text('${product.rating}',
                        style: const TextStyle(fontSize: 9.5, color: TM.primary, fontWeight: FontWeight.w700)),
                      const SizedBox(width: 3),
                      Text('(${product.reviewCount})',
                        style: const TextStyle(fontSize: 9, color: TM.text2)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TM.formatPrice(product.price),
                            style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800, color: TM.primary,
                            ),
                          ),
                          if (product.originalPrice != null)
                            Text(
                              TM.formatPrice(product.originalPrice!),
                              style: const TextStyle(
                                fontSize: 10, color: TM.text2,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      if (!isAdminMode)
                        GestureDetector(
                          onTap: product.stockStatus == StockStatus.outOfStock ? null : onAddToCart,
                          child: Container(
                            width: 30, height: 30,
                            decoration: BoxDecoration(
                              gradient: product.stockStatus == StockStatus.outOfStock
                                  ? null
                                  : TM.primaryGrad,
                              color: product.stockStatus == StockStatus.outOfStock
                                  ? TM.text3
                                  : null,
                              borderRadius: BorderRadius.circular(TM.r12),
                            ),
                            child: const Center(
                              child: Text('+', style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black,
                              )),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Order Card ─────────────────────────────────────────
class OrderCard extends StatelessWidget {
  final AppOrder order;
  final VoidCallback? onTap;
  final bool isAdminMode;
  final void Function(String)? onStatusChange;

  const OrderCard({
    super.key, required this.order,
    this.onTap, this.isAdminMode = false, this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = TM.statusColor(order.status.name);
    return GestureDetector(
      onTap: onTap,
      child: TMCard(
        padding: const EdgeInsets.all(TM.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('#${order.orderNumber}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: TM.text)),
                  const SizedBox(height: 2),
                  Text(_formatDate(order.createdAt),
                    style: const TextStyle(fontSize: 11, color: TM.text2)),
                ]),
                const Spacer(),
                TMStatusBadge(label: order.statusLabel, color: statusColor),
              ],
            ),
            if (isAdminMode) ...[
              const SizedBox(height: 8),
              Text('👤 ${order.customer.name}  ·  📱 ${order.customer.phone}',
                style: const TextStyle(fontSize: 11.5, color: TM.text2)),
              Text('📍 ${order.deliveryAddress}',
                style: const TextStyle(fontSize: 10.5, color: TM.text3)),
            ],
            const SizedBox(height: 10),
            // Item thumbnails
            Row(
              children: [
                ...order.items.take(3).map((item) => Container(
                  width: 44, height: 44,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: TM.card2,
                    borderRadius: BorderRadius.circular(TM.r12),
                    border: Border.all(color: TM.border),
                  ),
                  child: Center(
                    child: Text(item.product.imageEmoji, style: const TextStyle(fontSize: 22)),
                  ),
                )),
                if (order.items.length > 3)
                  Text('+${order.items.length - 3} zaidi',
                    style: const TextStyle(fontSize: 11, color: TM.text2)),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 1, color: TM.border),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  TM.formatPrice(order.total),
                  style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800, color: TM.primary,
                  ),
                ),
                const Spacer(),
                if (isAdminMode && onStatusChange != null)
                  _AdminStatusSelector(order: order, onChanged: onStatusChange!)
                else if (order.status == OrderStatus.shipping)
                  _ActionChip(label: '📍 Fuatilia', color: TM.blue)
                else if (order.status == OrderStatus.delivered)
                  _ActionChip(label: '⭐ Piga Kura', color: TM.green)
                else if (order.status == OrderStatus.pending)
                  _ActionChip(label: '✕ Futa', color: TM.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return 'Dakika ${diff.inMinutes} zilizopita';
    if (diff.inHours < 24) return 'Saa ${diff.inHours} zilizopita';
    if (diff.inDays == 1) return 'Jana';
    return 'Siku ${diff.inDays} zilizopita';
  }
}

class _AdminStatusSelector extends StatelessWidget {
  final AppOrder order;
  final void Function(String) onChanged;

  const _AdminStatusSelector({required this.order, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: TM.card2,
        borderRadius: BorderRadius.circular(TM.r8),
        border: Border.all(color: TM.border),
      ),
      child: DropdownButton<String>(
        value: order.status.name,
        dropdownColor: TM.card2,
        underline: const SizedBox(),
        isDense: true,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: TM.text),
        items: OrderStatus.values.map((s) => DropdownMenuItem(
          value: s.name,
          child: Text(s.name, style: const TextStyle(fontSize: 11)),
        )).toList(),
        onChanged: (v) => v != null ? onChanged(v) : null,
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ActionChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(TM.r12),
        border: Border.all(color: color.withOpacity(.25)),
      ),
      child: Text(label, style: TextStyle(
        fontSize: 11.5, fontWeight: FontWeight.w700, color: color,
      )),
    );
  }
}

// ── Search Bar ─────────────────────────────────────────
class TMSearchBar extends StatelessWidget {
  final String hint;
  final void Function(String)? onChanged;
  final VoidCallback? onFilterTap;

  const TMSearchBar({
    super.key, this.hint = 'Tafuta...', this.onChanged, this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: TM.card,
        borderRadius: BorderRadius.circular(TM.r16),
        border: Border.all(color: TM.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Text('🔍', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: TM.text, fontSize: 13.5),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: TM.text3, fontSize: 13.5),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onFilterTap != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: TM.primary.withOpacity(.12),
                borderRadius: BorderRadius.circular(TM.r8),
              ),
              child: const Text('⚙️ Chuja',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: TM.primary)),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────
class TMEmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const TMEmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: TM.text,
            )),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: TM.text2)),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              TMButton(label: actionLabel!, onTap: onAction, isSmall: true),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Stats Card ─────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final String? change;
  final List<Color> gradientColors;

  const StatCard({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
    this.change,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TM.p16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TM.r16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white,
          )),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(
            fontSize: 11, color: Colors.white.withOpacity(.65),
          )),
          if (change != null) ...[
            const SizedBox(height: 5),
            Text(change!, style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(.8),
            )),
          ],
        ],
      ),
    );
  }
}
