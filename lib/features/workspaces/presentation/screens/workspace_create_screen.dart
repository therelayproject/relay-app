import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/color_palette.dart';
import '../providers/workspace_provider.dart';

class WorkspaceCreateScreen extends ConsumerStatefulWidget {
  const WorkspaceCreateScreen({super.key});

  @override
  ConsumerState<WorkspaceCreateScreen> createState() =>
      _WorkspaceCreateScreenState();
}

class _WorkspaceCreateScreenState
    extends ConsumerState<WorkspaceCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final ws = await ref.read(
        createWorkspaceProvider(name: _nameCtrl.text.trim()).future,
      );
      ref.read(currentWorkspaceProvider.notifier).select(ws);
      if (mounted) context.go('/app/${ws.id}');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create workspace')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RelayColors.spacingLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Name your workspace',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: RelayColors.spacingMd),
                  TextFormField(
                    controller: _nameCtrl,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                      labelText: 'Workspace name',
                      hintText: 'e.g. Acme Corp',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter a workspace name';
                      }
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: RelayColors.spacingSm),
                    Text(
                      _error!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: RelayColors.spacingLg),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create workspace'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
