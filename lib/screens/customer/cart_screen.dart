import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../models/app_models.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponCtrl = TextEditingController();
  String? _couponMsg;
  bool _couponSuccess = false;

  final _payMethods = [
    {'id': 'mpesa',  'emoji': '📱', 'name': 'M-Pesa'},
    {'id': 'airtel', 'emoji': '📲', 'name': 'Airtel'},
    {'id': 'card',   'emoji': '💳', 'name': 'Kadi'},
    {'id': 'cash',   'emoji': '💵', 'name': 'Taslimu'},
    {'id': 'bank',   'emoji': '🏦', 'name': 'Benki'},
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // Header
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
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Kikapu Changu 🛒', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: TM.text)),
                Text('Bidhaa ${cart.count}', style: const TextStyle(fontSize: 11.5, color: TM.text2)),
              ]),
            ]),
          ),
          // Body
          Expanded(
            child: cart.items.isEmpty
                ? TMEmptyState(
                    emoji: '🛒', title: 'Kikapu chako ni tupu',
                    subtitle: 'Ongeza bidhaa kutoka dukani kuendelea',
                    actionLabel: '🏪 Nenda Dukani',
                    onAction: () => Navigator.pop(context))
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      // Cart items
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                        itemCount: cart.items.length,
                        itemBuilder: (_, i) => _CartItem(item: cart.items[i], cart: cart),
                      ),
                      const SizedBox(height: 4),
                      // Coupon
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
                        child: Column(children: [
                          Row(children: [
                            Expanded(
                              child: TextField(
                                controller: _couponCtrl,
                                style: const TextStyle(color: TM.text, fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Weka nambari ya punguzo...',
                                  hintStyle: const TextStyle(color: TM.text3, fontSize: 13),
                                  filled: true, fillColor: TM.card,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TM.r14),
                                    borderSide: const BorderSide(color: TM.border)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(TM.r14),
                                    borderSide: const BorderSide(color: TM.border)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: _applyCoupon,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                decoration: BoxDecoration(
                                  color: TM.primary.withOpacity(.12),
                                  borderRadius: BorderRadius.circular(TM.r14),
                                  border: Border.all(color: TM.primary.withOpacity(.3))),
                                child: const Text('Tumia', style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700, color: TM.primary)),
                              ),
                            ),
                          ]),
                          if (_couponMsg != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: (_couponSuccess ? TM.green : TM.red).withOpacity(.1),
                                borderRadius: BorderRadius.circular(TM.r12),
                                border: Border.all(color: (_couponSuccess ? TM.green : TM.red).withOpacity(.3))),
                              child: Row(children: [
                                Text(_couponSuccess ? '✅' : '❌', style: const TextStyle(fontSize: 14)),
                                const SizedBox(width: 8),
                                Text(_couponMsg!, style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600,
                                  color: _couponSuccess ? TM.green : TM.red)),
                              ]),
                            ),
                          ],
                        ]),
                      ),
                      // Payment methods
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('💳 Njia ya Malipo',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: TM.text)),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _payMethods.length,
                              itemBuilder: (_, i) {
                                final m = _payMethods[i];
                                final active = cart.selectedPayment == m['id'];
                                return GestureDetector(
                                  onTap: () => cart.setPaymentMethod(m['id']!),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: active ? TM.primary.withOpacity(.08) : TM.card,
                                      borderRadius: BorderRadius.circular(TM.r14),
                                      border: Border.all(
                                        color: active ? TM.primary.withOpacity(.4) : TM.border,
                                        width: active ? 1.5 : 1)),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text(m['emoji']!, style: const TextStyle(fontSize: 22)),
                                      const SizedBox(height: 4),
                                      Text(m['name']!, style: TextStyle(
                                        fontSize: 10.5, fontWeight: FontWeight.w700,
                                        color: active ? TM.primary : TM.text2)),
                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                      ),
                      // Delivery address
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(color: TM.card,
                            borderRadius: BorderRadius.circular(TM.r16), border: Border.all(color: TM.border)),
                          child: Row(children: [
                            Container(width: 36, height: 36,
                              decoration: BoxDecoration(color: TM.blue.withOpacity(.12),
                                borderRadius: BorderRadius.circular(10)),
                              child: const Center(child: Text('📍', style: TextStyle(fontSize: 18)))),
                            const SizedBox(width: 12),
                            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Anwani ya Utoaji', style: TextStyle(fontSize: 11, color: TM.text2)),
                              SizedBox(height: 2),
                              Text('Msasani Road 14, Dar es Salaam',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.text)),
                            ])),
                            const Text('Badilisha', style: TextStyle(fontSize: 12, color: TM.primary, fontWeight: FontWeight.w700)),
                          ]),
                        ),
                      ),
                      // Order summary
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
                        child: Container(
                          padding: const EdgeInsets.all(TM.p16),
                          decoration: BoxDecoration(color: TM.card,
                            borderRadius: BorderRadius.circular(TM.r16), border: Border.all(color: TM.border)),
                          child: Column(children: [
                            _SummaryRow(label: 'Jumla ya Bidhaa', value: TM.formatPrice(cart.subtotal)),
                            if (cart.discountAmount > 0)
                              _SummaryRow(label: 'Punguzo (${cart.appliedCoupon})',
                                value: '-${TM.formatPrice(cart.discountAmount)}', valueColor: TM.green),
                            _SummaryRow(
                              label: cart.deliveryFee == 0 ? '🚚 Utoaji Bure!' : 'Usafirishaji',
                              value: cart.deliveryFee == 0 ? 'BURE' : TM.formatPrice(cart.deliveryFee),
                              valueColor: cart.deliveryFee == 0 ? TM.green : null),
                            const Divider(color: TM.border, height: 20),
                            _SummaryRow(
                              label: 'Jumla Yote', value: TM.formatPrice(cart.total),
                              isTotal: true),
                          ]),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ]),
                  ),
          ),
          // Checkout bar
          if (cart.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(TM.p20, TM.p12, TM.p20, TM.p20),
              decoration: BoxDecoration(
                color: TM.bg.withOpacity(.95),
                border: const Border(top: BorderSide(color: TM.border))),
              child: GestureDetector(
                onTap: _placeOrder,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(gradient: TM.primaryGrad,
                    borderRadius: BorderRadius.circular(TM.r16), boxShadow: TM.primaryGlow),
                  child: Center(
                    child: Text('🛒  Tuma Agizo  •  ${TM.formatPrice(cart.total)}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black)),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }

  void _applyCoupon() {
    final ok = context.read<CartProvider>().applyCoupon(_couponCtrl.text);
    setState(() {
      _couponSuccess = ok;
      _couponMsg = ok ? 'Punguzo limetumika! Umehifadhi TZS 980' : 'Nambari si sahihi. Jaribu: TWENDE10';
    });
  }

  void _placeOrder() {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    if (auth.user == null) return;
    context.read<OrdersProvider>().placeOrder(cart, auth.user!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🎉 Agizo limetumwa kikamilifu!'), backgroundColor: Colors.green));
    Navigator.of(context).pushReplacementNamed('/orders');
  }
}

class _CartItem extends StatelessWidget {
  final CartItem item;
  final CartProvider cart;
  const _CartItem({required this.item, required this.cart});

  @override
  Widget build(BuildContext context) => Dismissible(
    key: Key(item.product.id),
    direction: DismissDirection.endToStart,
    onDismissed: (_) => cart.remove(item.product.id),
    background: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: TM.red.withOpacity(.2),
        borderRadius: BorderRadius.circular(TM.r16)),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Text('🗑️', style: TextStyle(fontSize: 24)),
    ),
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: TM.card,
        borderRadius: BorderRadius.circular(TM.r16), border: Border.all(color: TM.border)),
      child: Row(children: [
        Container(width: 60, height: 60,
          decoration: BoxDecoration(color: TM.card2, borderRadius: BorderRadius.circular(TM.r12)),
          child: Center(child: Text(item.product.imageEmoji, style: const TextStyle(fontSize: 32)))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: TM.text)),
          const SizedBox(height: 2),
          Text('${item.product.unit} · ${item.product.badges.first}',
            style: const TextStyle(fontSize: 11, color: TM.text2)),
          const SizedBox(height: 4),
          Text(TM.formatPrice(item.product.price),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: TM.primary)),
        ])),
        Row(children: [
          _CQBtn(icon: '−', onTap: () => cart.updateQty(item.product.id, item.quantity - 1)),
          SizedBox(width: 32,
            child: Center(child: Text('${item.quantity}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: TM.text)))),
          _CQBtn(icon: '+', onTap: () => cart.updateQty(item.product.id, item.quantity + 1)),
        ]),
      ]),
    ),
  );
}

class _CQBtn extends StatelessWidget {
  final String icon; final VoidCallback onTap;
  const _CQBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 28, height: 28,
      decoration: BoxDecoration(color: TM.primary.withOpacity(.12),
        borderRadius: BorderRadius.circular(TM.r8)),
      child: Center(child: Text(icon,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: TM.primary)))));
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isTotal;
  final Color? valueColor;
  const _SummaryRow({required this.label, required this.value, this.isTotal = false, this.valueColor});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Text(label, style: TextStyle(
        fontSize: isTotal ? 14 : 13,
        fontWeight: isTotal ? FontWeight.w800 : FontWeight.w400,
        color: isTotal ? TM.text : TM.text2)),
      const Spacer(),
      Text(value, style: TextStyle(
        fontSize: isTotal ? 18 : 13,
        fontWeight: FontWeight.w800,
        color: valueColor ?? (isTotal ? TM.primary : TM.text))),
    ]),
  );
}

