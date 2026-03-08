import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../models/app_models.dart';
import '../../utils/app_theme.dart';
import '../../utils/seed_data.dart';
import '../../widgets/common_widgets.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bannerIndex = 0;
  final _pageCtrl = PageController();
  Timer? _bannerTimer;
  // Flash sale countdown
  int _seconds = 2 * 3600 + 47 * 60 + 33;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_bannerIndex + 1) % SeedData.banners.length;
      _pageCtrl.animateToPage(next, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() { if (_seconds > 0) _seconds--; });
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _countdownTimer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart      = context.watch<CartProvider>();
    final wishlist  = context.watch<WishlistProvider>();
    final products  = context.watch<ProductsProvider>();
    final auth      = context.watch<AuthProvider>();
    final notifs    = context.watch<NotificationProvider>();
    final firstName = auth.user?.name.split(' ').first ?? 'Mgeni';

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // ── Header ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Text('📍', style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    const Text('Dar es Salaam, TZ',
                      style: TextStyle(fontSize: 12, color: TM.primary, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 3),
                  RichText(text: TextSpan(children: [
                    const TextSpan(text: 'Habari, ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: TM.text)),
                    TextSpan(text: '$firstName ', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: TM.primary)),
                    const TextSpan(text: '👋', style: TextStyle(fontSize: 22)),
                  ])),
                ]),
              ),
              _HeaderIcon(
                emoji: '🔔',
                badgeCount: notifs.unreadCount,
                onTap: () => Navigator.of(context).pushNamed('/notifications'),
              ),
              const SizedBox(width: 8),
              _HeaderIcon(
                emoji: '🛒',
                badgeCount: cart.count,
                onTap: () => Navigator.of(context).pushNamed('/cart'),
              ),
            ]),
          ),
          // ── Search ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
            child: TMSearchBar(
              hint: 'Tafuta bidhaa, maduka...',
              onChanged: (q) => products.search(q),
              onFilterTap: () {},
            ),
          ),
          // ── Scrollable body ─────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                // Banner carousel
                Padding(
                  padding: const EdgeInsets.fromLTRB(TM.p20, 4, TM.p20, 16),
                  child: Column(children: [
                    SizedBox(
                      height: 140,
                      child: PageView.builder(
                        controller: _pageCtrl,
                        onPageChanged: (i) => setState(() => _bannerIndex = i),
                        itemCount: SeedData.banners.length,
                        itemBuilder: (_, i) => _BannerCard(banner: SeedData.banners[i]),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(
                      SeedData.banners.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _bannerIndex ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _bannerIndex ? TM.primary : TM.text3,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    )),
                  ]),
                ),
                // Categories
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                  child: TMSectionHeader(
                    title: 'Aina za Bidhaa',
                    action: 'Zote →',
                    onAction: () => Navigator.of(context).pushNamed('/shop'),
                  ),
                ),
                const SizedBox(height: 10),
                _CategoryRow(),
                const SizedBox(height: 20),
                // Flash Sale banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                  child: _FlashSaleCard(seconds: _seconds),
                ),
                const SizedBox(height: 20),
                // Featured products
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                  child: TMSectionHeader(
                    title: 'Bidhaa Maarufu 🔥',
                    action: 'Zote →',
                    onAction: () => Navigator.of(context).pushNamed('/shop'),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                      childAspectRatio: .72,
                    ),
                    itemCount: products.featured.length,
                    itemBuilder: (_, i) {
                      final p = products.featured[i];
                      return ProductCard(
                        product: p,
                        isFavorite: wishlist.contains(p.id),
                        onFavToggle: () {
                          wishlist.toggle(p);
                          _showSnack(wishlist.contains(p.id) ? '❤️ Imeongezwa kwenye vipendwa!' : '💔 Imeondolewa');
                        },
                        onTap: () => Navigator.of(context).pushNamed('/product', arguments: p),
                        onAddToCart: () {
                          cart.add(p);
                          _showSnack('✅ ${p.name} – imeongezwa kwenye kikapu!');
                        },
                      );
                    },
                  ),
                ),
                // On sale section
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                  child: TMSectionHeader(title: 'Ofa za Leo 🏷️', action: 'Zote →'),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                    itemCount: products.onSale.length,
                    itemBuilder: (_, i) {
                      final p = products.onSale[i];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        child: ProductCard(
                          product: p,
                          isFavorite: wishlist.contains(p.id),
                          onFavToggle: () => wishlist.toggle(p),
                          onTap: () => Navigator.of(context).pushNamed('/product', arguments: p),
                          onAddToCart: () { cart.add(p); _showSnack('✅ Imeongezwa!'); },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }
}

// ── Banner Card ────────────────────────────────────────
class _BannerCard extends StatelessWidget {
  final PromoBanner banner;
  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [banner.startColor, banner.endColor],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(TM.r20),
      ),
      child: Stack(
        children: [
          Positioned(right: 16, top: 0, bottom: 0,
            child: Center(child: Text(banner.emoji,
              style: TextStyle(fontSize: 72, color: Colors.white.withOpacity(.15))))),
          Padding(
            padding: const EdgeInsets.all(TM.p20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: TM.primary.withOpacity(.2),
                  borderRadius: BorderRadius.circular(TM.r8)),
                child: Text(banner.tag, style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: TM.primary))),
              const SizedBox(height: 6),
              Text(banner.title, style: const TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800, color: TM.text)),
              Text(banner.subtitle, style: const TextStyle(fontSize: 12, color: TM.text2)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Category Row ───────────────────────────────────────
class _CategoryRow extends StatefulWidget {
  @override
  State<_CategoryRow> createState() => _CategoryRowState();
}
class _CategoryRowState extends State<_CategoryRow> {
  String _selected = 'all';
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TM.p20),
        itemCount: SeedData.categories.length,
        itemBuilder: (_, i) {
          final cat = SeedData.categories[i];
          final isActive = _selected == cat.id;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = cat.id);
              context.read<ProductsProvider>().setCategory(cat.id);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: Column(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: isActive ? cat.color.withOpacity(.15) : TM.card,
                    borderRadius: BorderRadius.circular(TM.r16),
                    border: Border.all(color: isActive ? cat.color : TM.border, width: isActive ? 1.5 : 1),
                  ),
                  child: Center(child: Text(cat.emoji, style: const TextStyle(fontSize: 24))),
                ),
                const SizedBox(height: 5),
                Text(cat.name, style: TextStyle(
                  fontSize: 10.5, fontWeight: FontWeight.w600,
                  color: isActive ? cat.color : TM.text2)),
              ]),
            ),
          );
        },
      ),
    );
  }
}

// ── Flash Sale ─────────────────────────────────────────
class _FlashSaleCard extends StatelessWidget {
  final int seconds;
  const _FlashSaleCard({required this.seconds});

  @override
  Widget build(BuildContext context) {
    final h = (seconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.all(TM.p16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFF4757), Color(0xFFC0392B)],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(TM.r20),
      ),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Text('⚡', style: TextStyle(fontSize: 18)),
            SizedBox(width: 6),
            Text('Flash Sale', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
          ]),
          const SizedBox(height: 4),
          const Text('Inaisha baada ya:', style: TextStyle(fontSize: 11, color: Colors.white54)),
          const SizedBox(height: 8),
          Row(children: [
            _TimeBox(value: h), const _TimeSep(),
            _TimeBox(value: m), const _TimeSep(),
            _TimeBox(value: s),
          ]),
        ])),
        const Text('⚡', style: TextStyle(fontSize: 48, color: Colors.white24)),
      ]),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  const _TimeBox({required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
    child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
  );
}
class _TimeSep extends StatelessWidget {
  const _TimeSep();
  @override
  Widget build(BuildContext context) =>
      const Padding(padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(':', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white60)));
}

class _HeaderIcon extends StatelessWidget {
  final String emoji;
  final int badgeCount;
  final VoidCallback onTap;
  const _HeaderIcon({required this.emoji, required this.badgeCount, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Stack(clipBehavior: Clip.none, children: [
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: TM.card,
          borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.border)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 18))),
      ),
      if (badgeCount > 0) Positioned(
        top: -4, right: -4,
        child: Container(
          width: 17, height: 17,
          decoration: const BoxDecoration(color: TM.red, shape: BoxShape.circle),
          child: Center(child: Text('$badgeCount',
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))),
        ),
      ),
    ]),
  );
}
