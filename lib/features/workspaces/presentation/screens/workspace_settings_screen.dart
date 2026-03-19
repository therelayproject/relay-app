import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../domain/models/workspace.dart';
import '../providers/workspace_provider.dart';

/// Workspace configuration: name, domain, plan, and roles.
class WorkspaceSettingsScreen extends ConsumerStatefulWidget {
  const WorkspaceSettingsScreen({
    super.key,
    required this.workspaceId,
  });

  final String workspaceId;

  @override
  ConsumerState<WorkspaceSettingsScreen> createState() =>
      _WorkspaceSettingsScreenState();
}

class _WorkspaceSettingsScreenState
    extends ConsumerState<WorkspaceSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _domainCtrl = TextEditingController();
  bool _initialized = false;
  bool _saving = false;
  String? _error;

  void _initFromWorkspace(Workspace ws) {
    if (_initialized) return;
    _nameCtrl.text = ws.name;
    _domainCtrl.text = ws.domain ?? '';
    _initialized = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _domainCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final updated = await ref.read(
        updateWorkspaceProvider(
          workspaceId: widget.workspaceId,
          workspaceName: _nameCtrl.text.trim(),
          domain: _domainCtrl.text.trim().isEmpty
              ? null
              : _domainCtrl.text.trim(),
        ).future,
      );
      // Keep current workspace in sync.
      ref.read(currentWorkspaceProvider.notifier).select(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace updated')),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workspacesAsync = ref.watch(workspaceListProvider);
    final theme = Theme.of(context);

    final ws = workspacesAsync.valueOrNull
        ?.firstWhere((w) => w.id == widget.workspaceId,
            orElse: () => Workspace(
                  id: widget.workspaceId,
                  name: '',
                ));

    if (ws != null) _initFromWorkspace(ws);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace settings'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: workspacesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(RelayColors.spacingLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Workspace icon / initials
                  Center(
                    child: _WorkspaceIconPreview(workspace: ws),
                  ),
                  const SizedBox(height: RelayColors.spacingXl),

                  Text('Workspace name', style: theme.textTheme.labelMedium),
                  const SizedBox(height: RelayColors.spacingXs),
                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Acme Corp',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Workspace name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: RelayColors.spacingMd),

                  Text('Domain (optional)',
                      style: theme.textTheme.labelMedium),
                  const SizedBox(height: RelayColors.spacingXs),
                  TextFormField(
                    controller: _domainCtrl,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: 'acme',
                      suffixText: '.relay.chat',
                    ),
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: RelayColors.spacingMd),
                    Text(
                      _error!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.error),
                    ),
                  ],

                  const SizedBox(height: RelayColors.spacingXl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Save changes'),
                    ),
                  ),

                  const SizedBox(height: RelayColors.spacingXl),

                  // Plan badge
                  if (ws != null) ...[
                    Text('Plan', style: theme.textTheme.labelMedium),
                    const SizedBox(height: RelayColors.spacingXs),
                    Chip(
                      label: Text(ws.plan.name.toUpperCase()),
                      backgroundColor: theme.colorScheme.primaryContainer
                          .withOpacity(0.2),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkspaceIconPreview extends StatelessWidget {
  const _WorkspaceIconPreview({this.workspace});
  final Workspace? workspace;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initials = (workspace?.name.isNotEmpty ?? false)
        ? workspace!.name[0].toUpperCase()
        : '?';

    return Stack(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colorScheme.primaryContainer,
          foregroundImage: workspace?.iconUrl != null
              ? NetworkImage(workspace!.iconUrl!)
              : null,
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 28,
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
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
