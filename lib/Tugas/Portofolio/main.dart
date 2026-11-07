import 'package:flutter/material.dart';

import 'beranda_page.dart';
import 'form_portfolio_page.dart';
import 'models/portfolio_item.dart';
import 'pengaturan_page.dart';
import 'portfolio_page.dart';
import 'profil_page.dart';
import 'tentang_polije_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6546E8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF25233A),
          centerTitle: false,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6546E8),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainNavigation(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) => setState(() => isDarkMode = value),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

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
    final formKey = itemToEdit == null
        ? 'form-new-$formVersion'
        : 'form-${itemToEdit!.id}-$formVersion';

    final pages = <Widget>[
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF6546E8), Color(0xFFD946EF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/foto_profil.jpg'),
                    ),
                    SizedBox(height: 12),
                    Text('My Portfolio', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('Nur Rohimatul Izzah', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _drawerItem(context, 0, Icons.home_outlined, 'Beranda'),
                    _drawerItem(context, 1, Icons.person_outline, 'Profil Saya'),
                    _drawerItem(context, 2, Icons.work_outline, 'Portofolio / Karya'),
                    _drawerItem(context, 3, Icons.add_box_outlined, 'Tambah Portofolio'),
                    _drawerItem(context, 4, Icons.account_balance_outlined, 'Tentang POLIJE'),
                    _drawerItem(context, 5, Icons.settings_outlined, 'Pengaturan'),
                  ],
                ),
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
          if (index == 0) selectPage(0);
          if (index == 1) selectPage(1);
          if (index == 2) selectPage(2);
          if (index == 3) selectPage(5);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: 'Karya'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
      floatingActionButton: selectedPage == 2
          ? FloatingActionButton.extended(
              onPressed: () => openForm(),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Karya'),
            )
          : null,
    );
  }

  Widget _drawerItem(BuildContext context, int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selectedPage == index,
      onTap: () {
        Navigator.pop(context);
        selectPage(index);
      },
    );
  }
}
