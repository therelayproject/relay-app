import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/color_palette.dart';
import '../../domain/models/workspace.dart';
import '../providers/workspace_provider.dart';

/// Narrow vertical rail showing workspace icons — visible on desktop.
/// On mobile the same workspace list is shown inside the drawer.
class WorkspaceRail extends ConsumerWidget {
  const WorkspaceRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacesAsync = ref.watch(workspaceListProvider);
    final current = ref.watch(currentWorkspaceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.primaryContainer,
      child: Column(
        children: [
          const SizedBox(height: RelayColors.spacingSm),
          workspacesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(RelayColors.spacingSm),
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (workspaces) => Column(
              children: workspaces
                  .map((ws) => _WorkspaceIcon(
                        workspace: ws,
                        isSelected: current?.id == ws.id,
                        onTap: () {
                          ref.read(currentWorkspaceProvider.notifier).select(ws);
                          context.go('/app/${ws.id}');
                        },
                      ))
                  .toList(),
            ),
          ),
          const Spacer(),
          // Add workspace button
          _RailIconButton(
            icon: Icons.add,
            tooltip: 'Create workspace',
            onTap: () => context.push('/app/workspace/create'),
          ),
          const SizedBox(height: RelayColors.spacingSm),
        ],
      ),
    );
  }
}

class _WorkspaceIcon extends StatelessWidget {
  const _WorkspaceIcon({
    required this.workspace,
    required this.isSelected,
    required this.onTap,
  });

  final Workspace workspace;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initials = workspace.name.isNotEmpty
        ? workspace.name[0].toUpperCase()
        : '?';

    return Tooltip(
      message: workspace.name,
      preferBelow: false,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: RelayColors.spacingXs,
            horizontal: RelayColors.spacingXs,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.surface.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(
                isSelected ? RelayColors.radiusMd : RelayColors.radiusPill,
              ),
            ),
            child: workspace.iconUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                      isSelected ? RelayColors.radiusMd : RelayColors.radiusPill,
                    ),
                    child: Image.network(workspace.iconUrl!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _RailIconButton extends StatelessWidget {
  const _RailIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
        onPressed: onTap,
      ),
    );
  }
}
