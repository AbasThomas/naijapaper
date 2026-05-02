import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedPlan = 'monthly';

  @override
  Widget build(BuildContext context) {
    final plans = const [
      _Plan(id: 'monthly', title: 'Monthly', price: '₦2,000 / mo', badge: null),
      _Plan(id: '3mo', title: '3-Month', price: '₦5,000', badge: 'Save 17%'),
      _Plan(id: 'annual', title: 'Annual', price: '₦15,000 / yr', badge: 'Best Value'),
      _Plan(id: 'family', title: 'Family', price: '₦25,000 / yr', badge: null),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Upgrade to Premium')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Free vs Premium',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Premium unlocks:', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 8),
                  _Bullet('All subjects + offline bundles'),
                  _Bullet('Unlimited AI explanations (English + Pidgin)'),
                  _Bullet('Full mocks + advanced analytics'),
                  _Bullet('Streak freeze + premium badges'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Choose a plan',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...plans.map(
            (p) => _PlanCard(
              plan: p,
              selected: _selectedPlan == p.id,
              onTap: () => setState(() => _selectedPlan = p.id),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.card_giftcard_outlined),
              title: const Text('Referral credit'),
              subtitle: const Text('You have 0 credits (mock)'),
              trailing: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Apply referral code - wire later.')),
                  );
                },
                child: const Text('Apply'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Initiate Paystack for plan: $_selectedPlan (mock).')),
              );
            },
            child: const Text('Subscribe Now (Paystack)'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restore / manage subscription wiring happens later.')),
              );
            },
            child: const Text('Restore purchase / Manage subscription'),
          ),
          const SizedBox(height: 8),
          Text(
            'Trusted by 100,000+ Nigerian students (placeholder)',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _Plan {
  final String id;
  final String title;
  final String price;
  final String? badge;
  const _Plan({required this.id, required this.title, required this.price, required this.badge});
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({required this.plan, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: selected ? AppColors.primary : Colors.transparent, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(plan.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        if (plan.badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: plan.badge == 'Best Value' ? Colors.amber.shade100 : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              plan.badge!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: plan.badge == 'Best Value' ? Colors.brown.shade700 : Colors.green.shade800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(plan.price, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              if (selected) const Icon(Icons.check_circle, color: AppColors.primary) else const Icon(Icons.circle_outlined),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(Icons.check_circle, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
