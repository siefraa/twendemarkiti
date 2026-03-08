import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../models/app_models.dart';
import '../../utils/app_theme.dart';
import '../../utils/seed_data.dart';
import '../../widgets/common_widgets.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _sortBy = 'popular';

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>();
    final cart     = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final list     = products.filtered;

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(TM.p20, TM.p16, TM.p20, TM.p8),
            child: Row(children: [
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Duka 🏪', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: TM.text)),
                Text('156 bidhaa zinapatikana', style: TextStyle(fontSize: 12, color: TM.text2)),
              ])),
              _SortButton(value: _sortBy, onChanged: (v) { setState(() => _sortBy = v!); products.setSortBy(v!); }),
            ]),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: TM.p20, vertical: TM.p8),
            child: TMSearchBar(
              hint: 'Tafuta bidhaa...',
              onChanged: products.search,
            ),
          ),
          // Categories horizontal
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: TM.p20),
              itemCount: SeedData.categories.length,
              itemBuilder: (_, i) {
                final cat = SeedData.categories[i];
                final active = products.selectedCategory == cat.id;
                return GestureDetector(
                  onTap: () => products.setCategory(cat.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? cat.color.withOpacity(.12) : TM.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: active ? cat.color : TM.border, width: active ? 1.5 : 1),
                    ),
                    child: Row(children: [
                      Text(cat.emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 5),
                      Text(cat.name, style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: active ? cat.color : TM.text2)),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Products grid
          Expanded(
            child: list.isEmpty
                ? const TMEmptyState(emoji: '🔍', title: 'Hakuna bidhaa', subtitle: 'Jaribu maneno mengine ya kutafuta')
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: TM.p20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                      childAspectRatio: .72,
                    ),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final p = list[i];
                      return ProductCard(
                        product: p,
                        isFavorite: wishlist.contains(p.id),
                        onFavToggle: () => wishlist.toggle(p),
                        onTap: () => Navigator.of(context).pushNamed('/product', arguments: p),
                        onAddToCart: () {
                          cart.add(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('✅ ${p.name} imeongezwa!')),
                          );
                        },
                      );
                    },
                  ),
          ),
        ]),
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const _SortButton({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(color: TM.card,
      borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.border)),
    child: DropdownButton<String>(
      value: value, isDense: true, underline: const SizedBox(),
      dropdownColor: TM.card2,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: TM.text),
      items: const [
        DropdownMenuItem(value: 'popular',    child: Text('Maarufu')),
        DropdownMenuItem(value: 'price_asc',  child: Text('Bei: Chini-Juu')),
        DropdownMenuItem(value: 'price_desc', child: Text('Bei: Juu-Chini')),
        DropdownMenuItem(value: 'rating',     child: Text('Kura za Juu')),
        DropdownMenuItem(value: 'name',       child: Text('Jina A-Z')),
      ],
      onChanged: onChanged,
    ),
  );
}
