import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../models/app_models.dart';
import '../../utils/app_theme.dart';
import '../../utils/seed_data.dart';
import '../../widgets/common_widgets.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats   = SeedData.dashboardStats;
    final orders  = context.watch<OrdersProvider>();
    final auth    = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: TM.aBg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Dashibodi 📊', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: TM.aText)),
                Text(_todayDate(), style: const TextStyle(fontSize: 11, color: TM.aText2)),
              ])),
              _AdminHeaderBtn(emoji: '🔔', badgeCount: 5,
                onTap: () => Navigator.of(context).pushNamed('/notifications')),
              const SizedBox(width: 8),
              _AdminHeaderBtn(emoji: '👨‍💼', onTap: () {}),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: TM.p20),
              child: Column(children: [
                // Revenue stats grid
                GridView.count(
                  crossAxisCount: 2, shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10, mainAxisSpacing: 10,
                  childAspectRatio: 1.35,
                  children: [
                    StatCard(
                      emoji: '💰', value: 'TZS 4.28M', label: 'Mapato Leo',
                      change: '↑ 12.5% kutoka jana',
                      gradientColors: const [Color(0xFFF59E0B), Color(0xFFD97706)]),
                    StatCard(
                      emoji: '📦', value: '${stats.newOrders}', label: 'Maagizo Mapya',
                      change: '↑ 8 kutoka jana',
                      gradientColors: const [Color(0xFF3B82F6), Color(0xFF2563EB)]),
                    StatCard(
                      emoji: '👥', value: '${stats.totalCustomers}', label: 'Wateja Wote',
                      change: '↑ 34 wiki hii',
                      gradientColors: const [Color(0xFF10B981), Color(0xFF059669)]),
                    StatCard(
                      emoji: '⏳', value: '${stats.pendingOrders}', label: 'Yanayosubiri',
                      change: '⚠️ Haraka kushughulikia!',
                      gradientColors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
                  ],
                ),
                const SizedBox(height: 20),
                // Revenue chart
                Container(
                  padding: const EdgeInsets.all(TM.p16),
                  decoration: BoxDecoration(color: TM.aCard,
                    borderRadius: BorderRadius.circular(TM.r20), border: Border.all(color: TM.aBorder)),
                  child: Column(children: [
                    Row(children: [
                      const Text('Mapato ya Wiki', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: TM.aText)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: TM.aBlue.withOpacity(.1),
                          borderRadius: BorderRadius.circular(8)),
                        child: const Text('Wiki hii', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: TM.aBlue))),
                    ]),
                    const SizedBox(height: 16),
                    _WeeklyChart(data: stats.weeklyRevenue),
                  ]),
                ),
                const SizedBox(height: 20),
                // Quick actions
                Row(children: [
                  Expanded(child: _QuickAction(emoji: '📦', label: 'Maagizo', badge: '${stats.newOrders}',
                    color: TM.aYellow, onTap: () => Navigator.of(context).pushNamed('/admin/orders'))),
                  const SizedBox(width: 10),
                  Expanded(child: _QuickAction(emoji: '🏪', label: 'Bidhaa', badge: '${stats.totalProducts}',
                    color: TM.aGreen, onTap: () => Navigator.of(context).pushNamed('/admin/products'))),
                  const SizedBox(width: 10),
                  Expanded(child: _QuickAction(emoji: '👥', label: 'Wateja', badge: '${stats.totalCustomers}',
                    color: TM.aBlue, onTap: () => Navigator.of(context).pushNamed('/admin/customers'))),
                ]),
                const SizedBox(height: 20),
                // Recent orders
                Row(children: [
                  const Text('Maagizo ya Hivi Karibuni', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: TM.aText)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/admin/orders'),
                    child: const Text('Yote →', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TM.aBlue))),
                ]),
                const SizedBox(height: 10),
                ...orders.all.take(3).map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OrderCard(
                    order: o,
                    isAdminMode: true,
                    onStatusChange: (s) {
                      final newStatus = OrderStatus.values.firstWhere((x) => x.name == s);
                      orders.updateStatus(o.id, newStatus);
                    },
                  ),
                )),
                const SizedBox(height: 20),
                // Top products
                const Row(children: [
                  Text('Bidhaa Bora 🏆', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: TM.aText)),
                ]),
                const SizedBox(height: 10),
                ...SeedData.products.take(3).map((p) => _TopProductRow(product: p)),
                const SizedBox(height: 30),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  String _todayDate() {
    final now = DateTime.now();
    const days = ['Jumapili','Jumatatu','Jumanne','Jumatano','Alhamisi','Ijumaa','Jumamosi'];
    const months = ['Jan','Feb','Mac','Apr','Mei','Jun','Jul','Ago','Sep','Okt','Nov','Des'];
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

class _WeeklyChart extends StatelessWidget {
  final List<double> data;
  const _WeeklyChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    const days   = ['Ju', 'Nt', 'Ju', 'Al', 'Ij', 'Leo', 'Kt'];
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(data.length, (i) {
          final frac = data[i] / maxVal;
          final isToday = i == data.length - 2;
          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 400 + i * 60),
                  height: 70 * frac,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    gradient: isToday ? TM.adminGrad : null,
                    color: isToday ? null : TM.aBlue.withOpacity(.15),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    border: isToday ? null : Border.all(color: TM.aBlue.withOpacity(.2)),
                  ),
                ),
                const SizedBox(height: 5),
                Text(days[i], style: TextStyle(
                  fontSize: 9,
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                  color: isToday ? TM.aBlue : TM.aText2)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String emoji, label, badge;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.emoji, required this.label, required this.badge,
    required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: TM.aCard,
        borderRadius: BorderRadius.circular(TM.r16), border: Border.all(color: TM.aBorder)),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: TM.aText)),
        const SizedBox(height: 2),
        Text(badge, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
      ]),
    ),
  );
}

class _TopProductRow extends StatelessWidget {
  final Product product;
  const _TopProductRow({required this.product});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: TM.aCard,
      borderRadius: BorderRadius.circular(TM.r14), border: Border.all(color: TM.aBorder)),
    child: Row(children: [
      Container(width: 44, height: 44,
        decoration: BoxDecoration(color: TM.aCard2, borderRadius: BorderRadius.circular(TM.r12)),
        child: Center(child: Text(product.imageEmoji, style: const TextStyle(fontSize: 24)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.aText)),
        Text(product.categoryName, style: const TextStyle(fontSize: 11, color: TM.aText2)),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(TM.formatPrice(product.price),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: TM.aBlue)),
        Text('${product.reviewCount} maagizo', style: const TextStyle(fontSize: 10, color: TM.aText2)),
      ]),
    ]),
  );
}

class _AdminHeaderBtn extends StatelessWidget {
  final String emoji;
  final int badgeCount;
  final VoidCallback onTap;
  const _AdminHeaderBtn({required this.emoji, this.badgeCount = 0, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Stack(clipBehavior: Clip.none, children: [
      Container(width: 38, height: 38,
        decoration: BoxDecoration(color: TM.aCard,
          borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.aBorder)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 17)))),
      if (badgeCount > 0)
        Positioned(top: -3, right: -3,
          child: Container(width: 16, height: 16,
            decoration: const BoxDecoration(color: TM.red, shape: BoxShape.circle),
            child: Center(child: Text('$badgeCount',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white))))),
    ]),
  );
}
