import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'amina@gmail.com');
  final _passCtrl  = TextEditingController(text: '123456');
  final _formKey   = GlobalKey<FormState>();
  bool _asAdmin    = false;
  bool _obscure    = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0F), Color(0xFF0A0A0F)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TM.p24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Logo row
                  Row(
                    children: [
                      Container(
                        width: 42, height: 42,
                        decoration: BoxDecoration(
                          gradient: TM.primaryGrad,
                          borderRadius: BorderRadius.circular(TM.r12),
                        ),
                        child: const Center(child: Text('🛒', style: TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(text: 'Twende ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: TM.text)),
                          TextSpan(text: 'Markiti', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: TM.primary)),
                        ]),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/language'),
                        child: const Text('🌍', style: TextStyle(fontSize: 22)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _asAdmin ? 'Msimamizi 👨‍💼' : 'Karibu Tena! 👋',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: TM.text),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _asAdmin ? 'Ingia kama msimamizi wa duka' : 'Ingia akaunti yako ili uendelee',
                    style: const TextStyle(fontSize: 13, color: TM.text2),
                  ),
                  const SizedBox(height: 28),
                  // Role switcher
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: TM.card,
                      borderRadius: BorderRadius.circular(TM.r12),
                      border: Border.all(color: TM.border),
                    ),
                    child: Row(
                      children: [
                        _RoleTab(label: '👤 Mteja', active: !_asAdmin, onTap: () => setState(() => _asAdmin = false)),
                        _RoleTab(label: '🔧 Msimamizi', active: _asAdmin, onTap: () => setState(() => _asAdmin = true)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Email
                  TMTextField(
                    label: 'Barua Pepe / Nambari',
                    hint: 'amina@example.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixEmoji: '📧',
                    validator: (v) => v!.isEmpty ? 'Weka barua pepe' : null,
                  ),
                  const SizedBox(height: 16),
                  // Password
                  TMTextField(
                    label: 'Nenosiri',
                    hint: '••••••••',
                    controller: _passCtrl,
                    obscure: _obscure,
                    prefixEmoji: '🔒',
                    suffix: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: TM.text2, size: 20),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                    validator: (v) => v!.length < 4 ? 'Nenosiri fupi mno' : null,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Umesahau nenosiri?',
                      style: const TextStyle(fontSize: 12.5, color: TM.primary, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 24),
                  // Login button
                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => GestureDetector(
                      onTap: auth.isLoading ? null : _doLogin,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: _asAdmin ? TM.adminGrad : TM.primaryGrad,
                          borderRadius: BorderRadius.circular(TM.r16),
                          boxShadow: _asAdmin ? TM.adminGlow : TM.primaryGlow,
                        ),
                        child: Center(
                          child: auth.isLoading
                              ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5)
                              : Text(
                                  _asAdmin ? '🔧 Ingia kama Msimamizi →' : '🛒 Ingia →',
                                  style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700,
                                    color: _asAdmin ? Colors.white : Colors.black,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: TM.border)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('au ingia na', style: TextStyle(fontSize: 12, color: TM.text2)),
                      ),
                      const Expanded(child: Divider(color: TM.border)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _SocialBtn(emoji: '🔵', label: 'Google',   onTap: () {}),
                      const SizedBox(width: 10),
                      _SocialBtn(emoji: '📘', label: 'Facebook', onTap: () {}),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Huna akaunti? ", style: TextStyle(fontSize: 13, color: TM.text2)),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed('/register'),
                        child: const Text('Jisajili sasa',
                          style: TextStyle(fontSize: 13, color: TM.primary, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _doLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_emailCtrl.text, _passCtrl.text, asAdmin: _asAdmin);
    if (ok && mounted) {
      Navigator.of(context).pushReplacementNamed(_asAdmin ? '/admin' : '/home');
    }
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _RoleTab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: active ? TM.primaryGrad : null,
            borderRadius: BorderRadius.circular(TM.r8),
          ),
          child: Center(
            child: Text(label, style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700,
              color: active ? Colors.black : TM.text2,
            )),
          ),
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _SocialBtn({required this.emoji, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: TM.card,
            borderRadius: BorderRadius.circular(TM.r12),
            border: Border.all(color: TM.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: TM.text2)),
            ],
          ),
        ),
      ),
    );
  }
}
