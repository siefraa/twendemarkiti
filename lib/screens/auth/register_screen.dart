import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _formKey   = GlobalKey<FormState>();
  bool _obscure    = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TM.p24),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: TM.card, borderRadius: BorderRadius.circular(TM.r12), border: Border.all(color: TM.border)),
                    child: const Center(child: Text('←', style: TextStyle(fontSize: 20, color: TM.text))),
                  ),
                ),
              ]),
              const SizedBox(height: 24),
              const Text('Fungua Akaunti! ✨', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: TM.text)),
              const SizedBox(height: 6),
              const Text('Jisajili ili uanze kununua', style: TextStyle(fontSize: 13, color: TM.text2)),
              const SizedBox(height: 28),
              TMTextField(label: 'Jina Kamili', hint: 'Amina Hassan', controller: _nameCtrl,
                prefixEmoji: '👤', validator: (v) => v!.isEmpty ? 'Weka jina' : null),
              const SizedBox(height: 16),
              TMTextField(label: 'Barua Pepe', hint: 'amina@example.com', controller: _emailCtrl,
                prefixEmoji: '📧', keyboardType: TextInputType.emailAddress,
                validator: (v) => !v!.contains('@') ? 'Barua pepe si sahihi' : null),
              const SizedBox(height: 16),
              TMTextField(label: 'Nambari ya Simu', hint: '+255 700 000 000', controller: _phoneCtrl,
                prefixEmoji: '📱', keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Weka nambari ya simu' : null),
              const SizedBox(height: 16),
              TMTextField(label: 'Nenosiri', hint: 'Angalau herufi 8', controller: _passCtrl,
                obscure: _obscure, prefixEmoji: '🔒',
                suffix: IconButton(
                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: TM.text2, size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure)),
                validator: (v) => v!.length < 6 ? 'Nenosiri fupi mno' : null),
              const SizedBox(height: 16),
              TMTextField(label: 'Thibitisha Nenosiri', hint: 'Rudia nenosiri', controller: _pass2Ctrl,
                obscure: true, prefixEmoji: '🔒',
                validator: (v) => v != _passCtrl.text ? 'Manenosiri hayafanani' : null),
              const SizedBox(height: 28),
              Consumer<AuthProvider>(
                builder: (_, auth, __) => GestureDetector(
                  onTap: auth.isLoading ? null : _doRegister,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(gradient: TM.primaryGrad,
                      borderRadius: BorderRadius.circular(TM.r16), boxShadow: TM.primaryGlow),
                    child: Center(
                      child: auth.isLoading
                          ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5)
                          : const Text('Jisajili →', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Una akaunti? ', style: TextStyle(fontSize: 13, color: TM.text2)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Ingia hapa', style: TextStyle(fontSize: 13, color: TM.primary, fontWeight: FontWeight.w700)),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  void _doRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().register(
      name: _nameCtrl.text, email: _emailCtrl.text,
      phone: _phoneCtrl.text, password: _passCtrl.text,
    );
    if (ok && mounted) Navigator.of(context).pushReplacementNamed('/home');
  }
}
