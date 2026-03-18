import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/color_palette.dart';
import '../providers/auth_provider.dart';

/// Handles the OAuth redirect from Google / GitHub.
///
/// Expected query params:
///   ?provider=google&code=AUTH_CODE
///   ?provider=github&code=AUTH_CODE
///   ?error=access_denied  (user cancelled)
class OAuthCallbackScreen extends ConsumerStatefulWidget {
  const OAuthCallbackScreen({super.key, required this.queryParams});

  final Map<String, String> queryParams;

  @override
  ConsumerState<OAuthCallbackScreen> createState() =>
      _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends ConsumerState<OAuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _process());
  }

  Future<void> _process() async {
    final error = widget.queryParams['error'];
    if (error != null) {
      // User cancelled or provider returned error — go back to login.
      if (mounted) context.go('/login');
      return;
    }

    final provider = widget.queryParams['provider'];
    final code = widget.queryParams['code'];

    if (provider == null || code == null) {
      if (mounted) context.go('/login');
      return;
    }

    await ref
        .read(authStateProvider.notifier)
        .signInWithOAuth(provider: provider, code: code);

    if (!mounted) return;
    final session = ref.read(authStateProvider).valueOrNull;
    if (session?.isAuthenticated ?? false) {
      context.go('/app/workspace');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final hasError = authState.hasError;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(RelayColors.spacingXl),
          child: hasError
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: RelayColors.spacingMd),
                    Text(
                      'Sign in failed',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: RelayColors.spacingSm),
                    Text(
                      authState.error?.toString() ?? 'Unknown error',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: RelayColors.spacingLg),
                    FilledButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Back to sign in'),
                    ),
                  ],
                )
              : const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: RelayColors.spacingMd),
                    Text('Completing sign in…'),
                  ],
                ),
        ),
      ),
    );
  }
}
