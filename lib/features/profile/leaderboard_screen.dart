import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/shimmer_loader.dart';

// Leaderboard user model
class LeaderboardUser {
  final String id;
  final String name;
  final String? avatar;
  final int xp;
  final int rank;
  final int level;
  final bool isCurrentUser;

  LeaderboardUser({
    required this.id,
    required this.name,
    this.avatar,
    required this.xp,
    required this.rank,
    required this.level,
    this.isCurrentUser = false,
  });
}

// Leaderboard provider
final leaderboardProvider = FutureProvider.family<List<LeaderboardUser>, String>(
  (ref, scope) async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    return _getMockLeaderboard(scope);
  },
);

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedScope = 'global';
  String _selectedTimeframe = 'week';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedScope = ['global', 'friends', 'school'][_tabController.index];
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardAsync = ref.watch(leaderboardProvider(_selectedScope));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          // Timeframe filter
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            initialValue: _selectedTimeframe,
            onSelected: (value) {
              setState(() => _selectedTimeframe = value);
              ref.invalidate(leaderboardProvider);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'week', child: Text('This Week')),
              const PopupMenuItem(value: 'month', child: Text('This Month')),
              const PopupMenuItem(value: 'all', child: Text('All Time')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'Friends'),
            Tab(text: 'School'),
          ],
        ),
      ),
      body: leaderboardAsync.when(
        data: (users) => _buildLeaderboard(users),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildLeaderboard(List<LeaderboardUser> users) {
    if (users.isEmpty) {
      return _buildEmptyState();
    }

    // Get top 3 for podium
    final topThree = users.take(3).toList();
    final remaining = users.skip(3).toList();

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(leaderboardProvider);
      },
      child: CustomScrollView(
        slivers: [
          // Podium
          SliverToBoxAdapter(
            child: _buildPodium(topThree)
                .animate()
                .fadeIn()
                .slideY(begin: -0.2, end: 0),
          ),

          // Current user card (if not in top 3)
          if (users.any((u) => u.isCurrentUser && u.rank > 3))
            SliverToBoxAdapter(
              child: _buildCurrentUserCard(
                users.firstWhere((u) => u.isCurrentUser),
              ).animate().fadeIn(delay: 300.ms),
            ),

          // Remaining users list
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildLeaderboardItem(remaining[index])
                      .animate()
                      .fadeIn(delay: (400 + index * 50).ms)
                      .slideX(begin: 0.2, end: 0);
                },
                childCount: remaining.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(List<LeaderboardUser> topThree) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          // Trophy icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 48,
              color: AppColors.warning,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.5))
              .then()
              .shake(hz: 2, curve: Curves.easeInOut),

          const SizedBox(height: 24),

          // Podium
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd place
              if (topThree.length > 1)
                _buildPodiumPlace(topThree[1], 2, 140)
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .scale(delay: 200.ms),

              const SizedBox(width: 12),

              // 1st place
              if (topThree.isNotEmpty)
                _buildPodiumPlace(topThree[0], 1, 180)
                    .animate()
                    .fadeIn(delay: 100.ms)
                    .scale(delay: 100.ms, curve: Curves.elasticOut),

              const SizedBox(width: 12),

              // 3rd place
              if (topThree.length > 2)
                _buildPodiumPlace(topThree[2], 3, 120)
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .scale(delay: 300.ms),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(LeaderboardUser user, int place, double height) {
    Color color;
    IconData medal;

    switch (place) {
      case 1:
        color = AppColors.rankGold;
        medal = Icons.looks_one;
        break;
      case 2:
        color = AppColors.rankSilver;
        medal = Icons.looks_two;
        break;
      case 3:
        color = AppColors.rankBronze;
        medal = Icons.looks_3;
        break;
      default:
        color = AppColors.textSecondary;
        medal = Icons.circle;
    }

    return Column(
      children: [
        // Avatar with medal
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: place == 1 ? 80 : 64,
              height: place == 1 ? 80 : 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
                color: AppColors.surface,
              ),
              child: user.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        user.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(user.name),
                      ),
                    )
                  : _buildAvatarPlaceholder(user.name),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  medal,
                  size: place == 1 ? 24 : 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Name
        SizedBox(
          width: 80,
          child: Text(
            user.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: place == 1 ? 14 : 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // XP
        Text(
          '${user.xp} XP',
          style: TextStyle(
            fontSize: place == 1 ? 12 : 10,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 8),

        // Podium base
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '#$place',
              style: TextStyle(
                fontSize: place == 1 ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentUserCard(LeaderboardUser user) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textOnPrimary, width: 2),
            ),
            child: user.avatar != null
                ? ClipOval(
                    child: Image.network(
                      user.avatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(user.name),
                    ),
                  )
                : _buildAvatarPlaceholder(user.name),
          ),

          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Your Rank',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Level ${user.level}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Rank and XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#${user.rank}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
              ),
              Text(
                '${user.xp} XP',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textOnPrimary.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(LeaderboardUser user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: user.isCurrentUser
          ? AppColors.primary.withOpacity(0.1)
          : AppColors.surface,
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rank
            SizedBox(
              width: 32,
              child: Text(
                '#${user.rank}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: user.isCurrentUser
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ),

            // Avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: user.isCurrentUser
                      ? AppColors.primary
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: user.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        user.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(user.name),
                      ),
                    )
                  : _buildAvatarPlaceholder(user.name),
            ),
          ],
        ),

        // Name and level
        title: Text(
          user.name,
          style: TextStyle(
            fontWeight: user.isCurrentUser ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text('Level ${user.level}'),

        // XP
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${user.xp}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: user.isCurrentUser
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              'XP',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(String name) {
    return Container(
      color: AppColors.primary.withOpacity(0.2),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'No rankings yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedScope == 'friends'
                  ? 'Add friends to see their rankings'
                  : 'Complete exams to appear on the leaderboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ShimmerLoader(width: double.infinity, height: 300, borderRadius: BorderRadius.circular(16)),
          const SizedBox(height: 16),
          ...List.generate(
            5,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ShimmerLoader(
                width: double.infinity,
                height: 72,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Failed to load leaderboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(leaderboardProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock data
List<LeaderboardUser> _getMockLeaderboard(String scope) {
  return [
    LeaderboardUser(
      id: '1',
      name: 'Chidi Okafor',
      xp: 5420,
      rank: 1,
      level: 12,
    ),
    LeaderboardUser(
      id: '2',
      name: 'Amina Bello',
      xp: 5180,
      rank: 2,
      level: 11,
    ),
    LeaderboardUser(
      id: '3',
      name: 'Tunde Adeyemi',
      xp: 4950,
      rank: 3,
      level: 11,
    ),
    LeaderboardUser(
      id: '4',
      name: 'Ngozi Eze',
      xp: 4720,
      rank: 4,
      level: 10,
    ),
    LeaderboardUser(
      id: '5',
      name: 'Ibrahim Musa',
      xp: 4500,
      rank: 5,
      level: 10,
    ),
    LeaderboardUser(
      id: 'current',
      name: 'You',
      xp: 3250,
      rank: 12,
      level: 8,
      isCurrentUser: true,
    ),
    LeaderboardUser(
      id: '6',
      name: 'Blessing Okon',
      xp: 4280,
      rank: 6,
      level: 9,
    ),
    LeaderboardUser(
      id: '7',
      name: 'Yusuf Ahmed',
      xp: 4050,
      rank: 7,
      level: 9,
    ),
    LeaderboardUser(
      id: '8',
      name: 'Chioma Nwankwo',
      xp: 3820,
      rank: 8,
      level: 8,
    ),
    LeaderboardUser(
      id: '9',
      name: 'Emeka Obi',
      xp: 3600,
      rank: 9,
      level: 8,
    ),
    LeaderboardUser(
      id: '10',
      name: 'Fatima Hassan',
      xp: 3400,
      rank: 10,
      level: 7,
    ),
  ];
}
