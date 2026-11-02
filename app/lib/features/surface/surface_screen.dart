import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';

class SurfaceScreen extends ConsumerStatefulWidget {
  const SurfaceScreen({super.key, this.exposureId});

  final String? exposureId;

  @override
  ConsumerState<SurfaceScreen> createState() => _SurfaceScreenState();
}

class _SurfaceScreenState extends ConsumerState<SurfaceScreen> {
  SurfaceItem? _currentItem;
  bool _isLoading = true;
  bool _isResponding = false;

  @override
  void initState() {
    super.initState();
    _loadNext();
  }

  Future<void> _loadNext() async {
    setState(() => _isLoading = true);
    final surfaceService = ref.read(surfaceServiceProvider);
    final item = await surfaceService.next();
    if (mounted) {
      setState(() {
        _currentItem = item;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleReaction(Reaction reaction) async {
    if (_currentItem == null || _isResponding) return;

    final current = _currentItem!;
    setState(() => _isResponding = true);

    // Write response locally
    final responseService = ref.read(responseServiceProvider);
    await responseService.apply(
      ResponseCommand(
        exposureId: current.exposure.id,
        reaction: reaction,
        via: RespondedVia.inApp,
      ),
    );

    if (reaction == Reaction.explore) {
      if (mounted) {
        context.push('/explore/${current.interest.id}');
      }
    }

    // Crossfade to next
    await _loadNext();
    if (mounted) {
      setState(() => _isResponding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.auto_awesome, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'rekindle',
              style: TextStyle(
                fontFamily: 'Lora',
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined, size: 22),
            tooltip: 'Your Interests',
            onPressed: () => context.push('/interests'),
          ),
          IconButton(
            icon: const Icon(Icons.insights_outlined, size: 22),
            tooltip: 'Insights',
            onPressed: () => context.push('/insights'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: _buildBody(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      // Still placeholder (no shimmer)
      return const Center(
        key: ValueKey('loading'),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_currentItem == null) {
      return Center(
        key: const ValueKey('empty'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notes_outlined, size: 48, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              'Your library is quiet',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a thought to one of your interests and it will show up here.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add a thought'),
              onPressed: () => context.push('/interests'),
            )
          ],
        ),
      );
    }

    final item = _currentItem!;

    return Column(
      key: ValueKey(item.exposure.id),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.exposureId != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'From your nudge',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        // Interest pill chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item.interest.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const Spacer(),
        // Snippet content in Lora
        Center(
          child: Text(
            item.snippet.content,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: 'Lora',
              fontSize: 21,
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Quiet metadata line
        Center(
          child: Text(
            'Saved thought',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const Spacer(),
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () => _handleReaction(Reaction.skip),
              child: const Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () => _handleReaction(Reaction.keep),
              child: const Text('Keep'),
            ),
            TextButton(
              onPressed: () => _handleReaction(Reaction.explore),
              child: const Text('Explore more →'),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
