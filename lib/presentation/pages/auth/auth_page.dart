import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/router/app_router.dart';
import '../../controllers/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.routerState, required this.controller});

  final AppRouterState routerState;
  final AuthController controller;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _signInKey = GlobalKey<FormState>();
  final _signUpKey = GlobalKey<FormState>();
  final _forgotKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.controller.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = widget.controller;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('app_name')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.translate('sign_in')),
            Tab(text: l10n.translate('sign_up')),
            const Tab(text: 'Reset'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _SignInForm(formKey: _signInKey, controller: controller, onSuccess: _goHome),
          _SignUpForm(formKey: _signUpKey, controller: controller, onSuccess: _goHome),
          _ForgotForm(formKey: _forgotKey, controller: controller),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: OutlinedButton(
          onPressed: _goHome,
          child: Text(l10n.translate('continue_guest')),
        ),
      ),
    );
  }

  void _goHome() {
    widget.routerState.replace(AppPage.home);
  }
}

class _SignInForm extends StatelessWidget {
  const _SignInForm({required this.formKey, required this.controller, required this.onSuccess});

  final GlobalKey<FormState> formKey;
  final AuthController controller;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              decoration: InputDecoration(labelText: l10n.translate('email'), prefixIcon: const Icon(IconlyLight.message)),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.obscure,
                  validator: controller.validatePassword,
                  decoration: InputDecoration(
                    labelText: l10n.translate('password'),
                    prefixIcon: const Icon(IconlyLight.lock),
                    suffixIcon: IconButton(
                      icon: Icon(controller.obscure ? IconlyLight.show : IconlyLight.hide),
                      onPressed: controller.toggleObscure,
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    return Checkbox(
                      value: controller.rememberMe,
                      onChanged: (value) => controller.toggleRememberMe(value ?? false),
                    );
                  },
                ),
                Text(l10n.translate('remember_me')),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  onSuccess();
                }
              },
              child: Text(l10n.translate('sign_in')),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({required this.formKey, required this.controller, required this.onSuccess});

  final GlobalKey<FormState> formKey;
  final AuthController controller;
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              decoration: InputDecoration(labelText: l10n.translate('email'), prefixIcon: const Icon(IconlyLight.message)),
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: controller.obscure,
                      validator: controller.validatePassword,
                      decoration: InputDecoration(
                        labelText: l10n.translate('password'),
                        prefixIcon: const Icon(IconlyLight.lock),
                        suffixIcon: IconButton(
                          icon: Icon(controller.obscure ? IconlyLight.show : IconlyLight.hide),
                          onPressed: controller.toggleObscure,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: controller.strength,
                          color: _strengthColor(context, controller.strength),
                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _strengthLabel(l10n, controller.strength),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _RequirementChip(
                              label: l10n.translate('password_rule_length'),
                              met: controller.hasMinLength,
                            ),
                            _RequirementChip(
                              label: l10n.translate('password_rule_upper'),
                              met: controller.hasUppercase,
                            ),
                            _RequirementChip(
                              label: l10n.translate('password_rule_lower'),
                              met: controller.hasLowercase,
                            ),
                            _RequirementChip(
                              label: l10n.translate('password_rule_number'),
                              met: controller.hasNumber,
                            ),
                            _RequirementChip(
                              label: l10n.translate('password_rule_symbol'),
                              met: controller.hasSymbol,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: true,
              validator: controller.validateConfirmPassword,
              decoration: InputDecoration(
                labelText: l10n.translate('confirm_password'),
                prefixIcon: const Icon(IconlyLight.password),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  onSuccess();
                }
              },
              child: Text(l10n.translate('sign_up')),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForgotForm extends StatelessWidget {
  const _ForgotForm({required this.formKey, required this.controller});

  final GlobalKey<FormState> formKey;
  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.emailController,
              validator: controller.validateEmail,
              decoration: InputDecoration(labelText: l10n.translate('email'), prefixIcon: const Icon(IconlyLight.message)),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reset link sent!')),
                  );
                }
              },
              child: const Text('Send reset link'),
            ),
          ],
        ),
      ),
    );
  }
}

Color _strengthColor(BuildContext context, double value) {
  final theme = Theme.of(context);
  if (value < 0.3) {
    return theme.colorScheme.error;
  }
  if (value < 0.7) {
    return theme.colorScheme.tertiary;
  }
  return theme.colorScheme.primary;
}

String _strengthLabel(AppLocalizations l10n, double value) {
  if (value < 0.3) {
    return l10n.translate('password_strength_weak');
  }
  if (value < 0.7) {
    return l10n.translate('password_strength_fair');
  }
  return l10n.translate('password_strength_strong');
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = met ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant;
    final textColor = met ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(met ? 0.9 : 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(met ? Icons.check_circle : Icons.radio_button_unchecked, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
