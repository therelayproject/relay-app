import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../domain/models/user.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _statusTextCtrl = TextEditingController();
  final _statusEmojiCtrl = TextEditingController();
  final _timezoneCtrl = TextEditingController();

  bool _initialized = false;

  void _initFromUser(User user) {
    if (_initialized) return;
    _nameCtrl.text = user.displayName;
    _statusTextCtrl.text = user.statusText ?? '';
    _statusEmojiCtrl.text = user.statusEmoji ?? '';
    _initialized = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _statusTextCtrl.dispose();
    _statusEmojiCtrl.dispose();
    _timezoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(profileUpdateProvider.notifier).save(
          displayName: _nameCtrl.text.trim(),
          statusText: _statusTextCtrl.text.trim().isEmpty
              ? null
              : _statusTextCtrl.text.trim(),
          statusEmoji: _statusEmojiCtrl.text.trim().isEmpty
              ? null
              : _statusEmojiCtrl.text.trim(),
          timezone:
              _timezoneCtrl.text.trim().isEmpty ? null : _timezoneCtrl.text.trim(),
        );

    if (!mounted) return;
    final updateState = ref.read(profileUpdateProvider);
    if (!updateState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);
    final updateState = ref.watch(profileUpdateProvider);
    final isLoading = updateState.isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: authAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (session) {
          final user = session.user;
          if (user == null) {
            return const Center(child: Text('Not signed in'));
          }
          _initFromUser(user);
          return _buildForm(theme, user, isLoading, updateState);
        },
      ),
    );
  }

  Widget _buildForm(
    ThemeData theme,
    User user,
    bool isLoading,
    AsyncValue<void> updateState,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(RelayColors.spacingLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Center(child: _AvatarSection(user: user)),
              const SizedBox(height: RelayColors.spacingXl),

              // Display name
              Text('Display name', style: theme.textTheme.labelMedium),
              const SizedBox(height: RelayColors.spacingXs),
              TextFormField(
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Your name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name is required';
                  return null;
                },
              ),
              const SizedBox(height: RelayColors.spacingMd),

              // Status
              Text('Status', style: theme.textTheme.labelMedium),
              const SizedBox(height: RelayColors.spacingXs),
              Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: TextFormField(
                      controller: _statusEmojiCtrl,
                      textAlign: TextAlign.center,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        hintText: '😊',
                        counterText: '',
                      ),
                    ),
                  ),
                  const SizedBox(width: RelayColors.spacingSm),
                  Expanded(
                    child: TextFormField(
                      controller: _statusTextCtrl,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "What's your status?",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: RelayColors.spacingMd),

              // Timezone
              Text('Timezone', style: theme.textTheme.labelMedium),
              const SizedBox(height: RelayColors.spacingXs),
              TextFormField(
                controller: _timezoneCtrl,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: 'e.g. America/New_York',
                  prefixIcon: Icon(Icons.schedule_outlined),
                ),
              ),
              const SizedBox(height: RelayColors.spacingMd),

              // Read-only email
              Text('Email', style: theme.textTheme.labelMedium),
              const SizedBox(height: RelayColors.spacingXs),
              TextFormField(
                initialValue: user.email,
                readOnly: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  suffixIcon: Tooltip(
                    message: 'Email cannot be changed here',
                    child: Icon(Icons.lock_outline, size: 18),
                  ),
                ),
              ),

              if (updateState.hasError) ...[
                const SizedBox(height: RelayColors.spacingMd),
                Text(
                  updateState.error.toString(),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error),
                ),
              ],

              const SizedBox(height: RelayColors.spacingXl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initials = user.displayName.isNotEmpty
        ? user.displayName[0].toUpperCase()
        : '?';

    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colorScheme.primaryContainer,
          foregroundImage:
              user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 28,
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
