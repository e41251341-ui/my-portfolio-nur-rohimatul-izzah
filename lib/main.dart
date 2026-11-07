import 'package:flutter/material.dart';

import 'Tugas/Portofolio/beranda_page.dart';
import 'Tugas/Portofolio/form_portfolio_page.dart';
import 'Tugas/Portofolio/models/portfolio_item.dart';
import 'Tugas/Portofolio/pengaturan_page.dart';
import 'Tugas/Portofolio/portfolio_page.dart';
import 'Tugas/Portofolio/profil_page.dart';
import 'Tugas/Portofolio/tentang_polije_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatefulWidget {
  const MyPortfolioApp({super.key});

  @override
  State<MyPortfolioApp> createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  bool isDarkMode = false;

  void changeTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6546E8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B6CFF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),

      home: MainNavigation(
        isDarkMode: isDarkMode,
        onThemeChanged: changeTheme,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainNavigation({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedPage = 0;
  int portfolioRefresh = 0;
  int formVersion = 0;

  PortfolioItem? itemToEdit;

  final List<String> pageTitles = const [
    'My Portfolio',
    'Profil Saya',
    'Portofolio / Karya',
    'Tambah Portofolio',
    'Tentang POLIJE',
    'Pengaturan',
  ];

  int get bottomIndex {
    if (selectedPage == 0) return 0;
    if (selectedPage == 1) return 1;
    if (selectedPage == 5) return 3;
    return 2;
  }

  void selectPage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  void openForm([PortfolioItem? item]) {
    setState(() {
      itemToEdit = item;
      formVersion++;
      selectedPage = 3;
    });
  }

  void savedPortfolio() {
    setState(() {
      selectedPage = 2;
      itemToEdit = null;
      portfolioRefresh++;
    });
  }

  void cancelForm() {
    setState(() {
      selectedPage = 2;
      itemToEdit = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formKey = itemToEdit == null
        ? 'form-new-$formVersion'
        : 'form-${itemToEdit!.id}-$formVersion';

    final List<Widget> pages = [
      BerandaPage(
        onPortfolioTap: () => selectPage(2),
      ),

      const ProfilPage(),

      PortfolioPage(
        key: ValueKey(portfolioRefresh),
        onAdd: () => openForm(),
        onEdit: (item) => openForm(item),
      ),

      PortfolioFormPage(
        key: ValueKey(formKey),
        item: itemToEdit,
        onSaved: savedPortfolio,
        onCancel: cancelForm,
      ),

      const TentangPolijePage(),

      PengaturanPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[selectedPage],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4A90E2),
                      Color(0xFF6546E8),
                      Color(0xFFD946EF),
                    ],
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 55,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'My Portfolio',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Nur Rohimatul Izzah',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              _drawerItem(
                icon: Icons.home_outlined,
                title: 'Beranda',
                page: 0,
              ),

              _drawerItem(
                icon: Icons.person_outline,
                title: 'Profil Saya',
                page: 1,
              ),

              _drawerItem(
                icon: Icons.work_outline,
                title: 'Portofolio / Karya',
                page: 2,
              ),

              _drawerItem(
                icon: Icons.add_box_outlined,
                title: 'Tambah Portofolio',
                page: 3,
              ),

              _drawerItem(
                icon: Icons.school_outlined,
                title: 'Tentang POLIJE',
                page: 4,
              ),

              _drawerItem(
                icon: Icons.settings_outlined,
                title: 'Pengaturan',
                page: 5,
              ),
            ],
          ),
        ),
      ),

      body: IndexedStack(
        index: selectedPage,
        children: pages,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: bottomIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            selectPage(0);
          } else if (index == 1) {
            selectPage(1);
          } else if (index == 2) {
            selectPage(2);
          } else if (index == 3) {
            selectPage(5);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Karya',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required int page,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selectedPage == page,
      onTap: () {
        Navigator.pop(context);
        selectPage(page);
      },
    );
  }
}