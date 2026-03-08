import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../models/app_models.dart';
import '../../utils/app_theme.dart';
import '../../utils/seed_data.dart';
import '../../widgets/common_widgets.dart';

// ═══════════════════════════════════════════════════════
//  ADMIN ORDERS SCREEN
// ═══════════════════════════════════════════════════════

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});
  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 5, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: TM.aBg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: TM.aCard,
                    borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.aBorder)),
                  child: const Center(child: Text('←', style: TextStyle(fontSize: 20, color: TM.aText))))),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Maagizo 📦', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TM.aText)),
                Text('${orders.all.length} maagizo yote', style: const TextStyle(fontSize: 11.5, color: TM.aText2)),
              ]),
              const Spacer(),
              const Text('🔍', style: TextStyle(fontSize: 20)),
            ]),
          ),
          TabBar(
            controller: _tab, isScrollable: true,
            labelColor: TM.aBlue, unselectedLabelColor: TM.aText2,
            indicatorColor: TM.aBlue,
            labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: 'Yote'), Tab(text: '⏳ Mapya'),
              Tab(text: '🚚 Yanasafirishwa'), Tab(text: '✅ Yamekamilika'), Tab(text: '❌ Yamefutwa'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _AdminOrderList(orders: orders.all, orders_: orders),
                _AdminOrderList(orders: orders.getByStatus(OrderStatus.pending), orders_: orders),
                _AdminOrderList(orders: orders.getByStatus(OrderStatus.shipping), orders_: orders),
                _AdminOrderList(orders: orders.getByStatus(OrderStatus.delivered), orders_: orders),
                _AdminOrderList(orders: orders.getByStatus(OrderStatus.cancelled), orders_: orders),
              ],
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TM.aBlue, elevation: 4,
        onPressed: () => _showAddOrderDialog(context),
        child: const Text('+', style: TextStyle(fontSize: 28, color: Colors.white)),
      ),
    );
  }

  void _showAddOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: TM.aCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TM.r20)),
        title: const Text('Ongeza Agizo', style: TextStyle(color: TM.aText, fontWeight: FontWeight.w800)),
        content: const Text('Kipengele hiki kitakuwa na fomu kamili ya kuongeza agizo jipya kwa mkono.',
          style: TextStyle(color: TM.aText2)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
            child: const Text('Funga', style: TextStyle(color: TM.aBlue))),
        ],
      ),
    );
  }
}

class _AdminOrderList extends StatelessWidget {
  final List<AppOrder> orders;
  final OrdersProvider orders_;
  const _AdminOrderList({required this.orders, required this.orders_});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) return const TMEmptyState(
      emoji: '📦', title: 'Hakuna maagizo', subtitle: 'Maagizo yataonekana hapa');
    return ListView.builder(
      padding: const EdgeInsets.all(TM.p20),
      itemCount: orders.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: OrderCard(
          order: orders[i], isAdminMode: true,
          onStatusChange: (s) {
            final ns = OrderStatus.values.firstWhere((x) => x.name == s);
            orders_.updateStatus(orders[i].id, ns);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Hali imebadilishwa!')));
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  ADMIN PRODUCTS SCREEN
// ═══════════════════════════════════════════════════════

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prods = context.watch<ProductsProvider>();

    return Scaffold(
      backgroundColor: TM.aBg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: TM.aCard,
                    borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.aBorder)),
                  child: const Center(child: Text('←', style: TextStyle(fontSize: 20, color: TM.aText))))),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Bidhaa 🏪', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TM.aText)),
                Text('${prods.all.length} bidhaa zote', style: const TextStyle(fontSize: 11.5, color: TM.aText2)),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
            child: TMSearchBar(hint: 'Tafuta bidhaa...', onChanged: prods.search),
          ),
          // Category chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: TM.p20),
              itemCount: SeedData.categories.length,
              itemBuilder: (_, i) {
                final cat = SeedData.categories[i];
                final active = prods.selectedCategory == cat.id;
                return GestureDetector(
                  onTap: () => prods.setCategory(cat.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: active ? TM.aBlue.withOpacity(.12) : TM.aCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? TM.aBlue : TM.aBorder, width: active ? 1.5 : 1)),
                    child: Text(cat.name, style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: active ? TM.aBlue : TM.aText2)),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: TM.p20),
              itemCount: prods.filtered.length,
              itemBuilder: (_, i) => _AdminProductRow(
                product: prods.filtered[i],
                onEdit: () => _showProductDialog(context, prods.filtered[i]),
                onDelete: () {
                  prods.deleteProduct(prods.filtered[i].id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🗑️ Bidhaa imefutwa')));
                },
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: TM.aBlue, elevation: 4,
        onPressed: () => _showProductDialog(context, null),
        child: const Text('+', style: TextStyle(fontSize: 28, color: Colors.white)),
      ),
    );
  }

  void _showProductDialog(BuildContext context, Product? product) {
    final nameCtrl  = TextEditingController(text: product?.name);
    final priceCtrl = TextEditingController(text: product?.price.toString());
    final stockCtrl = TextEditingController(text: product?.stockQuantity.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: TM.aCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: TM.aBorder, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text(product == null ? 'Ongeza Bidhaa Mpya' : 'Hariri Bidhaa',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: TM.aText)),
          const SizedBox(height: 20),
          _AdminField(label: 'Jina la Bidhaa', ctrl: nameCtrl, hint: 'Mfano: Embe la Alphonso'),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _AdminField(label: 'Bei (TZS)', ctrl: priceCtrl, hint: '3500', isNumber: true)),
            const SizedBox(width: 12),
            Expanded(child: _AdminField(label: 'Stoo', ctrl: stockCtrl, hint: '100', isNumber: true)),
          ]),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(product == null ? '✅ Bidhaa imeongezwa!' : '✅ Bidhaa imesasishwa!')));
            },
            child: Container(
              height: 52, decoration: BoxDecoration(gradient: TM.adminGrad,
                borderRadius: BorderRadius.circular(TM.r16)),
              child: Center(child: Text(product == null ? '✅ Ongeza Bidhaa' : '💾 Hifadhi Mabadiliko',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)))),
          ),
        ]),
      ),
    );
  }
}

class _AdminProductRow extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit, onDelete;
  const _AdminProductRow({required this.product, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final stockColor = product.stockStatus == StockStatus.inStock ? TM.aGreen
        : product.stockStatus == StockStatus.lowStock ? TM.aYellow : TM.red;
    final stockLabel = product.stockStatus == StockStatus.inStock ? 'Stoo OK (${product.stockQuantity})'
        : product.stockStatus == StockStatus.lowStock ? 'Kidogo (${product.stockQuantity})'
        : 'Imekwisha (0)';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: TM.aCard,
        borderRadius: BorderRadius.circular(TM.r16), border: Border.all(color: TM.aBorder)),
      child: Row(children: [
        Container(width: 52, height: 52, decoration: BoxDecoration(color: TM.aCard2,
          borderRadius: BorderRadius.circular(TM.r14)),
          child: Center(child: Text(product.imageEmoji, style: const TextStyle(fontSize: 28)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.aText)),
          Text('${product.categoryName} · ${product.unit}',
            style: const TextStyle(fontSize: 11, color: TM.aText2)),
          const SizedBox(height: 2),
          Text(TM.formatPrice(product.price),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: TM.aBlue)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: stockColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(6), border: Border.all(color: stockColor.withOpacity(.3))),
            child: Text(stockLabel, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: stockColor))),
          const SizedBox(height: 8),
          Row(children: [
            GestureDetector(
              onTap: onEdit,
              child: Container(width: 30, height: 30,
                decoration: BoxDecoration(color: TM.aBlue.withOpacity(.12), borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Text('✏️', style: TextStyle(fontSize: 13))))),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onDelete,
              child: Container(width: 30, height: 30,
                decoration: BoxDecoration(color: TM.red.withOpacity(.1), borderRadius: BorderRadius.circular(8)),
                child: const Center(child: Text('🗑️', style: TextStyle(fontSize: 13))))),
          ]),
        ]),
      ]),
    );
  }
}

class _AdminField extends StatelessWidget {
  final String label, hint;
  final TextEditingController ctrl;
  final bool isNumber;
  const _AdminField({required this.label, required this.hint, required this.ctrl, this.isNumber = false});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
      color: TM.aText2, letterSpacing: .08)),
    const SizedBox(height: 6),
    TextField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: TM.aText, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint, hintStyle: const TextStyle(color: TM.aText2, fontSize: 13),
        filled: true, fillColor: TM.aCard2,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: TM.aBorder)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: TM.aBorder)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11)),
    ),
  ]);
}

// ═══════════════════════════════════════════════════════
//  ADMIN CUSTOMERS SCREEN
// ═══════════════════════════════════════════════════════

class AdminCustomersScreen extends StatelessWidget {
  const AdminCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final custs = context.watch<CustomersProvider>();

    return Scaffold(
      backgroundColor: TM.aBg,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: TM.aCard,
                    borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.aBorder)),
                  child: const Center(child: Text('←', style: TextStyle(fontSize: 20, color: TM.aText))))),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Wateja 👥', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TM.aText)),
                Text('${custs.all.length} wote', style: const TextStyle(fontSize: 11.5, color: TM.aText2)),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
            child: TMSearchBar(hint: 'Tafuta wateja...', onChanged: custs.search),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: TM.p20),
              itemCount: custs.all.length,
              itemBuilder: (_, i) => _AdminCustomerCard(
                user: custs.all[i],
                onToggle: () {
                  custs.toggleActive(custs.all[i].id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(custs.all[i].isActive ? '✅ Mteja amewashwa' : '🚫 Mteja amezimwa')));
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _AdminCustomerCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onToggle;
  const _AdminCustomerCard({required this.user, required this.onToggle});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: TM.aCard,
      borderRadius: BorderRadius.circular(TM.r16), border: Border.all(color: TM.aBorder)),
    child: Row(children: [
      Container(width: 44, height: 44,
        decoration: BoxDecoration(gradient: TM.adminGrad, shape: BoxShape.circle),
        child: Center(child: Text(user.initials,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(user.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.aText)),
          const SizedBox(width: 6),
          if (!user.isActive) Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: TM.red.withOpacity(.12),
              borderRadius: BorderRadius.circular(6)),
            child: const Text('Imezimwa', style: TextStyle(fontSize: 9, color: TM.red, fontWeight: FontWeight.w700))),
        ]),
        Text(user.email, style: const TextStyle(fontSize: 11, color: TM.aText2)),
        const SizedBox(height: 4),
        Row(children: [
          Text('Maagizo: ', style: const TextStyle(fontSize: 10.5, color: TM.aText2)),
          Text('${user.totalOrders}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: TM.aText)),
          const SizedBox(width: 12),
          Text('Matumizi: ', style: const TextStyle(fontSize: 10.5, color: TM.aText2)),
          Text(TM.formatPrice(user.totalSpending).replaceAll('TZS ', ''),
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: TM.aGreen)),
        ]),
      ])),
      GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44, height: 24,
          decoration: BoxDecoration(
            color: user.isActive ? TM.aGreen : TM.aCard2,
            borderRadius: BorderRadius.circular(12)),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            alignment: user.isActive ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20, height: 20, margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
          ),
        ),
      ),
    ]),
  );
}

// ═══════════════════════════════════════════════════════
//  ADMIN SETTINGS SCREEN
// ═══════════════════════════════════════════════════════

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: TM.aBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TM.p20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Mipangilio ⚙️', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: TM.aText)),
            const Text('Dhibiti programu yako', style: TextStyle(fontSize: 12, color: TM.aText2)),
            const SizedBox(height: 24),
            _AdminMenuSection(title: 'Duka', items: [
              _AdminMenuItem(emoji: '🏪', label: 'Taarifa za Duka', sub: 'Jina, logo, anwani', onTap: () {}),
              _AdminMenuItem(emoji: '💰', label: 'Njia za Malipo', sub: 'M-Pesa, Airtel, Kadi, Benki', onTap: () {}),
              _AdminMenuItem(emoji: '🚚', label: 'Maeneo ya Utoaji', sub: 'Dar es Salaam, Mombasa, Nairobi', onTap: () {}),
              _AdminMenuItem(emoji: '🏷️', label: 'Vikwazo na Ofa', sub: 'Simamia vouchers na punguzo', onTap: () {}),
            ]),
            _AdminMenuSection(title: 'Mfumo', items: [
              _AdminMenuItem(emoji: '🌍', label: 'Lugha ya Mfumo', sub: 'Kiswahili / English',
                onTap: () => Navigator.of(context).pushNamed('/language')),
              _AdminMenuItem(emoji: '📊', label: 'Ripoti za Mapato', sub: 'Pakua PDF / Excel', onTap: () {}),
              _AdminMenuItem(emoji: '🔔', label: 'Arifa', sub: 'Push, SMS, Barua Pepe', onTap: () {}),
              _AdminMenuItem(emoji: '🔒', label: 'Usalama', sub: 'Nenosiri, 2FA, Vikao', onTap: () {}),
              _AdminMenuItem(emoji: '🎨', label: 'Mandhari ya Programu', sub: 'Rangi na muundo', onTap: () {}),
            ]),
            _AdminMenuSection(title: 'Akaunti ya Msimamizi', items: [
              _AdminMenuItem(emoji: '👨‍💼', label: 'Wasifu wa Msimamizi', sub: auth.user?.name ?? '', onTap: () {}),
              _AdminMenuItem(emoji: '👥', label: 'Wasimamizi Wengine', sub: 'Ongeza au ondoa wasimamizi', onTap: () {}),
              _AdminMenuItem(emoji: 'ℹ️', label: 'Kuhusu Programu', sub: 'Toleo 2.0.0 · Build 42', onTap: () {}),
            ]),
            GestureDetector(
              onTap: () { auth.logout(); Navigator.of(context).pushReplacementNamed('/login'); },
              child: Container(
                height: 52, margin: const EdgeInsets.only(top: 8),
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
            const SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }
}

class _AdminMenuSection extends StatelessWidget {
  final String title;
  final List<_AdminMenuItem> items;
  const _AdminMenuSection({required this.title, required this.items});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title.toUpperCase(), style: const TextStyle(
      fontSize: 10.5, fontWeight: FontWeight.w700, color: TM.aText2, letterSpacing: .1)),
    const SizedBox(height: 8),
    ...items,
    const SizedBox(height: 20),
  ]);
}

class _AdminMenuItem extends StatelessWidget {
  final String emoji, label, sub;
  final VoidCallback onTap;
  const _AdminMenuItem({required this.emoji, required this.label, required this.sub, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: TM.aCard,
        borderRadius: BorderRadius.circular(TM.r14), border: Border.all(color: TM.aBorder)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: TM.aText)),
          Text(sub, style: const TextStyle(fontSize: 11, color: TM.aText2)),
        ])),
        const Text('›', style: TextStyle(fontSize: 18, color: TM.aText2)),
      ]),
    ),
  );
}
