import 'package:flutter/material.dart';

import '../../features/channels/presentation/widgets/channel_sidebar.dart';
import '../../features/workspaces/presentation/widgets/workspace_rail.dart';

/// Responsive shell implementing the 1/2/3-column layout described in REL-5.
///
/// | Breakpoint | Width       | Columns                                         |
/// |------------|-------------|--------------------------------------------------|
/// | Mobile     | < 600px     | Single panel + drawer nav                        |
/// | Tablet     | 600–1200px  | Two panels (sidebar + content)                   |
/// | Desktop    | > 1200px    | Three panels + optional thread panel             |
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({super.key, required this.child});

  /// The current main content (injected by GoRouter ShellRoute).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < 600) return _MobileLayout(child: child);
    if (width < 1200) return _TabletLayout(child: child);
    return _DesktopLayout(child: child);
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const _WorkspaceSidebarDrawer(),
        body: child,
      );
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const SizedBox(width: 260, child: ChannelSidebar()),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      );
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const SizedBox(width: 68, child: WorkspaceRail()),
          const SizedBox(width: 240, child: ChannelSidebar()),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      );
}

class _WorkspaceSidebarDrawer extends StatelessWidget {
  const _WorkspaceSidebarDrawer();

  @override
  Widget build(BuildContext context) => const Drawer(
        child: Row(
          children: [
            SizedBox(width: 68, child: WorkspaceRail()),
            Expanded(child: ChannelSidebar()),
          ],
        ),
      );
}
