import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../models/app_models.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

// ═══════════════════════════════════════════════════════
//  ORDERS SCREEN
// ═══════════════════════════════════════════════════════

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 5, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();
    final auth   = context.watch<AuthProvider>();
    final myOrders = orders.getByCustomer(auth.user?.id ?? '');

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Maagizo Yangu 📦', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: TM.text)),
                Text('Fuatilia maagizo yako', style: TextStyle(fontSize: 12, color: TM.text2)),
              ]),
            ]),
          ),
          TabBar(
            controller: _tab,
            isScrollable: true,
            labelColor: TM.primary,
            unselectedLabelColor: TM.text2,
            indicatorColor: TM.primary,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: 'Yote'),
              Tab(text: '⏳ Inasubiri'),
              Tab(text: '🚚 Inasafirishwa'),
              Tab(text: '✅ Imefikishwa'),
              Tab(text: '❌ Imefutwa'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _OrdersList(orders: myOrders),
                _OrdersList(orders: myOrders.where((o) => o.status == OrderStatus.pending).toList()),
                _OrdersList(orders: myOrders.where((o) => o.status == OrderStatus.shipping).toList()),
                _OrdersList(orders: myOrders.where((o) => o.status == OrderStatus.delivered).toList()),
                _OrdersList(orders: myOrders.where((o) => o.status == OrderStatus.cancelled).toList()),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<AppOrder> orders;
  const _OrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const TMEmptyState(
      emoji: '📦', title: 'Hakuna maagizo',
      subtitle: 'Maagizo yako yataonekana hapa');
    return ListView.builder(
      padding: const EdgeInsets.all(TM.p20),
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final order = orders[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(children: [
            // Order tracker for shipping
            if (order.status == OrderStatus.shipping)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(TM.p16),
                decoration: BoxDecoration(color: TM.card,
                  borderRadius: BorderRadius.circular(TM.r16), border: Border.all(color: TM.border)),
                child: Column(children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('🚚 Fuatilia Agizo', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.text)),
                      Text('📍 Kinondoni → Msasani', style: TextStyle(fontSize: 11, color: TM.blue)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _OrderTracker(status: order.status),
                ]),
              ),
            OrderCard(order: order),
          ]),
        );
      },
    );
  }
}

class _OrderTracker extends StatelessWidget {
  final OrderStatus status;
  const _OrderTracker({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'label': 'Imethibitishwa', 'emoji': '✓', 'done': true},
      {'label': 'Inatayarishwa', 'emoji': '👨‍🍳', 'done': true},
      {'label': 'Inasafirishwa', 'emoji': '🚚', 'active': true},
      {'label': 'Imefikishwa', 'emoji': '📍', 'done': false},
    ];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepI = i ~/ 2;
          final done = (steps[stepI]['done'] as bool?) ?? false;
          final nextDone = (steps[stepI + 1]['done'] as bool?) ?? false;
          return Expanded(child: Container(
            height: 2,
            color: (done && nextDone) ? TM.green : TM.border,
          ));
        }
        final step = steps[i ~/ 2];
        final done = (step['done'] as bool?) ?? false;
        final active = (step['active'] as bool?) ?? false;
        return Column(children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              color: done ? TM.green.withOpacity(.2) : active ? TM.primary.withOpacity(.2) : TM.card2,
              shape: BoxShape.circle,
              border: Border.all(
                color: done ? TM.green : active ? TM.primary : TM.border, width: 2)),
            child: Center(child: Text(step['emoji'] as String, style: const TextStyle(fontSize: 13))),
          ),
          const SizedBox(height: 4),
          SizedBox(width: 50, child: Text(step['label'] as String,
            style: const TextStyle(fontSize: 8, color: TM.text2), textAlign: TextAlign.center)),
        ]);
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  PROFILE SCREEN
// ═══════════════════════════════════════════════════════

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    if (user == null) return const SizedBox();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
            // Header
            Container(
              padding: const EdgeInsets.all(TM.p20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [TM.card2, TM.bg],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Column(children: [
                Row(children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(gradient: TM.primaryGrad, borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: TM.primary.withOpacity(.3), blurRadius: 16)]),
                    child: Center(child: Text(user.avatarUrl.isEmpty ? '👤' : user.initials,
                      style: const TextStyle(fontSize: 28, color: Colors.black))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TM.text)),
                    Text(user.email, style: const TextStyle(fontSize: 12, color: TM.text2)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(color: TM.primary.withOpacity(.12),
                        borderRadius: BorderRadius.circular(20)),
                      child: Text('⭐ ${user.membershipLevel}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: TM.primary))),
                  ])),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: TM.primary.withOpacity(.4)),
                        borderRadius: BorderRadius.circular(TM.r12)),
                      child: const Text('Hariri', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TM.primary)))),
                ]),
                const SizedBox(height: 20),
                // Stats
                Row(children: [
                  _ProfileStat(value: '${user.totalOrders}', label: 'Maagizo'),
                  _Divider(),
                  _ProfileStat(value: '${user.loyaltyPoints}', label: 'Pointi'),
                  _Divider(),
                  _ProfileStat(value: '${user.rating}', label: 'Kura Yangu'),
                  _Divider(),
                  _ProfileStat(value: TM.formatPrice(user.totalSpending).replaceAll('TZS ', '').replaceAll(',000', 'K'), label: 'Matumizi'),
                ]),
              ]),
            ),
            // Loyalty card
            Padding(
              padding: const EdgeInsets.all(TM.p20),
              child: Container(
                padding: const EdgeInsets.all(TM.p16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1A1030), Color(0xFF2A1060)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(TM.r20),
                ),
                child: Row(children: [
                  const Text('🏆', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Pointi za Uaminifu', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.text)),
                    const SizedBox(height: 4),
                    Text('${user.loyaltyPoints} pointi · Thamani TZS ${user.loyaltyPoints * 10}',
                      style: const TextStyle(fontSize: 11.5, color: TM.text2)),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (user.loyaltyPoints % 500) / 500,
                        backgroundColor: Colors.white.withOpacity(.1),
                        color: TM.primary, minHeight: 6)),
                    const SizedBox(height: 4),
                    Text('${500 - user.loyaltyPoints % 500} pointi hadi ngazi inayofuata',
                      style: const TextStyle(fontSize: 10, color: TM.text2)),
                  ])),
                ]),
              ),
            ),
            // Menu
            _MenuSection(title: 'Akaunti', items: [
              _MenuItem(emoji: '📍', color: TM.blue, label: 'Anwani zangu', sub: '2 zimehifadhiwa', onTap: () {}),
              _MenuItem(emoji: '💳', color: TM.green, label: 'Njia za Malipo', sub: 'M-Pesa · Kadi', onTap: () {}),
              _MenuItem(emoji: '❤️', color: TM.red, label: 'Vipendwa Vyangu', sub: 'Angalia wishlist', onTap: () {}),
              _MenuItem(emoji: '🎁', color: TM.aYellow, label: 'Alika Rafiki', sub: 'Pata TZS 500 kwa kila rafiki', onTap: () {}),
            ]),
            _MenuSection(title: 'Mipangilio', items: [
              _MenuItem(emoji: '🌍', color: TM.aPurple, label: 'Lugha / Language', sub: 'Kiswahili',
                onTap: () => Navigator.of(context).pushNamed('/language')),
              _MenuItem(emoji: '🔔', color: TM.aYellow, label: 'Arifa', sub: 'Zote zimewashwa', badge: '3', onTap: () {}),
              _MenuItem(emoji: '🔒', color: TM.red, label: 'Usalama', sub: 'PIN · Alama ya Kidole', onTap: () {}),
              _MenuItem(emoji: '🎨', color: TM.accent, label: 'Mandhari', sub: 'Giza · Mwanga', onTap: () {}),
              _MenuItem(emoji: 'ℹ️', color: TM.text2, label: 'Kuhusu Programu', sub: 'Toleo 2.0.0', onTap: () {}),
              _MenuItem(emoji: '❓', color: TM.blue, label: 'Msaada', sub: 'Maswali na Majibu', onTap: () {}),
            ]),
            Padding(
              padding: const EdgeInsets.all(TM.p20),
              child: GestureDetector(
                onTap: () { auth.logout(); Navigator.of(context).pushReplacementNamed('/login'); },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(color: TM.red.withOpacity(.3)),
                    borderRadius: BorderRadius.circular(TM.r16)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('🚪', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text('Toka', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: TM.red)),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value, label;
  const _ProfileStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: TM.text)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 10, color: TM.text2)),
    ]),
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 32, color: TM.border);
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection({required this.title, required this.items});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: TM.p20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title.toUpperCase(), style: const TextStyle(
        fontSize: 10.5, fontWeight: FontWeight.w700, color: TM.text2, letterSpacing: .1)),
      const SizedBox(height: 8),
      ...items,
      const SizedBox(height: 20),
    ]),
  );
}

class _MenuItem extends StatelessWidget {
  final String emoji, label, sub;
  final Color color;
  final String? badge;
  final VoidCallback? onTap;
  const _MenuItem({required this.emoji, required this.color, required this.label,
    required this.sub, this.badge, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: TM.card,
        borderRadius: BorderRadius.circular(TM.r14), border: Border.all(color: TM.border)),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(TM.r12)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 17)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: TM.text)),
          Text(sub, style: const TextStyle(fontSize: 11, color: TM.text2)),
        ])),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(color: TM.primary, borderRadius: BorderRadius.circular(8)),
            child: Text(badge!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black)))
        else
          const Text('›', style: TextStyle(fontSize: 18, color: TM.text2)),
      ]),
    ),
  );
}
