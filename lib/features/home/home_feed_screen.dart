import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../theme.dart';
import '../../components/post_card.dart';
import '../../components/image_post_card.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>()!;
    final divider = Divider(
      height: 1,
      thickness: 1,
      color: theme.brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade200,
    );

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            elevation: 0,
            backgroundColor: colors.surface,
            foregroundColor: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            surfaceTintColor: colors.surface,
            systemOverlayStyle: theme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            title: const FaIcon(FontAwesomeIcons.threads, size: 32),
          ),
          SliverToBoxAdapter(child: divider),
          SliverList.list(
            children: const [
              ImagePostCard(
                avatar: 'https://i.pravatar.cc/100?img=12',
                name: 'pubity',
                verified: true,
                timeAgo: '2m',
                text: 'Vine after seeing the Threads logo unveiled',
                images: [
                  'https://images.unsplash.com/photo-1523731407965-2430cd12f5e4?q=80&w=1974&auto=format&fit=crop',
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop',
                ],
                replies: 36,
                likes: 391,
                showMuteBadge: true,
                participants: [
                  'https://i.pravatar.cc/100?img=1',
                  'https://i.pravatar.cc/100?img=2',
                  'https://i.pravatar.cc/100?img=3',
                ],
              ),
              _FeedDivider(),
              ImagePostCard(
                avatar: 'https://i.pravatar.cc/100?img=5',
                name: 'thetinderblog',
                verified: true,
                timeAgo: '5m',
                text: 'Elon alone on Twitter right now…',
                images: [
                  'https://images.unsplash.com/photo-1520975916090-3105956dac38?q=80&w=2069&auto=format&fit=crop',
                ],
                replies: 0,
                likes: 0,
                participants: [],
              ),
              _FeedDivider(),
              PostCard(
                avatar: 'https://i.pravatar.cc/100?img=8',
                name: 'tropicalseductions',
                verified: true,
                timeAgo: '2h',
                text: 'Drop a comment here to test things out.',
                replies: 2,
                likes: 4,
                participants: [
                  'https://i.pravatar.cc/100?img=4',
                  'https://i.pravatar.cc/100?img=5',
                ],
              ),
              _FeedDivider(),
              PostCard(
                avatar: 'https://i.pravatar.cc/100?img=15',
                name: 'shityoushouldcareabout',
                verified: true,
                timeAgo: '2h',
                text:
                    'my phone feels like a vibrator with all these notifications rn',
                replies: 64,
                likes: 631,
                participants: [
                  'https://i.pravatar.cc/100?img=6',
                  'https://i.pravatar.cc/100?img=7',
                  'https://i.pravatar.cc/100?img=8',
                ],
              ),
              _FeedDivider(),
              PostCard(
                avatar: 'https://i.pravatar.cc/100?img=20',
                name: '_plantswithkrystal_',
                verified: true,
                timeAgo: '2h',
                text:
                    'If you\'re reading this, go water that thirsty plant. You\'re welcome 😊',
                replies: 8,
                likes: 74,
                participants: ['https://i.pravatar.cc/100?img=9'],
              ),
              _FeedDivider(),
              ImagePostCard(
                avatar: 'https://i.pravatar.cc/100?img=25',
                name: 'terracottacoco',
                verified: true,
                timeAgo: '2h',
                text: 'How do you do, fellow kids?',
                images: [
                  'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?q=80&w=2070&auto=format&fit=crop',
                ],
                replies: 12,
                likes: 89,
                participants: [
                  'https://i.pravatar.cc/100?img=10',
                  'https://i.pravatar.cc/100?img=11',
                ],
              ),
              _FeedDivider(),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeedDivider extends StatelessWidget {
  const _FeedDivider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: Colors.grey.shade200);
}
