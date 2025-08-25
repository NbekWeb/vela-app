import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/stores/auth_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vela'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              _showProfileMenu(context);
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildProjects();
      case 2:
        return _buildAnalytics();
      case 3:
        return _buildProfile();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xush kelibsiz!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bugun nima qilmoqchisiz?',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Tezkor amallar',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildQuickActionCard(
                icon: Icons.add_task,
                title: 'Yangi loyiha',
                subtitle: 'Loyiha yarating',
                color: Colors.blue,
                onTap: () {},
              ),
              _buildQuickActionCard(
                icon: Icons.analytics,
                title: 'Hisobotlar',
                subtitle: 'Ma\'lumotlarni ko\'ring',
                color: Colors.green,
                onTap: () {},
              ),
              _buildQuickActionCard(
                icon: Icons.people,
                title: 'Jamoa',
                subtitle: 'A\'zolarni boshqaring',
                color: Colors.orange,
                onTap: () {},
              ),
              _buildQuickActionCard(
                icon: Icons.settings,
                title: 'Sozlamalar',
                subtitle: 'Ilovani sozlang',
                color: Colors.purple,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity
          const Text(
            'So\'nggi faollik',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildActivityItem(
            icon: Icons.check_circle,
            title: 'Loyiha tugatildi',
            subtitle: 'Web sayt loyihasi muvaffaqiyatli yakunlandi',
            time: '2 soat oldin',
            color: Colors.green,
          ),
          _buildActivityItem(
            icon: Icons.person_add,
            title: 'Yangi a\'zo',
            subtitle: 'Ahmad qo\'shildi',
            time: '4 soat oldin',
            color: Colors.blue,
          ),
          _buildActivityItem(
            icon: Icons.warning,
            title: 'Ogohlantirish',
            subtitle: 'Loyiha muddati yaqinlashmoqda',
            time: '1 kun oldin',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Text(
          time,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildProjects() {
    return const Center(
      child: Text('Loyihalar sahifasi', style: TextStyle(fontSize: 20)),
    );
  }

  Widget _buildAnalytics() {
    return const Center(
      child: Text('Analitika sahifasi', style: TextStyle(fontSize: 20)),
    );
  }

  Widget _buildProfile() {
    return const Center(
      child: Text('Profil sahifasi', style: TextStyle(fontSize: 20)),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to profile page
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Sozlamalar'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings page
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Chiqish', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await _handleLogout();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final authStore = context.read<AuthStore>();
    await authStore.logout();

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Bosh sahifa',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Loyihalar'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analitika',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
