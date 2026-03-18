import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/color_palette.dart';
import '../providers/auth_provider.dart';

/// Two-step password reset flow.
///
/// Step 1 (no token): enter email → request reset email.
/// Step 2 (token present in URL): enter new password → confirm reset.
class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key, this.token});

  /// When the user arrives via the reset link, the token is passed in.
  final String? token;

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _emailSent = false;

  bool get _isConfirmStep => widget.token != null;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(passwordResetRequestProvider.notifier)
        .sendResetEmail(_emailCtrl.text.trim());
    if (!mounted) return;
    final state = ref.read(passwordResetRequestProvider);
    if (!state.hasError) setState(() => _emailSent = true);
  }

  Future<void> _submitConfirm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(passwordResetConfirmProvider.notifier).confirm(
          token: widget.token!,
          newPassword: _passwordCtrl.text,
        );
    if (!mounted) return;
    final state = ref.read(passwordResetConfirmProvider);
    if (!state.hasError) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/login')),
        title: const Text('Reset password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: RelayColors.spacingLg,
            vertical: RelayColors.spacingXl,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _isConfirmStep ? _buildConfirmStep(theme) : _buildRequestStep(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestStep(ThemeData theme) {
    final state = ref.watch(passwordResetRequestProvider);
    final isLoading = state.isLoading;

    if (_emailSent) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.mark_email_read_outlined,
            size: 56,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: RelayColors.spacingMd),
          Text(
            'Check your inbox',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: RelayColors.spacingSm),
          Text(
            'We sent a reset link to ${_emailCtrl.text.trim()}',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: RelayColors.spacingXl),
          TextButton(
            onPressed: () => setState(() => _emailSent = false),
            child: const Text('Send again'),
          ),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Forgot your password?',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: RelayColors.spacingSm),
          Text(
            "Enter your email and we'll send you a reset link.",
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: RelayColors.spacingXl),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            onFieldSubmitted: (_) => _submitRequest(),
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          if (state.hasError) ...[
            const SizedBox(height: RelayColors.spacingSm),
            Text(
              state.error.toString(),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: RelayColors.spacingLg),
          ElevatedButton(
            onPressed: isLoading ? null : _submitRequest,
            child: isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Send reset link'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmStep(ThemeData theme) {
    final state = ref.watch(passwordResetConfirmProvider);
    final isLoading = state.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Choose a new password',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: RelayColors.spacingXl),
          TextFormField(
            controller: _passwordCtrl,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            onFieldSubmitted: (_) => _submitConfirm(),
            decoration: InputDecoration(
              labelText: 'New password',
              prefixIcon: const Icon(Icons.lock_outline),
              helperText: 'Minimum 8 characters',
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter a new password';
              if (v.length < 8) return 'Password must be at least 8 characters';
              return null;
            },
          ),
          if (state.hasError) ...[
            const SizedBox(height: RelayColors.spacingSm),
            Text(
              state.error.toString(),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: RelayColors.spacingLg),
          ElevatedButton(
            onPressed: isLoading ? null : _submitConfirm,
            child: isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Set new password'),
          ),
        ],
      ),
    );
  }
}
