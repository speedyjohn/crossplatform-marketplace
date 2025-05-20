import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:market/pages/auth/auth_page.dart';
import 'package:market/pages/main/main_page.dart';
import 'package:market/pages/profile/guest_profile_page.dart';
import 'package:market/pages/settings/settings_page.dart';
import 'package:market/providers/AuthProvider.dart';
import 'package:market/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animations/animations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/connectivity_provider.dart';
import 'providers/user_session_provider.dart';
import 'providers/pin_provider.dart';
import 'services/pin_service.dart';

import 'package:flutter/cupertino.dart';

import 'providers/ThemeProvider.dart';
import 'custom_page_route.dart';
import 'firebase_options.dart';

import 'pages/product_list/product_list_page.dart';
import 'pages/cart/cart_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/pin/set_pin_page.dart';
import 'pages/pin/enter_pin_page.dart';
import 'widgets/offline_indicator.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('darkMode') ?? false;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)..updateTheme(isDark)),
          ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
          ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
          ChangeNotifierProvider(create: (_) => UserSessionProvider()),
          Provider(create: (_) => PinService(prefs)),
          ChangeNotifierProxyProvider<PinService, PinProvider>(
            create: (context) => PinProvider(context.read<PinService>()),
            update: (context, pinService, previous) => 
              previous ?? PinProvider(pinService),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'My Shop',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: themeProvider.themeMode,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
        Locale('kk', ''),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const PinWrapper(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.black,
        secondary: Colors.grey[600],
        background: Colors.white,
        onPrimary: Colors.black,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black12,
      iconTheme: const IconThemeData(color: Colors.white),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ).copyWith(
        primary: Colors.white,
        secondary: Colors.grey[100],
        background: Colors.black,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }
}

class PinWrapper extends StatefulWidget {
  const PinWrapper({Key? key}) : super(key: key);

  @override
  State<PinWrapper> createState() => _PinWrapperState();
}

class _PinWrapperState extends State<PinWrapper> {
  @override
  void initState() {
    super.initState();
    _initializePin();
  }

  Future<void> _initializePin() async {
    await context.read<PinProvider>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PinProvider>(
      builder: (context, pinProvider, child) {
        if (!pinProvider.isInitialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return FutureBuilder<bool>(
          future: pinProvider.hasPin(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!snapshot.data! && !pinProvider.isAuthenticated) {
              return const SetPinPage();
            }

            if (!pinProvider.isAuthenticated) {
              return const EnterPinPage();
            }

            return const MainScreen();
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProductListPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return FutureBuilder(
      future: authProvider.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (authProvider.isLoggedIn) {
          return const MainNavigationPage();
        } else {
          return Stack(
            children: [
              const MainNavigationPage(guestMode: true),
              if (authProvider.isGuest)
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: _GuestModeBanner(),
                ),
            ],
          );
        }
      },
    );
  }
}

class _GuestModeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.amber,
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.black),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Guest Mode - Some features are limited',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AuthPage()),
            ),
            child: const Text(
              'LOGIN',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  final bool guestMode;

  const MainNavigationPage({
    Key? key,
    this.guestMode = false,
  }) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ProductListPage(),
      if (!widget.guestMode) const CartPage(),
      widget.guestMode ? const GuestProfilePage() : ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    if (widget.guestMode && (index == 2 || index == 3)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to access this feature'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          const OfflineIndicator(),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          if(!widget.guestMode) const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(widget.guestMode ? Icons.lock : Icons.person),
            label: widget.guestMode ? 'Login' : 'Profile',
          ),
        ],
      ),
    );
  }
}