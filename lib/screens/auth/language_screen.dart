import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../models/app_models.dart';
import '../../utils/app_theme.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Language _selected = Language.swahili;

  final _langs = [
    {'lang': Language.swahili, 'flag': '🇹🇿', 'name': 'Kiswahili', 'native': 'Tanzania, Kenya, Afrika Mashariki'},
    {'lang': Language.english, 'flag': '🇬🇧', 'name': 'English',   'native': 'International'},
    {'lang': Language.french,  'flag': '🇫🇷', 'name': 'Français',  'native': 'France, Belgique, Afrique'},
    {'lang': Language.arabic,  'flag': '🇸🇦', 'name': 'العربية',   'native': 'الشرق الأوسط وشمال أفريقيا'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0F), Color(0xFF0A1020)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(TM.p24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Logo
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: TM.primaryGrad,
                        borderRadius: BorderRadius.circular(TM.r16),
                      ),
                      child: const Center(
                        child: Text('🛒', style: TextStyle(fontSize: 26)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(text: 'Twende ', style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800, color: TM.text,
                          )),
                          TextSpan(text: 'Markiti', style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800, color: TM.primary,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text('Chagua Lugha', style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w800, color: TM.text,
                )),
                const Text('Choose Language', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: TM.primary,
                )),
                const SizedBox(height: 6),
                const Text(
                  'Tumia lugha unayoipendelea\nSelect your preferred language',
                  style: TextStyle(fontSize: 13, color: TM.text2, height: 1.5),
                ),
                const SizedBox(height: 28),
                // Language cards
                Expanded(
                  child: ListView.separated(
                    itemCount: _langs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final l = _langs[i];
                      final lang = l['lang'] as Language;
                      final isSelected = _selected == lang;
                      return GestureDetector(
                        onTap: () => setState(() => _selected = lang),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(TM.p16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? TM.primary.withOpacity(.08)
                                : TM.card,
                            borderRadius: BorderRadius.circular(TM.r16),
                            border: Border.all(
                              color: isSelected ? TM.primary.withOpacity(.4) : TM.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(l['flag'] as String,
                                style: const TextStyle(fontSize: 32)),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w700, color: TM.text,
                                      )),
                                    const SizedBox(height: 2),
                                    Text(l['native'] as String,
                                      style: const TextStyle(fontSize: 12, color: TM.text2)),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 22, height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? TM.primary.withOpacity(.2) : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? TM.primary : TM.text3,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 13, color: TM.primary)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    context.read<LanguageProvider>().setLanguage(_selected);
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: TM.primaryGrad,
                      borderRadius: BorderRadius.circular(TM.r16),
                      boxShadow: TM.primaryGlow,
                    ),
                    child: const Center(
                      child: Text(
                        'Endelea / Continue  →',
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
