import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rekindle_core/rekindle_core.dart';
import '../../app/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Draft state
  final Set<String> _selectedInterests = {};
  final Map<String, String> _memories = {};
  NotificationLevel _level = NotificationLevel.gentle;
  final Set<DeliveryWindow> _windows = {DeliveryWindow.morning, DeliveryWindow.evening};
  NotificationVoice _voice = NotificationVoice.calm;
  bool _showTextOnLockScreen = false;
  bool _requestFirstNudgeQuickly = true;
  bool _isCompleting = false;

  // Catalog loaded from asset
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    try {
      final jsonString = await rootBundle.loadString('assets/catalog/interests.json');
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final catList = (data['categories'] as List).cast<Map<String, dynamic>>();
      setState(() {
        _categories = catList;
      });
    } catch (e) {
      // Fallback defaults if asset read delayed
      setState(() {
        _categories = [
          {
            'name': 'Tech',
            'interests': [
              {'name': 'Databases'},
              {'name': 'Distributed systems'},
              {'name': 'Linux'},
              {'name': 'AI'},
            ]
          },
          {
            'name': 'Mind',
            'interests': [
              {'name': 'Philosophy'},
              {'name': 'Psychology'},
              {'name': 'Habits'},
              {'name': 'Memory'},
            ]
          }
        ];
      });
    }
  }

  void _nextStep() {
    if (_currentStep == 5 && _level == NotificationLevel.off) {
      // Choosing None skips Step 7 (Permission)
      _pageController.animateToPage(
        7,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (_currentStep < 7) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _finishOnboarding() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);

    final draft = OnboardingDraft(
      selectedInterests: _selectedInterests.toList(),
      memories: _memories,
      level: _level,
      windows: _windows,
      voice: _voice,
      showTextOnLockScreen: _showTextOnLockScreen,
      requestFirstNudgeQuickly: _requestFirstNudgeQuickly,
    );

    final onboardingService = ref.read(onboardingServiceProvider);
    await onboardingService.complete(draft);

    if (_level != NotificationLevel.off) {
      final planner = ref.read(nudgePlannerProvider);
      await planner.replan(DateTime.now());
    }

    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top navigation and dot indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 20),
                      onPressed: _prevStep,
                    )
                  else
                    const SizedBox(width: 48),
                  const Spacer(),
                  // Step dots (8 steps)
                  Row(
                    children: List.generate(8, (index) {
                      final active = index == _currentStep;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: active ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (step) => setState(() => _currentStep = step),
                children: [
                  _buildStep1Welcome(theme),
                  _buildStep2HowItWorks(theme),
                  _buildStep3PickInterests(theme),
                  _buildStep4FirstMemories(theme),
                  _buildStep5TryNudge(theme),
                  _buildStep6Preferences(theme),
                  _buildStep7Permission(theme),
                  _buildStep8AllSet(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Step 1: Welcome ---
  Widget _buildStep1Welcome(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 48, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            'rekindle',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontFamily: 'Lora',
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Things you once loved, back when you have a moment.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: theme.colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How is this different from flashcards?',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No streaks, no due counts, nothing to catch up on.\n\n'
                        'Rekindle never tests you or asks you to memorize facts. '
                        'It simply brings back thoughts you once found fascinating in calm, unhurried moments.',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Understood'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Text(
              'How is this different from flashcards?',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: const Text('Begin'),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 2: How It Works ---
  Widget _buildStep2HowItWorks(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How Rekindle works',
            style: theme.textTheme.headlineSmall?.copyWith(fontFamily: 'Lora'),
          ),
          const SizedBox(height: 20),
          _buildBeatCard(theme, '1', 'Tell us what you\'re into', 'Pick a few subjects or topics you genuinely care about.'),
          const SizedBox(height: 12),
          _buildBeatCard(theme, '2', 'Jot a thought or two', 'Save a quote, an insight, or a curiosity. Even a single sentence is enough.'),
          const SizedBox(height: 12),
          _buildBeatCard(theme, '3', 'We bring it back, gently', 'Occasionally, Rekindle surfaces a thought for you to rediscover or ponder.'),
          const SizedBox(height: 24),
          Text(
            'Interactive mini-preview (records nothing):',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Sample Interest', style: TextStyle(fontSize: 12, color: theme.colorScheme.onPrimaryContainer)),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '"The cure for boredom is curiosity. There is no cure for curiosity."',
                    style: TextStyle(fontFamily: 'Lora', fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      OutlinedButton(onPressed: () {}, child: const Text('Skip')),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: const Text('Keep')),
                      const Spacer(),
                      TextButton(onPressed: () {}, child: const Text('Explore →')),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeatCard(ThemeData theme, String num, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(num, style: TextStyle(fontSize: 12, color: theme.colorScheme.onPrimaryContainer)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 3: Pick Interests ---
  Widget _buildStep3PickInterests(ThemeData theme) {
    final customController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pick your interests', style: theme.textTheme.headlineSmall?.copyWith(fontFamily: 'Lora')),
          const SizedBox(height: 4),
          Text(
            'Choose 1 to 12 topics you want to rediscover. (3 to 5 recommended)',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          // Custom interest entry
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: customController,
                  maxLength: 60,
                  decoration: const InputDecoration(
                    hintText: 'Add custom topic...',
                    isDense: true,
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  final text = customController.text.trim();
                  if (text.isNotEmpty && _selectedInterests.length < 12) {
                    setState(() {
                      _selectedInterests.add(text);
                      customController.clear();
                    });
                  }
                },
              )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (ctx, idx) {
                final cat = _categories[idx];
                final catName = cat['name'] as String;
                final items = (cat['interests'] as List).cast<Map<String, dynamic>>();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                      child: Text(catName, style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: items.map((item) {
                        final name = item['name'] as String;
                        final isSelected = _selectedInterests.contains(name);
                        return FilterChip(
                          label: Text(name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                if (_selectedInterests.length < 12) {
                                  _selectedInterests.add(name);
                                }
                              } else {
                                _selectedInterests.remove(name);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Text('You can change this any time.', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _selectedInterests.isNotEmpty ? _nextStep : null,
                    child: Text('Continue (${_selectedInterests.length})'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- Step 4: First Memories ---
  Widget _buildStep4FirstMemories(ThemeData theme) {
    final list = _selectedInterests.take(3).toList();
    if (list.isEmpty) {
      return Center(
        child: ElevatedButton(onPressed: _nextStep, child: const Text('Continue')),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('First memories', style: theme.textTheme.headlineSmall?.copyWith(fontFamily: 'Lora')),
          const SizedBox(height: 4),
          Text(
            'Jot a thought for up to 3 interests to make them immediately eligible to surface. (Optional)',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (ctx, idx) {
                final interestName = list[idx];
                final promptChips = [
                  'Something that surprised you',
                  'A question you never answered',
                  'Why you got into it',
                ];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(interestName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        children: promptChips.map((prompt) {
                          return ActionChip(
                            label: Text(prompt, style: const TextStyle(fontSize: 11)),
                            onPressed: () {
                              setState(() {
                                _memories[interestName] = prompt;
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLength: 1000,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Type your thought...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                        onChanged: (val) {
                          _memories[interestName] = val;
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _nextStep,
                  child: const Text('Skip for now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Continue'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // --- Step 5: Try a Nudge ---
  Widget _buildStep5TryNudge(ThemeData theme) {
    final sampleSnippet = _memories.values.firstOrNull ?? 'Curiosity is the engine of intellectual rediscovery.';
    final sampleInterest = _selectedInterests.firstOrNull ?? 'Philosophy';

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Try a nudge', style: theme.textTheme.headlineSmall?.copyWith(fontFamily: 'Lora')),
          const SizedBox(height: 8),
          Text(
            'This is what an answerable notification looks like when it appears on your phone shade. Tapping an action records your reaction directly without opening the app.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications_none, size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text('Rekindle · Just now', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('A thought from $sampleInterest', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('"$sampleSnippet"', style: const TextStyle(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      TextButton(onPressed: () {}, child: const Text('Keep')),
                      TextButton(onPressed: () {}, child: const Text('Skip')),
                      TextButton(onPressed: () {}, child: const Text('Tell me more')),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Lock-screen privacy: by default, your note content stays hidden until unlocked.',
            style: theme.textTheme.bodySmall,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: const Text('Looks good'),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 6: Preferences ---
  Widget _buildStep6Preferences(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nudge preferences', style: theme.textTheme.headlineSmall?.copyWith(fontFamily: 'Lora')),
          const SizedBox(height: 16),
          const Text('How often should Rekindle nudge you?', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          SegmentedButton<NotificationLevel>(
            segments: const [
              ButtonSegment(value: NotificationLevel.rare, label: Text('Rarely\n(~2/wk)')),
              ButtonSegment(value: NotificationLevel.gentle, label: Text('Gentle\n(~1/day)')),
              ButtonSegment(value: NotificationLevel.more, label: Text('More\n(≤3/day)')),
              ButtonSegment(value: NotificationLevel.off, label: Text('None')),
            ],
            selected: {_level},
            onSelectionChanged: (set) => setState(() => _level = set.first),
          ),
          const SizedBox(height: 20),
          const Text('Delivery windows', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('Mornings (08:00–12:00)'),
                selected: _windows.contains(DeliveryWindow.morning),
                onSelected: (val) {
                  setState(() {
                    val ? _windows.add(DeliveryWindow.morning) : _windows.remove(DeliveryWindow.morning);
                  });
                },
              ),
              FilterChip(
                label: const Text('Afternoons (12:00–17:00)'),
                selected: _windows.contains(DeliveryWindow.afternoon),
                onSelected: (val) {
                  setState(() {
                    val ? _windows.add(DeliveryWindow.afternoon) : _windows.remove(DeliveryWindow.afternoon);
                  });
                },
              ),
              FilterChip(
                label: const Text('Evenings (17:00–21:00)'),
                selected: _windows.contains(DeliveryWindow.evening),
                onSelected: (val) {
                  setState(() {
                    val ? _windows.add(DeliveryWindow.evening) : _windows.remove(DeliveryWindow.evening);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Voice and tone', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: [
              ChoiceChip(
                label: const Text('Calm'),
                selected: _voice == NotificationVoice.calm,
                onSelected: (val) => setState(() => _voice = NotificationVoice.calm),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Playful (✦)'),
                selected: _voice == NotificationVoice.playful,
                onSelected: (val) => setState(() => _voice = NotificationVoice.playful),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Show note text on lock screen'),
            subtitle: const Text('Keep off for complete privacy until phone is unlocked'),
            value: _showTextOnLockScreen,
            onChanged: (val) => setState(() => _showTextOnLockScreen = val),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: const Text('Save preferences'),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 7: Permission Priming ---
  Widget _buildStep7Permission(ThemeData theme) {
    final dailyCount = switch (_level) {
      NotificationLevel.rare => 'a couple of times a week',
      NotificationLevel.gentle => 'at most once a day',
      NotificationLevel.more => 'up to 3 times a day',
      NotificationLevel.off => 'none',
    };

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text('Our promise', style: theme.textTheme.headlineSmall?.copyWith(fontFamily: 'Lora')),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Rekindle will speak to you $dailyCount, only in the windows you selected, and you can pause or stop nudges with a single tap at any time.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onPrimaryContainer, height: 1.4),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _nextStep,
              child: const Text('Allow gentle nudges'),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _nextStep,
            child: const Text('Continue in-app only'),
          )
        ],
      ),
    );
  }

  // --- Step 8: All Set ---
  Widget _buildStep8AllSet(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('All set', style: theme.textTheme.headlineMedium?.copyWith(fontFamily: 'Lora')),
          const SizedBox(height: 16),
          Text(
            'Your library is seeded with ${_selectedInterests.length} interests.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text('Send me a first nudge in a few minutes'),
            value: _requestFirstNudgeQuickly,
            onChanged: (val) => setState(() => _requestFirstNudgeQuickly = val ?? true),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your notes live only on this phone. Uninstalling removes them unless you export a copy.',
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  'Insights are computed locally on this phone and can be turned off in Settings.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _isCompleting ? null : _finishOnboarding,
              child: _isCompleting
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Finish and open Rekindle'),
            ),
          ),
        ],
      ),
    );
  }
}
