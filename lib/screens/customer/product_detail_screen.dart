import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../models/app_models.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  int _qty = 1;
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final product  = ModalRoute.of(context)!.settings.arguments as Product;
    final cart     = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final isFav    = wishlist.contains(product.id);

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // App bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p12),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: TM.card,
                    borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.border)),
                  child: const Center(child: Text('←', style: TextStyle(fontSize: 20, color: TM.text))),
                ),
              ),
              const Expanded(child: Center(
                child: Text('Maelezo ya Bidhaa',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: TM.text)),
              )),
              GestureDetector(
                onTap: () { wishlist.toggle(product); _showSnack(isFav ? '💔 Imeondolewa' : '❤️ Imeongezwa kwenye vipendwa!'); },
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: isFav ? TM.red.withOpacity(.15) : TM.card,
                    borderRadius: BorderRadius.circular(TM.r12),
                    border: Border.all(color: isFav ? TM.red.withOpacity(.3) : TM.border)),
                  child: Center(child: Text(isFav ? '❤️' : '🤍', style: const TextStyle(fontSize: 18))),
                ),
              ),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Product image
                Container(
                  height: 240, margin: const EdgeInsets.symmetric(horizontal: TM.p20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TM.card2, TM.bg.withOpacity(.5)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(TM.r24)),
                  child: Center(child: Text(product.imageEmoji, style: const TextStyle(fontSize: 100))),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Name + price
                    Row(children: [
                      Expanded(child: Text(product.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: TM.text))),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text(TM.formatPrice(product.price),
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: TM.primary)),
                        Text('/${product.unit}',
                          style: const TextStyle(fontSize: 12, color: TM.text2)),
                      ]),
                    ]),
                    const SizedBox(height: 8),
                    // Rating + stock
                    Row(children: [
                      Text('⭐' * product.rating.round().clamp(1, 5),
                        style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 6),
                      Text('${product.rating}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.primary)),
                      Text(' (${product.reviewCount} maoni)', style: const TextStyle(fontSize: 12, color: TM.text2)),
                      const Spacer(),
                      TMStatusBadge(
                        label: product.stockStatus == StockStatus.inStock ? '✓ Inapatikana'
                            : product.stockStatus == StockStatus.lowStock ? '⚠️ Imebaki ${product.stockQuantity}'
                            : '✗ Imekwisha',
                        color: product.stockStatus == StockStatus.inStock ? TM.green
                            : product.stockStatus == StockStatus.lowStock ? TM.aYellow
                            : TM.red,
                      ),
                    ]),
                    const SizedBox(height: 10),
                    // Badges
                    Wrap(spacing: 8, children: product.badges.map((b) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: TM.card2, borderRadius: BorderRadius.circular(TM.r8),
                        border: Border.all(color: TM.border)),
                      child: Text(b, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: TM.text2)),
                    )).toList()),
                    const SizedBox(height: 20),
                    // Tabs
                    TabBar(
                      controller: _tabCtrl,
                      labelColor: TM.primary,
                      unselectedLabelColor: TM.text2,
                      indicatorColor: TM.primary,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      tabs: const [Tab(text: 'Maelezo'), Tab(text: 'Maoni')],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: TabBarView(
                        controller: _tabCtrl,
                        children: [
                          // Description tab
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(product.description,
                              style: const TextStyle(fontSize: 13, color: TM.text2, height: 1.65)),
                            const SizedBox(height: 16),
                            if (product.nutrition.isNotEmpty) ...[
                              const Text('📊 Thamani ya Lishe (kwa 100g)',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.text)),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(TM.p12),
                                decoration: BoxDecoration(color: TM.card,
                                  borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.border)),
                                child: Wrap(
                                  spacing: 16, runSpacing: 8,
                                  children: product.nutrition.entries.map((e) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(e.key, style: const TextStyle(fontSize: 10.5, color: TM.text2)),
                                      Text(e.value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.primary)),
                                    ],
                                  )).toList(),
                                ),
                              ),
                            ],
                          ]),
                          // Reviews tab
                          ListView(children: const [
                            _ReviewItem(name: 'Amina Salim', emoji: '👩', rating: 5, comment: 'Bidhaa bora sana! Tamu na safi. Nitanunua tena bila shaka yoyote.', time: 'Juzi'),
                            _ReviewItem(name: 'Hassan Omar', emoji: '👨', rating: 4, comment: 'Nzuri sana, lakini delivery ilichukua muda kidogo zaidi. Bidhaa yenyewe ni bora.', time: 'Wiki 1'),
                            _ReviewItem(name: 'Fatuma Juma', emoji: '👩‍🦱', rating: 5, comment: 'Ninapenda sana! Itakuwa sehemu ya ununuzi wangu wa kila wiki.', time: 'Wiki 2'),
                          ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Quantity + Add to cart
                    Row(children: [
                      const Text('Kiasi:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: TM.text)),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(color: TM.card,
                          borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.border)),
                        child: Row(children: [
                          _QtyBtn(icon: '−', onTap: () { if (_qty > 1) setState(() => _qty--); }),
                          SizedBox(
                            width: 32,
                            child: Center(child: Text('$_qty',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: TM.text))),
                          ),
                          _QtyBtn(icon: '+', onTap: () => setState(() => _qty++)),
                        ]),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    // Buttons row
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          for (var i = 0; i < _qty; i++) cart.add(product);
                          _showSnack('✅ ${product.name} ×$_qty imeongezwa kwenye kikapu!');
                        },
                        child: Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: TM.primaryGrad,
                              borderRadius: BorderRadius.circular(TM.r16),
                              boxShadow: TM.primaryGlow),
                            child: const Center(child: Text('🛒 Weka Kikapuni',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 52, width: 52,
                        decoration: BoxDecoration(
                          border: Border.all(color: TM.primary.withOpacity(.4)),
                          borderRadius: BorderRadius.circular(TM.r16)),
                        child: const Center(child: Text('↗', style: TextStyle(fontSize: 22, color: TM.primary))),
                      ),
                    ]),
                    const SizedBox(height: 30),
                  ]),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), duration: const Duration(seconds: 2)));
}

class _QtyBtn extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36, height: 38,
      decoration: BoxDecoration(
        color: TM.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(TM.r8)),
      child: Center(child: Text(icon,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: TM.primary))),
    ),
  );
}

class _ReviewItem extends StatelessWidget {
  final String name, emoji, comment, time;
  final int rating;
  const _ReviewItem({required this.name, required this.emoji, required this.comment, required this.time, required this.rating});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(TM.p12),
    decoration: BoxDecoration(color: TM.card,
      borderRadius: BorderRadius.circular(TM.r14), border: Border.all(color: TM.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 30, height: 30, decoration: BoxDecoration(
            color: TM.primary.withOpacity(.12), shape: BoxShape.circle),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 14)))),
        const SizedBox(width: 8),
        Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TM.text)),
        const Spacer(),
        Text('⭐' * rating, style: const TextStyle(fontSize: 10)),
        const SizedBox(width: 4),
        Text(time, style: const TextStyle(fontSize: 10, color: TM.text2)),
      ]),
      const SizedBox(height: 6),
      Text(comment, style: const TextStyle(fontSize: 12, color: TM.text2, height: 1.5)),
    ]),
  );
}
