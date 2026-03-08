import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../utils/app_theme.dart';
import 'home_screen.dart';
import 'shop_screen.dart';
import 'cart_screen.dart';
import 'orders_profile_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/admin_screens.dart';

// ═══════════════════════════════════════════════════════
//  CUSTOMER SHELL - Bottom Navigation Wrapper
// ═══════════════════════════════════════════════════════

class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});
  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _tab = 0;

  final _screens = const [
    HomeScreen(),
    ShopScreen(),
    CartScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: IndexedStack(index: _tab, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: TM.bg.withOpacity(.95),
          border: const Border(top: BorderSide(color: TM.border)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.3), blurRadius: 20)],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(emoji: '🏠', label: 'Nyumbani', active: _tab == 0, onTap: () => _go(0)),
                _NavItem(emoji: '🏪', label: 'Duka',     active: _tab == 1, onTap: () => _go(1)),
                _NavItem(emoji: '🛒', label: 'Kikapu',   active: _tab == 2, onTap: () => _go(2), badge: cart.count),
                _NavItem(emoji: '📦', label: 'Maagizo',  active: _tab == 3, onTap: () => _go(3)),
                _NavItem(emoji: '👤', label: 'Akaunti',  active: _tab == 4, onTap: () => _go(4)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int i) => setState(() => _tab = i);
}

// ═══════════════════════════════════════════════════════
//  ADMIN SHELL - Bottom Navigation Wrapper
// ═══════════════════════════════════════════════════════

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _tab = 0;

  final _screens = const [
    AdminDashboardScreen(),
    AdminOrdersScreen(),
    AdminProductsScreen(),
    AdminCustomersScreen(),
    AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _tab, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: TM.aBg.withOpacity(.95),
          border: const Border(top: BorderSide(color: TM.aBorder)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.4), blurRadius: 20)],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(emoji: '📊', label: 'Dashibodi', active: _tab == 0, onTap: () => _go(0), isAdmin: true),
                _NavItem(emoji: '📦', label: 'Maagizo',   active: _tab == 1, onTap: () => _go(1), isAdmin: true),
                _NavItem(emoji: '🏪', label: 'Bidhaa',    active: _tab == 2, onTap: () => _go(2), isAdmin: true),
                _NavItem(emoji: '👥', label: 'Wateja',    active: _tab == 3, onTap: () => _go(3), isAdmin: true),
                _NavItem(emoji: '⚙️', label: 'Mipangilio',active: _tab == 4, onTap: () => _go(4), isAdmin: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _go(int i) => setState(() => _tab = i);
}

// ── Nav Item ───────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final String emoji, label;
  final bool active;
  final bool isAdmin;
  final VoidCallback onTap;
  final int badge;

  const _NavItem({
    required this.emoji, required this.label,
    required this.active, required this.onTap,
    this.isAdmin = false, this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = isAdmin ? TM.aBlue : TM.primary;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: active ? color.withOpacity(.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(clipBehavior: Clip.none, children: [
              Text(emoji, style: TextStyle(fontSize: active ? 22 : 20)),
              if (badge > 0) Positioned(
                top: -4, right: -6,
                child: Container(
                  width: 15, height: 15,
                  decoration: const BoxDecoration(color: TM.red, shape: BoxShape.circle),
                  child: Center(child: Text('$badge',
                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.white))))),
            ]),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(
              fontSize: 9, fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              color: active ? color : (isAdmin ? const Color(0xFF6B7280) : TM.text3),
            )),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  NOTIFICATIONS SCREEN (shared)
// ═══════════════════════════════════════════════════════

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifs = context.watch<NotificationProvider>();
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: TM.card,
                    borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.border)),
                  child: const Center(child: Text('←', style: TextStyle(fontSize: 20, color: TM.text))))),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Arifa 🔔', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TM.text)),
                Text('${notifs.unreadCount} mpya', style: const TextStyle(fontSize: 12, color: TM.text2)),
              ]),
              const Spacer(),
              GestureDetector(
                onTap: notifs.markAllRead,
                child: const Text('Soma Zote', style: TextStyle(fontSize: 12, color: TM.primary, fontWeight: FontWeight.w700))),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(TM.p20),
              itemCount: notifs.all.length,
              itemBuilder: (_, i) {
                final n = notifs.all[i];
                return GestureDetector(
                  onTap: () => notifs.markRead(n.id),
                  child: AnimatedOpacity(
                    opacity: n.isRead ? 0.6 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: n.isRead ? TM.card : n.color.withOpacity(.06),
                        borderRadius: BorderRadius.circular(TM.r14),
                        border: Border.all(color: n.isRead ? TM.border : n.color.withOpacity(.2))),
                      child: Row(children: [
                        Container(width: 44, height: 44,
                          decoration: BoxDecoration(color: n.color.withOpacity(.12), borderRadius: BorderRadius.circular(TM.r12)),
                          child: Center(child: Text(n.emoji, style: const TextStyle(fontSize: 22)))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(n.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                            color: n.isRead ? TM.text2 : TM.text)),
                          const SizedBox(height: 3),
                          Text(n.body, style: const TextStyle(fontSize: 11.5, color: TM.text2, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(_formatTime(n.createdAt), style: TextStyle(fontSize: 10, color: n.color, fontWeight: FontWeight.w700)),
                        ])),
                        if (!n.isRead) Container(width: 8, height: 8,
                          decoration: BoxDecoration(color: n.color, shape: BoxShape.circle)),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return 'Dakika ${diff.inMinutes} zilizopita';
    if (diff.inHours < 24)   return 'Saa ${diff.inHours} zilizopita';
    return 'Siku ${diff.inDays} zilizopita';
  }
}
