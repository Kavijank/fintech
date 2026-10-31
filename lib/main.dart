import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const FintrustDigitalApp());
}

const Color ink = Color(0xFF3D3332);
const Color teal = Color(0xFFAD302E);
const Color mint = Color(0xFFF8E9E7);
const Color canvas = Color(0xFFF4F4F6);
const Color line = Color(0xFFE9DBDA);
const Color muted = Color(0xFF867B7A);
const Color positive = Color(0xFF267657);

class FintrustDigitalApp extends StatefulWidget {
  const FintrustDigitalApp({super.key});

  @override
  State<FintrustDigitalApp> createState() => _FintrustDigitalAppState();
}

class _FintrustDigitalAppState extends State<FintrustDigitalApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final _DashboardRouteObserver _routeObserver = _DashboardRouteObserver(
    onStackChanged: (hasPushedRoute) {
      if (mounted && _hasPushedRoute != hasPushedRoute) {
        setState(() => _hasPushedRoute = hasPushedRoute);
      }
    },
  );
  bool _signedIn = false;
  bool _hasPushedRoute = false;
  int _selectedTab = 0;
  double _balance = 20690.50;
  final List<BankTransaction> _transactions = [
    BankTransaction('Corner Coffee', '6 Oct · Food & drink', -18.50),
    BankTransaction('Fresh Market', '5 Oct · Groceries', -86.20),
    BankTransaction('Metro Transit', '4 Oct · Transport', -24),
    BankTransaction('Salary · Acme Co.', '3 Oct · Income', 4250),
    BankTransaction('City Water', '2 Oct · Utilities', -42),
    BankTransaction('Tony Stark', '1 Oct · Transfer', -150),
  ];

  void _recordPayment(double amount, String recipient, bool scheduled) {
    setState(() {
      if (!scheduled) _balance -= amount;
      _transactions.insert(
        0,
        BankTransaction(
          recipient,
          scheduled ? 'Scheduled · Transfer' : 'Just now · Transfer',
          -amount,
        ),
      );
    });
    _navigatorKey.currentState?.push(
      MaterialPageRoute<void>(
        builder: (_) => PaymentConfirmationScreen(
          amount: amount,
          recipient: recipient,
          scheduled: scheduled,
          balance: _balance,
        ),
      ),
    );
  }

  void _goBack() {
    final navigator = _navigatorKey.currentState;
    if (navigator?.canPop() ?? false) {
      navigator!.pop();
    } else if (_selectedTab != 0) {
      setState(() => _selectedTab = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fintrust Digital App',
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      navigatorObservers: [_routeObserver],
      builder: (context, child) => LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = kIsWeb ? 390.0 : 600.0;
          final screenWidth = constraints.maxWidth.clamp(0.0, maxWidth);
          final app = SizedBox(
            width: screenWidth,
            height: constraints.maxHeight,
            child: _signedIn
                ? Scaffold(
                    body: SafeArea(
                      bottom: false,
                      child: Column(
                        children: [
                          PrototypeHeader(
                            showBackButton:
                                _selectedTab != 0 || _hasPushedRoute,
                            onBack: _goBack,
                            onProfile: () => _navigatorKey.currentState?.push(
                              MaterialPageRoute<void>(
                                builder: (_) => const SecurityScreen(),
                              ),
                            ),
                          ),
                          Expanded(child: child ?? const SizedBox.shrink()),
                        ],
                      ),
                    ),
                    bottomNavigationBar: PrototypeNavigation(
                      selectedIndex: _selectedTab,
                      onSelected: (index) => setState(() {
                        _selectedTab = index;
                      }),
                    ),
                  )
                : child ?? const SizedBox.shrink(),
          );
          return ColoredBox(
            color: canvas,
            child: Center(child: app),
          );
        },
      ),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          primary: teal,
          secondary: ink,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: canvas,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: mint,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 74,
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
            (states) => IconThemeData(
              color: states.contains(WidgetState.selected) ? teal : muted,
              size: 23,
            ),
          ),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected) ? teal : muted,
              fontSize: 11,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: line),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: teal, width: 1.5),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: teal,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: ink,
            fontWeight: FontWeight.w700,
            fontSize: 25,
            height: 1.12,
          ),
          titleLarge: TextStyle(
            color: ink,
            fontWeight: FontWeight.w700,
            fontSize: 21,
          ),
          titleMedium: TextStyle(
            color: ink,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(color: ink, fontSize: 15, height: 1.4),
          bodySmall: TextStyle(color: muted, fontSize: 13, height: 1.4),
        ),
      ),
      home: !_signedIn
          ? LoginScreen(onContinue: () => setState(() => _signedIn = true))
          : BankShell(
              balance: _balance,
              transactions: _transactions,
              onPayment: _recordPayment,
              selectedTab: _selectedTab,
              onTabSelected: (index) => setState(() => _selectedTab = index),
            ),
    );
  }
}

class _DashboardRouteObserver extends NavigatorObserver {
  _DashboardRouteObserver({required this.onStackChanged});

  final ValueChanged<bool> onStackChanged;
  final List<Route<dynamic>> _routes = [];

  void _notifyStackChanged() => onStackChanged(_routes.length > 1);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.add(route);
    _notifyStackChanged();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notifyStackChanged();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routes.remove(route);
    _notifyStackChanged();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final index = _routes.indexOf(oldRoute);
      if (index >= 0) {
        if (newRoute == null) {
          _routes.removeAt(index);
        } else {
          _routes[index] = newRoute;
        }
      } else if (newRoute != null) {
        _routes.add(newRoute);
      }
    } else if (newRoute != null) {
      _routes.add(newRoute);
    }
    _notifyStackChanged();
  }
}

class BankTransaction {
  const BankTransaction(this.name, this.detail, this.amount);

  final String name;
  final String detail;
  final double amount;
}

String money(double amount) =>
    'LKR ${amount.abs().toStringAsFixed(2).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onContinue, super.key});

  final VoidCallback onContinue;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  bool _rememberDevice = false;
  bool _credentialsAccepted = false;
  final _email = TextEditingController(text: 'Kavijan.Kavi@email.com');
  final _password = TextEditingController(text: 'demo-password');
  final _code = TextEditingController(text: '482106');
  final _codeFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _code.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      _message(context, 'Enter your email and password to continue.');
      return;
    }
    setState(() => _credentialsAccepted = true);
    FocusScope.of(context).requestFocus(_codeFocus);
  }

  void _verify() {
    if (!_credentialsAccepted) {
      _message(context, 'Sign in with your credentials before verifying.');
      return;
    }
    if (_code.text.trim() != '482106') {
      _message(context, 'Enter the demo verification code shown above.');
      return;
    }
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: _credentialsAccepted
              ? [
                  const BrandLockup(),
                  const SizedBox(height: 20),
                  const ScreenHeading(
                    title: 'Verify your identity',
                    subtitle:
                        'Complete the security check to continue securely.',
                  ),
                  const SizedBox(height: 14),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Multi-factor verification',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Enter the 6-digit code sent to your mobile ending in 482106.',
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                FocusScope.of(context).requestFocus(_codeFocus),
                            child: Row(
                              children: List.generate(6, (index) {
                                final digit = _code.text.length > index
                                    ? _code.text[index]
                                    : '';
                                return Expanded(
                                  child: Container(
                                    height: 48,
                                    margin: EdgeInsets.only(
                                      right: index == 5 ? 0 : 6,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: line),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      digit.isEmpty ? '' : digit,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: teal,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                            child: Opacity(
                              opacity: 0.01,
                              child: TextField(
                                key: const Key('mfa-code'),
                                controller: _code,
                                focusNode: _codeFocus,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                onChanged: (_) => setState(() {}),
                                decoration: const InputDecoration(
                                  counterText: '',
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Code expires in 01:59',
                                  style: TextStyle(color: muted, fontSize: 12),
                                ),
                              ),
                              TextButton(
                                onPressed: () => _message(
                                  context,
                                  'A new demo verification code has been sent.',
                                ),
                                child: const Text('Resend code'),
                              ),
                            ],
                          ),
                          PrimaryButton(
                            label: 'Verify & continue',
                            onPressed: _verify,
                          ),
                          TextButton(
                            onPressed: () => _message(
                              context,
                              'Use the authenticator code 482106 for this demo.',
                            ),
                            child: const Text('Use authenticator app instead'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
              : [
                  const BrandLockup(),
                  const SizedBox(height: 14),
                  const ScreenHeading(
                    title: 'Sign in',
                    subtitle: 'A secure start to your everyday banking',
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Welcome back, Kavi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sign in with your credentials or use a biometric option.',
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 12),
                  const FieldLabel('Email or username'),
                  TextField(
                    key: const Key('login-email'),
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Kavijan.Kavi@email.com',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const FieldLabel('Password'),
                  TextField(
                    key: const Key('login-password'),
                    controller: _password,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      hintText: '••••••••••••',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _showPassword
                            ? 'Hide password'
                            : 'Show password',
                        onPressed: () =>
                            setState(() => _showPassword = !_showPassword),
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 38,
                            child: Checkbox(
                              value: _rememberDevice,
                              onChanged: (value) => setState(
                                () => _rememberDevice = value ?? false,
                              ),
                            ),
                          ),
                          const Text(
                            'Remember this device',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () => _message(
                          context,
                          'Password reset instructions are ready to send.',
                        ),
                        child: const Text('Forgot password?'),
                      ),
                    ],
                  ),
                  PrimaryButton(
                    label: 'Sign in securely',
                    icon: Icons.lock_outline,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 12),
                  const InfoBanner(
                    icon: Icons.shield_outlined,
                    text: 'Your connection is encrypted. This interactive demo does not connect to a bank account.',
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Biometric sign-in',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _message(
                                    context,
                                    'Face recognition is available after first login on a trusted device.',
                                  ),
                                  icon: const Icon(
                                    Icons.face_retouching_natural,
                                  ),
                                  label: const Text('Face recognition'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _message(
                                    context,
                                    'Fingerprint sign-in is available after first login on a trusted device.',
                                  ),
                                  icon: const Icon(Icons.fingerprint),
                                  label: const Text('Fingerprint'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Available after first login on a trusted device.',
                            style: TextStyle(color: muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _message(
                            context,
                            'Account opening is not available in this demo.',
                          ),
                          child: const Text('Open an account'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _message(
                            context,
                            'Contact support from the Help section after signing in.',
                          ),
                          child: const Text('Get help'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const InfoBanner(
                    icon: Icons.shield_outlined,
                    text: 'Your connection is encrypted. We will never ask for your password or verification code.',
                  ),
                ],
        ),
      ),
    );
  }
}

class BankShell extends StatefulWidget {
  const BankShell({
    required this.balance,
    required this.transactions,
    required this.onPayment,
    required this.selectedTab,
    required this.onTabSelected,
    super.key,
  });

  final double balance;
  final List<BankTransaction> transactions;
  final void Function(double amount, String recipient, bool scheduled)
  onPayment;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  @override
  State<BankShell> createState() => _BankShellState();
}

class _BankShellState extends State<BankShell> {
  void _open(Widget page) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        balance: widget.balance,
        transactions: widget.transactions,
        onPayment: widget.onPayment,
        onNavigate: widget.onTabSelected,
        onOpen: _open,
      ),
      PaymentsScreen(onOpen: _open, onPayment: widget.onPayment),
      SearchScreen(onOpen: _open, onPayment: widget.onPayment),
      FinanceScreen(balance: widget.balance, onOpen: _open),
      const NotificationsScreen(),
    ];
    return Scaffold(
      body: IndexedStack(index: widget.selectedTab, children: pages),
    );
  }
}

class PrototypeHeader extends StatelessWidget {
  const PrototypeHeader({
    required this.showBackButton,
    required this.onBack,
    required this.onProfile,
    super.key,
  });

  final bool showBackButton;
  final VoidCallback onBack;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
    child: Row(
      children: [
        if (showBackButton) ...[
          IconButton(
            key: const Key('dashboard-back'),
            onPressed: onBack,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.arrow_back,
              color: teal,
              semanticLabel: 'Back',
            ),
          ),
          const SizedBox(width: 4),
        ],
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: teal,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.account_balance_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 9),
        const Expanded(
          child: Text(
            'Fintrust Digital App',
            style: TextStyle(
              color: teal,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Material(
          color: mint,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onProfile,
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: Text(
                  'K',
                  style: TextStyle(color: teal, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class PrototypeNavigation extends StatelessWidget {
  const PrototypeNavigation({
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 1, color: line),
          Row(
            children: [
              for (final (index, icon, label) in <(int, IconData, String)>[
                (0, Icons.home_outlined, 'Home'),
                (1, Icons.swap_horiz, 'Payments'),
                (2, Icons.search, 'Search'),
                (3, Icons.monitor_heart_outlined, 'Finance'),
                (4, Icons.more_horiz, 'More'),
              ])
                Expanded(
                  child: InkWell(
                    onTap: () => onSelected(index),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 28,
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? mint
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              icon,
                              size: 20,
                              color: selectedIndex == index ? teal : muted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            label,
                            style: TextStyle(
                              color: selectedIndex == index ? teal : muted,
                              fontSize: 10,
                              fontWeight: selectedIndex == index
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              'Interactive demo · Not connected to a bank account',
              style: TextStyle(color: muted, fontSize: 10),
            ),
          ),
        ],
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.balance,
    required this.transactions,
    required this.onPayment,
    required this.onNavigate,
    required this.onOpen,
    super.key,
  });

  final double balance;
  final List<BankTransaction> transactions;
  final void Function(double amount, String recipient, bool scheduled)
  onPayment;
  final ValueChanged<int> onNavigate;
  final ValueChanged<Widget> onOpen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hideBalance = false;

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.swap_horiz, 'Transfer', () => widget.onNavigate(1)),
      (Icons.receipt_long_outlined, 'Pay bills', () => widget.onNavigate(1)),
      (
        Icons.qr_code_scanner,
        'Scan QR',
        () => widget.onOpen(QrPaymentScreen(onPayment: widget.onPayment)),
      ),
      (Icons.phone_android, 'Reload', () => widget.onNavigate(1)),
      (
        Icons.description_outlined,
        'Statements',
        () => widget.onOpen(
          TransactionHistoryScreen(transactions: widget.transactions),
        ),
      ),
      (Icons.location_on_outlined, 'Find ATM', () => widget.onNavigate(2)),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Banking dashboard',
          subtitle: 'Good morning, Kavijan · 6 Oct 2026',
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: teal,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'TOTAL CASH BALANCE · LKR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: _hideBalance ? 'Show balance' : 'Hide balance',
                    onPressed: () =>
                        setState(() => _hideBalance = !_hideBalance),
                    color: Colors.white,
                    icon: Icon(
                      _hideBalance
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 19,
                    ),
                  ),
                ],
              ),
              Text(
                _hideBalance ? 'LKR ••••••' : money(widget.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Updated just now · 2 accounts',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Column(
              children: [
                SectionHeading(
                  'Your accounts',
                  action: 'Manage',
                  onAction: () => widget.onNavigate(4),
                ),
                const _AccountRow(
                  icon: Icons.account_balance_wallet_outlined,
                  name: 'Everyday Checking',
                  detail: 'Account ·· 4821',
                  amount: 'LKR 8,240.50',
                ),
                const _AccountRow(
                  icon: Icons.savings_outlined,
                  name: 'High-Yield Savings',
                  detail: 'Account ·· 9034 · 3.50% APY',
                  amount: 'LKR 12,450.00',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const SectionHeading('Quick shortcuts'),
        const SizedBox(height: 8),
        for (var start = 0; start < actions.length; start += 3) ...[
          Row(
            children: [
              for (var index = start; index < start + 3; index++) ...[
                if (index > start) const SizedBox(width: 9),
                Expanded(
                  child: QuickAction(
                    icon: actions[index].$1,
                    label: actions[index].$2,
                    onTap: actions[index].$3,
                  ),
                ),
              ],
            ],
          ),
          if (start == 0) const SizedBox(height: 9),
        ],
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Column(
              children: [
                SectionHeading(
                  'Recent transactions',
                  action: 'View all',
                  onAction: () => widget.onOpen(
                    ActivityGoalsScreen(transactions: widget.transactions),
                  ),
                ),
                ...widget.transactions
                    .take(3)
                    .map(
                      (transaction) =>
                          TransactionTile(transaction: transaction),
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeading(
                  'Savings goal',
                  action: 'Goals',
                  onAction: () => widget.onNavigate(3),
                ),
                const _ProgressRow(
                  title: 'Emergency fund',
                  detail: 'LKR 6,000 of LKR 10,000 · Target Dec 2026',
                  value: .6,
                  trailing: '60%',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeading(
                  'Investments',
                  action: 'Portfolio',
                  onAction: () => widget.onNavigate(3),
                ),
                const DetailRow(
                  label: 'Portfolio value',
                  value: 'LKR 18,620.00',
                ),
                const SizedBox(height: 5),
                const Text(
                  '+LKR 620.00 (+3.44%) this month',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Stocks 60% / Bonds 30% / Cash 10%',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: mint,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your monthly insight',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                const Text(
                  'You spent 8% less than September.',
                  style: TextStyle(
                    color: teal,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Dining is down LKR 64. Keep the momentum going.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              children: [
                SectionHeading(
                  'Monthly spending',
                  action: 'View insights',
                  onAction: () => widget.onOpen(const SpendingInsightsScreen()),
                ),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'LKR 2,340 spent',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      'LKR 3,000 budget',
                      style: TextStyle(color: teal, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 2340 / 3000,
                    minHeight: 6,
                    backgroundColor: line,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Budgeting tip'),
                const Text(
                  'Dining is at 80% of its LKR 350 limit. Plan two meals at home this week to stay on track.',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => widget.onNavigate(3),
                        child: const Text('Adjust budget'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => widget.onOpen(const AssistantScreen()),
                        child: const Text('Ask assistant'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                SectionHeading('Upcoming bills'),
                _AccountRow(
                  icon: Icons.bolt,
                  name: 'City Electric',
                  detail: 'Due 10 Oct · Autopay on',
                  amount: 'LKR 74.60',
                ),
                _AccountRow(
                  icon: Icons.wifi,
                  name: 'Home Internet',
                  detail: 'Due 12 Oct · Pay now',
                  amount: 'LKR 59.00',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Recommended for you'),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Put spare change to work'),
                  subtitle: Text('Round up card purchases into savings.'),
                  trailing: Text('Explore ›', style: TextStyle(color: teal)),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Earn cashback on groceries'),
                  subtitle: Text('Activate your 2% Fresh Market offer.'),
                  trailing: Text('Activate ›', style: TextStyle(color: teal)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ActivityGoalsScreen extends StatelessWidget {
  const ActivityGoalsScreen({this.transactions = const [], super.key});

  final List<BankTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final activity = transactions.isEmpty
        ? const [
            BankTransaction('Corner Coffee', '6 Oct · Food & drink', -18.50),
            BankTransaction('Fresh Market', '5 Oct · Groceries', -86.20),
            BankTransaction('Salary · Acme Co.', '3 Oct · Income', 4250),
          ]
        : transactions.take(3).toList();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
        children: [
          const ScreenHeading(
            title: 'Activity & goals',
            subtitle: 'Good morning, Kavijan · 6 Oct 2026',
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Column(
                children: [
                  SectionHeading(
                    'Recent transactions',
                    action: 'View all',
                    onAction: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => TransactionHistoryScreen(
                          transactions: transactions,
                        ),
                      ),
                    ),
                  ),
                  ...activity.map(
                    (transaction) => TransactionTile(transaction: transaction),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SectionHeading('Savings goal', action: 'Goals'),
                  _ProgressRow(
                    title: 'Emergency fund',
                    detail: 'LKR 6,000 of LKR 10,000 · Target Dec 2026',
                    value: .6,
                    trailing: '60%',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeading('Investments', action: 'Portfolio'),
                  DetailRow(label: 'Portfolio value', value: 'LKR 18,620.00'),
                  SizedBox(height: 4),
                  Text(
                    '+LKR 620.00 (+3.44%) this month',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Stocks 60% / Bonds 30% / Cash 10%',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingInsightsScreen extends StatefulWidget {
  const SpendingInsightsScreen({super.key});

  @override
  State<SpendingInsightsScreen> createState() => _SpendingInsightsScreenState();
}

class _SpendingInsightsScreenState extends State<SpendingInsightsScreen> {
  String _period = 'Month';

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Spending insights',
          subtitle: 'Your money, made clearer · October 2026',
        ),
        const SizedBox(height: 12),
        Card(
          color: mint,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Your monthly insight',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 10),
                Text(
                  'You spent 8% less than September.',
                  style: TextStyle(
                    color: teal,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Dining is down LKR 64. Keep the momentum going.',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Monthly spending', action: 'Details'),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'LKR 2,340 spent',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      'LKR 3,000 budget',
                      style: TextStyle(color: teal, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Month', label: Text('Month')),
                    ButtonSegment(value: 'Quarter', label: Text('Quarter')),
                    ButtonSegment(value: 'Year', label: Text('Year')),
                  ],
                  selected: {_period},
                  onSelectionChanged: (selection) =>
                      setState(() => _period = selection.first),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('1.9k', style: TextStyle(color: muted, fontSize: 10)),
                    Text('2.2k', style: TextStyle(color: muted, fontSize: 10)),
                    Text('2.1k', style: TextStyle(color: muted, fontSize: 10)),
                    Text('2.8k', style: TextStyle(color: muted, fontSize: 10)),
                    Text('2.5k', style: TextStyle(color: muted, fontSize: 10)),
                    Text('2.3k', style: TextStyle(color: muted, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 4),
                const SpendingBars(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('May', style: TextStyle(color: muted, fontSize: 10)),
                    Text('Jun', style: TextStyle(color: muted, fontSize: 10)),
                    Text('Jul', style: TextStyle(color: muted, fontSize: 10)),
                    Text('Aug', style: TextStyle(color: muted, fontSize: 10)),
                    Text('Sep', style: TextStyle(color: muted, fontSize: 10)),
                    Text(
                      'Oct',
                      style: TextStyle(
                        color: teal,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Budgeting tip'),
                const Text(
                  'Dining is at 80% of its LKR 350 limit. Plan two meals at home this week to stay on track.',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _message(
                          context,
                          'Budget settings are available in Finance.',
                        ),
                        child: const Text('Adjust budget'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const AssistantScreen(),
                          ),
                        ),
                        child: const Text('Ask assistant'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class BillsRecommendationsScreen extends StatelessWidget {
  const BillsRecommendationsScreen({required this.onPayment, super.key});

  final void Function(double, String, bool) onPayment;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Bills & recommendations',
          subtitle: 'Manage upcoming bills and savings progress · October 2026',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Column(
              children: [
                const SectionHeading('Upcoming bills', action: 'See all'),
                _AccountRow(
                  icon: Icons.bolt,
                  name: 'City Electric',
                  detail: 'Due 10 Oct · Autopay on',
                  amount: 'LKR 74.60',
                ),
                _AccountRow(
                  icon: Icons.wifi,
                  name: 'Home Internet',
                  detail: 'Due 12 Oct · Pay now',
                  amount: 'LKR 59.00',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeading('Savings progress'),
                _ProgressRow(
                  title: 'Emergency fund',
                  detail: 'LKR 6,000 / LKR 10,000 · LKR 250 monthly',
                  value: .6,
                  trailing: '60%',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Recommended for you'),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Put spare change to work'),
                  subtitle: Text('Round up card purchases into savings.'),
                  trailing: Text('Explore ›', style: TextStyle(color: teal)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Earn cashback on groceries'),
                  subtitle: const Text('Activate your 2% Fresh Market offer.'),
                  trailing: TextButton(
                    onPressed: () => _message(
                      context,
                      'Fresh Market cashback offer activated.',
                    ),
                    child: const Text('Activate ›'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => BillPaymentScreen(onPayment: onPayment),
            ),
          ),
          child: const Text('Pay a bill'),
        ),
      ],
    ),
  );
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.icon,
    required this.name,
    required this.detail,
    required this.amount,
  });

  final IconData icon;
  final String name;
  final String detail;
  final String amount;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: mint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: teal),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(detail, style: const TextStyle(color: muted, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          amount,
          textAlign: TextAlign.end,
          style: const TextStyle(color: teal, fontSize: 12),
        ),
      ],
    ),
  );
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.title,
    required this.detail,
    required this.value,
    required this.trailing,
  });

  final String title;
  final String detail;
  final double value;
  final String trailing;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(color: teal, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 7,
          color: teal,
          backgroundColor: line,
        ),
      ),
    ],
  );
}

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({
    required this.onOpen,
    required this.onPayment,
    super.key,
  });

  final ValueChanged<Widget> onOpen;
  final void Function(double, String, bool) onPayment;

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  int _selectedView = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Make a payment',
          subtitle: 'Send money, pay bills and manage recipients.',
        ),
        const SizedBox(height: 12),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('Payment options')),
            ButtonSegment(value: 1, label: Text('Beneficiaries')),
          ],
          selected: {_selectedView},
          onSelectionChanged: (selection) =>
              setState(() => _selectedView = selection.first),
        ),
        const SizedBox(height: 12),
        if (_selectedView == 0)
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading('Choose a payment'),
                  _paymentOption(
                    Icons.account_balance_outlined,
                    'Local bank transfer',
                    'Send to any domestic bank account',
                    () => widget.onOpen(
                      TransferScreen(onPayment: widget.onPayment),
                    ),
                  ),
                  _paymentOption(
                    Icons.account_balance_wallet_outlined,
                    'Digital wallets',
                    'Top up or transfer to a linked wallet',
                    () => _message(
                      context,
                      'Wallet payments are simulated in this demo.',
                    ),
                  ),
                  _paymentOption(
                    Icons.receipt_long_outlined,
                    'Utility bills',
                    'Electricity, water, internet and more',
                    () => widget.onOpen(
                      BillsRecommendationsScreen(onPayment: widget.onPayment),
                    ),
                  ),
                  _paymentOption(
                    Icons.public_outlined,
                    'International remittance',
                    'Send abroad · View rates & fees',
                    () => _message(
                      context,
                      'International transfers are simulated in this demo.',
                    ),
                  ),
                  _paymentOption(
                    Icons.qr_code_scanner,
                    'QR payments',
                    'Scan a merchant or personal QR code',
                    () => widget.onOpen(
                      QrPaymentScreen(onPayment: widget.onPayment),
                    ),
                  ),
                  _paymentOption(
                    Icons.phone_android,
                    'Mobile & prepaid reloads',
                    'Add airtime, data or prepaid credit',
                    () => _message(
                      context,
                      'Mobile reloads are simulated in this demo.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_selectedView == 1) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeading(
                    'Saved beneficiaries',
                    action: 'Add new +',
                    onAction: () => widget.onOpen(const BeneficiariesScreen()),
                  ),
                  const FieldLabel('Find a beneficiary'),
                  const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search name or account',
                    ),
                  ),
                  const SizedBox(height: 8),
                  _recipient(
                    context,
                    'JL',
                    'Jamie Lee',
                    'North Bank ·· 6672 · Favorite',
                    widget.onOpen,
                    widget.onPayment,
                  ),
                  _recipient(
                    context,
                    'SR',
                    'Steve Rogers',
                    'Metro Bank ·· 1198',
                    widget.onOpen,
                    widget.onPayment,
                  ),
                  _recipient(
                    context,
                    'CC',
                    'Corner Coffee',
                    'Merchant ·· 7710',
                    widget.onOpen,
                    widget.onPayment,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              widget.onOpen(const BeneficiariesScreen()),
                          child: const Text('Manage favorites'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              widget.onOpen(const BeneficiariesScreen()),
                          child: const Text('Remove recipient'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SectionHeading('Scheduled payments', action: 'Manage'),
                  _AccountRow(
                    icon: Icons.event_repeat,
                    name: 'Emergency fund',
                    detail: 'LKR 250 · Monthly · Next 15 Oct',
                    amount: 'Active',
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'Daily transfer limit: LKR 10,000 · LKR 9,850 remaining today.',
              style: TextStyle(color: muted, fontSize: 11),
            ),
          ),
        ],
      ],
    );
  }

  Widget _recipient(
    BuildContext context,
    String initials,
    String name,
    String detail,
    ValueChanged<Widget> onOpen,
    void Function(double, String, bool) onPayment,
  ) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: mint,
          foregroundColor: teal,
          child: Text(
            initials,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(detail),
        trailing: IconButton(
          tooltip: 'Send to $name',
          onPressed: () => onOpen(
            TransferScreen(onPayment: onPayment, initialRecipient: name),
          ),
          icon: const Icon(Icons.arrow_forward),
        ),
        onTap: () => onOpen(
          TransferScreen(onPayment: onPayment, initialRecipient: name),
        ),
      ),
    );
  }

  Widget _paymentOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
    leading: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: mint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 19, color: teal),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 11)),
    trailing: const Icon(Icons.chevron_right, color: teal, size: 19),
    onTap: onTap,
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    required this.onOpen,
    required this.onPayment,
    super.key,
  });

  final ValueChanged<Widget> onOpen;
  final void Function(double amount, String recipient, bool scheduled)
  onPayment;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _search = TextEditingController(text: 'Coffee');
  String _selectedCategory = 'All';
  final List<_SearchItem> _items = [
    _SearchItem(
      'Corner Coffee',
      'Transaction · 6 Oct 2026 · Food & drink · LKR 18.50',
      Icons.coffee_outlined,
      TransactionHistoryScreen(),
    ),
    _SearchItem(
      'Corner Coffee',
      'Transaction · 29 Sep 2026 · Food & drink · LKR 12.00',
      Icons.coffee_outlined,
      TransactionHistoryScreen(),
    ),
    const _SearchItem(
      'Jamie Lee',
      'People · North Bank ·· 6672',
      Icons.person_outline,
      null,
      initialRecipient: 'Jamie Lee',
    ),
    const _SearchItem(
      'City Electric',
      'Bills · LKR 74.60 · Due 10 Oct',
      Icons.bolt,
      null,
      initialRecipient: 'City Electric',
    ),
    _SearchItem(
      'Transfer money',
      'Payments · Send to a person or account',
      Icons.swap_horiz,
      null,
    ),
    _SearchItem(
      'Statements',
      'Accounts · Download monthly statements',
      Icons.description_outlined,
      TransactionHistoryScreen(),
    ),
    _SearchItem(
      'Savings goals',
      'Finance · Track your progress',
      Icons.savings_outlined,
      FinanceScreen(balance: 18450, onOpen: (_) {}),
    ),
    _SearchItem(
      'Card controls',
      'Security · Manage your cards',
      Icons.credit_card_outlined,
      const SecurityScreen(),
    ),
    _SearchItem(
      'Contact support',
      'Help · Chat with our assistant',
      Icons.support_agent,
      const SupportHelpScreen(),
    ),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _search.text.toLowerCase();
    final results = _items
        .where(
          (item) =>
              '${item.title} ${item.subtitle}'.toLowerCase().contains(query) &&
              (_selectedCategory == 'All' ||
                  (_selectedCategory == 'Transactions' &&
                      item.subtitle.startsWith('Transaction')) ||
                  (_selectedCategory == 'People' &&
                      item.subtitle.startsWith('People'))),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
      children: [
        ScreenHeading(
          title: _selectedCategory == 'Places'
              ? 'Nearby banking & shortcuts'
              : 'Smart search',
          subtitle: _selectedCategory == 'Places'
              ? 'Quick actions and recent searches'
              : 'Find transactions, people and nearby banking',
        ),
        if (_selectedCategory != 'Places') ...[
          const SizedBox(height: 14),
          const FieldLabel('Search across North Bank'),
          TextField(
            key: const Key('bank-search'),
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Merchant, person or feature',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _search.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () =>
                _message(context, 'Voice search is not enabled in this demo.'),
            icon: const Icon(Icons.mic_none),
            label: const Text('Tap to use voice search'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try “coffee last week” or “ATMs near me”.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          const SizedBox(height: 17),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'All', label: Text('All')),
              ButtonSegment(value: 'Transactions', label: Text('Transactions')),
              ButtonSegment(value: 'People', label: Text('People')),
              ButtonSegment(value: 'Places', label: Text('Places')),
            ],
            selected: {_selectedCategory},
            onSelectionChanged: (selection) =>
                setState(() => _selectedCategory = selection.first),
          ),
        ],
        const SizedBox(height: 12),
        if (_selectedCategory != 'Places') ...[
          SectionHeading(
            _selectedCategory == 'People' ? 'People' : 'Transactions',
            action: '${results.length} results',
          ),
          const SizedBox(height: 8),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text('No matches. Try a different search.')),
            )
          else
            ...results.map(
              (item) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: mint,
                    child: Icon(item.icon, color: teal),
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    if (item.title == 'Transfer money') {
                      widget.onOpen(
                        TransferScreen(onPayment: widget.onPayment),
                      );
                    } else if (item.initialRecipient != null) {
                      widget.onOpen(
                        TransferScreen(
                          onPayment: widget.onPayment,
                          initialRecipient: item.initialRecipient,
                        ),
                      );
                    } else {
                      widget.onOpen(
                        item.page ?? const TransactionHistoryScreen(),
                      );
                    }
                  },
                ),
              ),
            ),
        ],
        if (_selectedCategory != 'Places') ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading('Saved beneficiary'),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: mint,
                      child: Icon(Icons.storefront_outlined, color: teal),
                    ),
                    title: const Text('Corner Coffee'),
                    subtitle: const Text('Merchant · Account ·· 7710'),
                    trailing: TextButton(
                      onPressed: () => widget.onOpen(
                        TransferScreen(
                          onPayment: widget.onPayment,
                          initialRecipient: 'Corner Coffee',
                        ),
                      ),
                      child: const Text('Pay ›'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (_selectedCategory == 'Places') ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeading(
                    'Branches & ATMs nearby',
                    action: 'Map view',
                    onAction: () => _message(
                      context,
                      'Map preview is available in this demo.',
                    ),
                  ),
                  const _AccountRow(
                    icon: Icons.account_balance_outlined,
                    name: 'North Bank · Central branch',
                    detail: '0.8 mi · Open until 5:00 PM',
                    amount: 'Directions',
                  ),
                  const _AccountRow(
                    icon: Icons.location_on_outlined,
                    name: 'Market Street ATM',
                    detail: '0.3 mi · 24/7 · Cash & deposits',
                    amount: 'Directions',
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Using your current location · Change location',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const SectionHeading('Quick actions'),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final (label, action) in <(String, VoidCallback)>[
                (
                  'Transfer',
                  () => widget.onOpen(
                    TransferScreen(onPayment: widget.onPayment),
                  ),
                ),
                (
                  'Pay a bill',
                  () => widget.onOpen(
                    BillPaymentScreen(onPayment: widget.onPayment),
                  ),
                ),
                (
                  'Reload',
                  () =>
                      _message(context, 'Reloads are simulated in this demo.'),
                ),
              ]) ...[
                if (label != 'Transfer') const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(onPressed: action, child: Text(label)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SectionHeading('Recent searches'),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Jamie Lee'),
                    trailing: Icon(Icons.close, color: teal, size: 16),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Electric bill'),
                    trailing: Icon(Icons.close, color: teal, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        const SectionHeading('Quick actions'),
        Row(
          children: [
            for (final (label, action) in <(String, VoidCallback)>[
              (
                'Transfer',
                () =>
                    widget.onOpen(TransferScreen(onPayment: widget.onPayment)),
              ),
              (
                'Pay a bill',
                () => widget.onOpen(
                  BillPaymentScreen(onPayment: widget.onPayment),
                ),
              ),
              (
                'Reload',
                () => _message(
                  context,
                  'Mobile reloads are simulated in this demo.',
                ),
              ),
            ]) ...[
              if (label != 'Transfer') const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(onPressed: action, child: Text(label)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SectionHeading('Recent searches'),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Jamie Lee'),
                  trailing: Icon(Icons.close, size: 16, color: teal),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Electric bill'),
                  trailing: Icon(Icons.close, size: 16, color: teal),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchItem {
  const _SearchItem(
    this.title,
    this.subtitle,
    this.icon,
    this.page, {
    this.initialRecipient,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? page;
  final String? initialRecipient;
}

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({required this.balance, required this.onOpen, super.key});

  final double balance;
  final ValueChanged<Widget> onOpen;

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  String _period = 'Month';
  String _section = 'Overview';
  double _goal = 10000;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
      children: [
        const ScreenHeading(
          title: 'Savings & rewards',
          subtitle: 'Plan, save and get more from your money',
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'Overview', label: Text('Overview')),
            ButtonSegment(value: 'Goals', label: Text('Goals')),
            ButtonSegment(value: 'Budgets', label: Text('Budgets')),
          ],
          selected: {_section},
          onSelectionChanged: (selection) =>
              setState(() => _section = selection.first),
        ),
        const SizedBox(height: 12),
        if (_section != 'Budgets') ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SectionHeading(
                    'Savings goals',
                    action: 'Manage',
                    onAction: _editGoal,
                  ),
                  const _ProgressRow(
                    title: 'Emergency fund',
                    detail: 'LKR 6,000 / LKR 10,000 · Target Dec 2026',
                    value: .6,
                    trailing: '60%',
                  ),
                  const SizedBox(height: 16),
                  const _ProgressRow(
                    title: 'Summer trip',
                    detail: 'LKR 1,200 / LKR 3,000 · Target Jun 2027',
                    value: .4,
                    trailing: '40%',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading('Create a goal'),
                  const FieldLabel('Goal name'),
                  const TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.laptop_outlined),
                      hintText: 'New laptop',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const FieldLabel('Target amount & date'),
                  TextField(
                    readOnly: true,
                    onTap: _editGoal,
                    decoration: const InputDecoration(
                      hintText: 'LKR 2,000.00 / March 2027',
                      suffixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Create savings goal',
                    icon: Icons.add,
                    onPressed: _editGoal,
                  ),
                ],
              ),
            ),
          ),
        ],
        if (_section == 'Budgets') ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading('October budget', action: 'Edit'),
                  const Text(
                    'LKR 660 remaining',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'LKR 2,340 spent / LKR 3,000 monthly limit',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  const LinearProgressIndicator(
                    value: .78,
                    color: teal,
                    backgroundColor: line,
                    minHeight: 7,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  const SizedBox(height: 8),
                  const _AccountRow(
                    icon: Icons.restaurant_outlined,
                    name: 'Dining',
                    detail: 'LKR 280 / LKR 350 · 80% used',
                    amount: 'LKR 70 left',
                  ),
                  const _AccountRow(
                    icon: Icons.shopping_basket_outlined,
                    name: 'Groceries',
                    detail: 'LKR 420 / LKR 500 · 84% used',
                    amount: 'LKR 80 left',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 19),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MONTHLY SPENDING',
                    style: TextStyle(
                      color: muted,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'LKR 2,340 spent',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                  ),
                  const Text('You spent 8% less than September.'),
                  const SizedBox(height: 17),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Month', label: Text('Month')),
                      ButtonSegment(value: 'Quarter', label: Text('Quarter')),
                      ButtonSegment(value: 'Year', label: Text('Year')),
                    ],
                    selected: {_period},
                    onSelectionChanged: (selection) =>
                        setState(() => _period = selection.first),
                  ),
                  const SizedBox(height: 22),
                  const SpendingBars(),
                  const SizedBox(height: 10),
                  const Text(
                    'May     Jun      Jul      Aug      Sep      Oct',
                    style: TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Emergency fund',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Text(
                        '${(6000 / _goal * 100).round()}%',
                        style: const TextStyle(
                          color: teal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text('LKR 6,000 saved · Target ${money(_goal)}'),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: (6000 / _goal).clamp(0, 1),
                    minHeight: 8,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    color: teal,
                    backgroundColor: line,
                  ),
                  const SizedBox(height: 13),
                  OutlinedButton.icon(
                    onPressed: _editGoal,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Adjust savings goal'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeading('Spending by category'),
          const SizedBox(height: 8),
          const _CategoryRow(
            icon: Icons.home_outlined,
            label: 'Housing & bills',
            amount: 'LKR 1,240',
            share: .53,
          ),
          const _CategoryRow(
            icon: Icons.restaurant_outlined,
            label: 'Food & dining',
            amount: 'LKR 620',
            share: .27,
          ),
          const _CategoryRow(
            icon: Icons.directions_bus_outlined,
            label: 'Transport',
            amount: 'LKR 310',
            share: .13,
          ),
          const _CategoryRow(
            icon: Icons.shopping_bag_outlined,
            label: 'Other',
            amount: 'LKR 170',
            share: .07,
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: mint,
                child: Icon(Icons.auto_graph, color: teal),
              ),
              title: const Text('Build an emergency cushion'),
              subtitle: const Text(
                'Set aside LKR 250 each month to reach your goal.',
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: _editGoal,
            ),
          ),
        ],
        if (_section == 'Overview') ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading('Loyalty & cashback', action: 'Offers'),
                  const _AccountRow(
                    icon: Icons.card_giftcard_outlined,
                    name: 'Cashback earned',
                    detail: 'October rewards · 1,240 loyalty points',
                    amount: 'LKR 24.80',
                  ),
                  const Text(
                    'Recommended: earn 2% back at Fresh Market.',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _message(
                            context,
                            'Rewards redemption is simulated in this demo.',
                          ),
                          child: const Text('Redeem rewards'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _message(
                            context,
                            'Fresh Market cashback offer activated.',
                          ),
                          child: const Text('Activate offer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _editGoal() async {
    final controller = TextEditingController(text: _goal.toStringAsFixed(0));
    final value = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Savings goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Target amount (LKR)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, double.tryParse(controller.text)),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null && value > 0) setState(() => _goal = value);
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.icon,
    required this.label,
    required this.amount,
    required this.share,
  });
  final IconData icon;
  final String label;
  final String amount;
  final double share;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: mint,
          child: Icon(icon, color: teal, size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: share,
                color: teal,
                backgroundColor: line,
                minHeight: 5,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class SpendingBars extends StatelessWidget {
  const SpendingBars({super.key});

  @override
  Widget build(BuildContext context) {
    const values = [.40, .48, .44, .74, .62, .58];
    return SizedBox(
      height: 126,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var index = 0; index < values.length; index++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: FractionallySizedBox(
                  heightFactor: values[index],
                  alignment: Alignment.bottomCenter,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: index == values.length - 1
                          ? teal
                          : const Color(0xFFE3C2C0),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({required this.onOpen, super.key});

  final ValueChanged<Widget> onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 26),
      children: [
        const ScreenHeading(
          title: 'More',
          subtitle: 'Your preferences, support and security.',
        ),
        const SizedBox(height: 18),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: ink,
              child: Icon(Icons.person_outline, color: Colors.white),
            ),
            title: const Text(
              'Kavi K.',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: const Text('Everyday Checking ·· 4821'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onOpen(const SecurityScreen()),
          ),
        ),
        const SizedBox(height: 16),
        const SectionHeading('Your banking'),
        _MoreRow(
          icon: Icons.receipt_long_outlined,
          title: 'Transaction history',
          detail: 'Search and review account activity',
          onTap: () => onOpen(const TransactionHistoryScreen()),
        ),
        _MoreRow(
          icon: Icons.notifications_none,
          title: 'Notifications',
          detail: 'Alerts and delivery preferences',
          onTap: () => onOpen(const NotificationsScreen()),
        ),
        _MoreRow(
          icon: Icons.people_outline,
          title: 'Beneficiaries',
          detail: 'Manage saved recipients',
          onTap: () => onOpen(const BeneficiariesScreen()),
        ),
        _MoreRow(
          icon: Icons.lock_outline,
          title: 'Privacy & security',
          detail: 'Sign-in, devices and account protection',
          onTap: () => onOpen(const SecurityScreen()),
        ),
        const SizedBox(height: 16),
        const SectionHeading('Help & support'),
        _MoreRow(
          icon: Icons.smart_toy_outlined,
          title: 'AI assistant',
          detail: 'Ask about payments and accounts',
          onTap: () => onOpen(const AssistantScreen()),
        ),
        _MoreRow(
          icon: Icons.support_agent,
          title: 'Contact support',
          detail: 'Available 24/7 in this demo',
          onTap: () => onOpen(const AssistantScreen()),
        ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () =>
              _message(context, 'You have been signed out of this demo.'),
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Fintrust Digital App · Demo experience',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _MoreRow extends StatelessWidget {
  const _MoreRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
    leading: CircleAvatar(
      backgroundColor: mint,
      child: Icon(icon, color: teal),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(detail),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}

class TransferScreen extends StatefulWidget {
  const TransferScreen({
    required this.onPayment,
    this.initialRecipient,
    super.key,
  });

  final void Function(double amount, String recipient, bool scheduled)
  onPayment;
  final String? initialRecipient;

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _scrollController = ScrollController();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  late String _recipient;
  int _step = 0;
  bool _scheduled = false;
  bool _recurring = false;
  DateTime _date = DateTime(2026, 10, 7);
  DateTime _endDate = DateTime(2027, 1, 7);

  static const _recipients = [
    'Jamie Lee',
    'Steve Rogers',
    'Corner Coffee',
    'City Electric',
  ];

  @override
  void initState() {
    super.initState();
    _recipient = _recipients.contains(widget.initialRecipient)
        ? widget.initialRecipient!
        : _recipients.first;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
        children: [
          ScreenHeading(
            title: _step == 0 ? 'Transfer details' : 'Schedule & review',
            subtitle: _step == 0
                ? 'Local bank transfer · Step 1 of 2'
                : 'Step 2 of 2 · Confirm timing and summary',
          ),
          const SizedBox(height: 16),
          if (_step == 0) ...[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Recipient',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    trailing: TextButton(
                      onPressed: _chooseRecipient,
                      child: const Text('Change'),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: mint,
                      child: Icon(Icons.person_outline, color: teal),
                    ),
                    title: Text(_recipient),
                    subtitle: Text(
                      _recipient == 'Jamie Lee'
                          ? 'North Bank · Account ·· 6672'
                          : 'Saved beneficiary · Verified',
                    ),
                    trailing: const Text(
                      '✓ Verified',
                      style: TextStyle(color: positive, fontSize: 12),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Saved beneficiary · No transfer fee',
                        style: TextStyle(color: muted, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 17),
            const FieldLabel('From account'),
            DropdownButtonFormField<String>(
              initialValue: 'Everyday Checking ·· 4821',
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_balance_wallet_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Everyday Checking ·· 4821',
                  child: Text('Everyday Checking ·· 4821'),
                ),
              ],
              onChanged: (_) {},
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Available balance: LKR 8,240.50',
                style: TextStyle(color: muted, fontSize: 13),
              ),
            ),
            const SizedBox(height: 17),
            const FieldLabel('Amount (LKR)'),
            TextField(
              key: const Key('transfer-amount'),
              controller: _amount,
              onChanged: (_) => setState(() {}),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: 'LKR  ',
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 17),
            const FieldLabel('Reference / note (optional)'),
            TextField(
              controller: _note,
              decoration: const InputDecoration(hintText: 'Dinner share'),
            ),
          ],
          if (_step == 1) ...[
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeading('When to send'),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('Send now')),
                        ButtonSegment(value: true, label: Text('Schedule')),
                      ],
                      selected: {_scheduled},
                      onSelectionChanged: (selection) =>
                          setState(() => _scheduled = selection.first),
                    ),
                    if (_scheduled) ...[
                      const SizedBox(height: 10),
                      const FieldLabel('First payment date'),
                      OutlinedButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text(
                          '${_date.day} ${_month(_date.month)} ${_date.year}',
                        ),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Recurring transfer'),
                        subtitle: const Text(
                          'Repeat automatically on your schedule',
                        ),
                        value: _recurring,
                        onChanged: (value) =>
                            setState(() => _recurring = value),
                      ),
                      if (_recurring) ...[
                        DropdownButtonFormField<String>(
                          initialValue: 'Monthly',
                          decoration: const InputDecoration(
                            labelText: 'Frequency',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Weekly',
                              child: Text('Weekly'),
                            ),
                            DropdownMenuItem(
                              value: 'Monthly',
                              child: Text('Monthly'),
                            ),
                          ],
                          onChanged: (_) {},
                        ),
                        const SizedBox(height: 8),
                        const FieldLabel('End date'),
                        OutlinedButton.icon(
                          onPressed: _pickEndDate,
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: Text(
                            '${_endDate.day} ${_month(_endDate.month)} ${_endDate.year} · 4 payments total',
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 13),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeading('Transfer summary'),
                    DetailRow(
                      label: _recurring ? 'Each payment' : 'Amount',
                      value: money(double.tryParse(_amount.text) ?? 0),
                    ),
                    const SizedBox(height: 12),
                    DetailRow(
                      label: 'Fee / Total',
                      value:
                          'LKR 0.00 / ${money(double.tryParse(_amount.text) ?? 0)}',
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _scheduled
                          ? 'First delivery: ${_date.day} ${_month(_date.month)} · Usually arrives instantly.'
                          : 'Daily limit LKR 10,000 · Remaining LKR 9,850',
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 18),
          PrimaryButton(
            label: _step == 0
                ? 'Continue to schedule'
                : _scheduled
                ? 'Review scheduled transfer'
                : 'Review transfer',
            icon: _step == 0 ? Icons.arrow_forward : null,
            onPressed: _step == 0 ? _continueToSchedule : _review,
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'This demo will not move real money.',
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _continueToSchedule() {
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      _message(context, 'Enter an amount greater than zero.');
      return;
    }
    setState(() {
      _step = 1;
      _scheduled = true;
      _recurring = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2026, 10, 6),
      lastDate: DateTime(2028, 10, 6),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _date,
      lastDate: DateTime(2028, 10, 6),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  Future<void> _chooseRecipient() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final recipient in _recipients)
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: mint,
                  child: Icon(Icons.person_outline, color: teal),
                ),
                title: Text(recipient),
                onTap: () => Navigator.pop(context, recipient),
              ),
          ],
        ),
      ),
    );
    if (selected != null) setState(() => _recipient = selected);
  }

  Future<void> _review() async {
    final value = double.tryParse(_amount.text.trim());
    if (value == null || value <= 0) {
      _message(context, 'Enter an amount greater than zero.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review transfer'),
        content: Text(
          '${_scheduled ? 'Schedule' : 'Send'} ${money(value)} to $_recipient?\n\nFee: LKR 0.00${_note.text.trim().isEmpty ? '' : '\nNote: ${_note.text.trim()}'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed == true) widget.onPayment(value, _recipient, _scheduled);
  }
}

class BillPaymentScreen extends StatelessWidget {
  const BillPaymentScreen({required this.onPayment, super.key});

  final void Function(double amount, String recipient, bool scheduled)
  onPayment;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const ScreenHeading(
          title: 'Your billers',
          subtitle: 'Choose a saved bill or set up a new one.',
        ),
        const SizedBox(height: 15),
        _bill(context, Icons.bolt, 'City Electric', 'LKR 74.60 · Due 10 Oct'),
        _bill(context, Icons.wifi, 'Home Internet', 'LKR 59.00 · Due 12 Oct'),
        _bill(
          context,
          Icons.phone_android,
          'Mobile top-up',
          'Choose an amount',
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _message(
            context,
            'Biller setup is available in the full banking service.',
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add a biller'),
        ),
      ],
    ),
  );

  Widget _bill(
    BuildContext context,
    IconData icon,
    String title,
    String detail,
  ) => Card(
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: mint,
        child: Icon(icon, color: teal),
      ),
      title: Text(title),
      subtitle: Text(detail),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => TransferScreen(
            onPayment: onPayment,
            initialRecipient: 'City Electric',
          ),
        ),
      ),
    ),
  );
}

class QrPaymentScreen extends StatefulWidget {
  const QrPaymentScreen({required this.onPayment, super.key});

  final void Function(double amount, String recipient, bool scheduled)
  onPayment;

  @override
  State<QrPaymentScreen> createState() => _QrPaymentScreenState();
}

class _QrPaymentScreenState extends State<QrPaymentScreen> {
  bool _flash = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Scan QR code',
          subtitle: 'Scan a code, then confirm the payment',
        ),
        const SizedBox(height: 16),
        Container(
          height: 164,
          decoration: BoxDecoration(
            color: ink,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'QR scan area · Demo preview',
                style: TextStyle(color: Color(0xFFD8CCCB), fontSize: 11),
              ),
              const SizedBox(height: 12),
              Container(
                width: 150,
                height: 90,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEAC9C7), width: 2),
                ),
                child: const _QrPattern(),
              ),
              const SizedBox(height: 10),
              const Text(
                'Align the code inside the frame',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _flash = !_flash),
                icon: Icon(_flash ? Icons.flash_on : Icons.flash_off),
                label: Text(_flash ? 'Flash on' : 'Flash off'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _message(
                  context,
                  'QR image upload is not enabled in this demo.',
                ),
                icon: const Icon(Icons.image_outlined),
                label: const Text('Upload QR image'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Payment review', action: 'Code detected'),
                const _AccountRow(
                  icon: Icons.storefront_outlined,
                  name: 'Corner Coffee',
                  detail: 'Verified merchant · Account ·· 7710',
                  amount: '›',
                ),
                const DetailRow(
                  label: 'Merchant reference',
                  value: 'CC-1026-084',
                ),
                const SizedBox(height: 9),
                const Text(
                  'Check the recipient before authorizing payment.',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Continue to payment review',
          icon: Icons.arrow_forward,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => QrReviewScreen(onPayment: widget.onPayment),
            ),
          ),
        ),
      ],
    ),
  );
}

class _QrPattern extends StatelessWidget {
  const _QrPattern();

  @override
  Widget build(BuildContext context) {
    const pattern = [
      '11111001011111',
      '10001011010001',
      '10101001010101',
      '10001011010001',
      '11111010111111',
      '00000101100000',
      '11011010110110',
      '01001101001001',
      '10110111101100',
      '00101000110110',
      '11111001101001',
      '10001010011100',
      '10101001100111',
      '10001011011010',
      '11111000101101',
    ];
    return Column(
      children: [
        for (final row in pattern)
          Expanded(
            child: Row(
              children: [
                for (final cell in row.split(''))
                  Expanded(
                    child: Container(
                      color: cell == '1' ? ink : Colors.white,
                      margin: const EdgeInsets.all(1),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class QrReviewScreen extends StatefulWidget {
  const QrReviewScreen({required this.onPayment, super.key});
  final void Function(double amount, String recipient, bool scheduled)
  onPayment;

  @override
  State<QrReviewScreen> createState() => _QrReviewScreenState();
}

class _QrReviewScreenState extends State<QrReviewScreen> {
  final _amount = TextEditingController(text: '18.50');
  final _note = TextEditingController(text: 'Coffee & breakfast');

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Review QR payment',
          subtitle: 'Check the details before authorizing your payment',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SectionHeading('Payment review', action: 'Code detected'),
                _AccountRow(
                  icon: Icons.storefront_outlined,
                  name: 'Corner Coffee',
                  detail: 'Verified merchant · Account ·· 7710',
                  amount: '›',
                ),
                DetailRow(label: 'Merchant reference', value: 'CC-1026-084'),
                SizedBox(height: 8),
                Text(
                  'Check the recipient before authorizing payment.',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const FieldLabel('Amount (LKR)'),
        TextField(
          key: const Key('qr-payment-amount'),
          controller: _amount,
          onChanged: (_) => setState(() {}),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(prefixText: 'LKR  '),
        ),
        const SizedBox(height: 12),
        const FieldLabel('Pay from'),
        const TextField(
          readOnly: true,
          controller: null,
          decoration: InputDecoration(hintText: 'Everyday Checking ·· 4821'),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 7),
          child: Text(
            'Available balance: LKR 8,240.50',
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ),
        const SizedBox(height: 12),
        const FieldLabel('Note (optional)'),
        TextField(
          controller: _note,
          decoration: const InputDecoration(hintText: 'Add a note'),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SectionHeading('Total to pay'),
                DetailRow(
                  label: 'Payment amount',
                  value: money(double.tryParse(_amount.text) ?? 0),
                ),
                const SizedBox(height: 10),
                DetailRow(
                  label: 'Fee / Total',
                  value:
                      'LKR 0.00 / ${money(double.tryParse(_amount.text) ?? 0)}',
                ),
                const SizedBox(height: 10),
                const Text(
                  'Authorize with Face ID, fingerprint or your PIN.',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Confirm & pay ${money(double.tryParse(_amount.text) ?? 0)}',
          icon: Icons.lock_outline,
          onPressed: () {
            final amount = double.tryParse(_amount.text);
            if (amount == null || amount <= 0) {
              _message(context, 'Enter an amount greater than zero.');
              return;
            }
            widget.onPayment(amount, 'Corner Coffee', false);
          },
        ),
      ],
    ),
  );
}

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({
    required this.amount,
    required this.recipient,
    required this.scheduled,
    required this.balance,
    super.key,
  });

  final double amount;
  final String recipient;
  final bool scheduled;
  final double balance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
        children: [
          ScreenHeading(
            title: scheduled ? 'Transfer scheduled' : 'Payment successful',
            subtitle: scheduled
                ? 'Transfer · Scheduled'
                : 'QR payment · Completed',
          ),
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 34,
            backgroundColor: Color(0xFFEAF3EF),
            child: Icon(Icons.check_rounded, size: 35, color: positive),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              scheduled ? 'Transfer scheduled' : 'Payment successful',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              scheduled
                  ? 'We have your transfer queued.'
                  : 'Your payment has been recorded.',
              style: const TextStyle(color: muted),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              money(amount),
              style: const TextStyle(
                fontSize: 35,
                color: teal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Center(
            child: Text(
              'Paid to $recipient',
              style: const TextStyle(color: muted),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Back to dashboard',
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Make another payment'),
          ),
        ],
      ),
    );
  }
}

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({
    this.amount = 18.50,
    this.recipient = 'Corner Coffee',
    super.key,
  });

  final double amount;
  final String recipient;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Payment receipt',
          subtitle: 'Save, share, or continue with another payment',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SectionHeading('Transaction receipt'),
                const DetailRow(label: 'Status', value: 'Completed'),
                const DetailRow(
                  label: 'Date & time',
                  value: '6 Oct 2026, 9:41 AM',
                ),
                DetailRow(
                  label: 'Recipient account',
                  value: '$recipient ·· 7710',
                ),
                const DetailRow(label: 'Paid from', value: 'Checking ·· 4821'),
                const DetailRow(
                  label: 'Transaction ID',
                  value: 'NB-261006-0841',
                ),
                const DetailRow(label: 'Method', value: 'QR payment'),
                DetailRow(
                  label: 'Amount / Fee',
                  value: '${money(amount)} / LKR 0.00',
                ),
                const DetailRow(label: 'Note', value: 'Coffee & breakfast'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _message(
                  context,
                  'Receipt download is simulated in this demo.',
                ),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Download receipt'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _message(
                  context,
                  'Receipt sharing is simulated in this demo.',
                ),
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share receipt'),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: Text(
            'Need help with this payment? Contact support with your transaction ID.',
            style: TextStyle(color: muted, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}

class BeneficiariesScreen extends StatefulWidget {
  const BeneficiariesScreen({super.key});

  @override
  State<BeneficiariesScreen> createState() => _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends State<BeneficiariesScreen> {
  final List<String> _names = ['Jamie Lee', 'Steve Rogers', 'Corner Coffee'];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const ScreenHeading(
          title: 'Saved recipients',
          subtitle: 'Your saved payees are ready for a transfer.',
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < _names.length; index++)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: mint,
                foregroundColor: teal,
                child: Text(_initials(_names[index])),
              ),
              title: Text(_names[index]),
              subtitle: Text(
                'North Bank ·· ${['6672', '1198', '7710'][index % 3]}',
              ),
              trailing: IconButton(
                tooltip: 'Remove ${_names[index]}',
                onPressed: () => setState(() => _names.removeAt(index)),
                icon: const Icon(Icons.close),
              ),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _add,
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Add beneficiary'),
        ),
        const SizedBox(height: 12),
        const InfoBanner(
          icon: Icons.verified_user_outlined,
          text: 'A new recipient may need verification before the first transfer.',
        ),
      ],
    ),
  );

  Future<void> _add() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add beneficiary'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Recipient name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.isNotEmpty) setState(() => _names.add(name));
  }
}

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({this.transactions = const [], super.key});
  final List<BankTransaction> transactions;

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _filter = 'All';
  String _category = 'All categories';
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = widget.transactions.isEmpty
        ? const [
            BankTransaction('Corner Coffee', '6 Oct · Food & drink', -18.50),
            BankTransaction('Fresh Market', '5 Oct · Groceries', -86.20),
            BankTransaction('Metro Transit', '4 Oct · Transport', -24),
            BankTransaction('Salary · Acme Co.', '3 Oct · Income', 4250),
            BankTransaction('City Water', '2 Oct · Utilities', -42),
            BankTransaction('Tony Stark', '1 Oct · Transfer', -150),
          ]
        : widget.transactions;
    final visible = transactions.where((item) {
      final matchesQuery = '${item.name} ${item.detail}'.toLowerCase().contains(
        _query.text.toLowerCase(),
      );
      final matchesFilter =
          _filter == 'All' ||
          (_filter == 'Income' ? item.amount > 0 : item.amount < 0);
      final detail = item.detail.toLowerCase();
      final matchesCategory = switch (_category) {
        'Food' => detail.contains('food'),
        'Groceries' => detail.contains('groceries'),
        'Bills' => detail.contains('bill') || detail.contains('utilit'),
        _ => true,
      };
      return matchesQuery && matchesFilter && matchesCategory;
    }).toList();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
        children: [
          const ScreenHeading(
            title: 'Transaction History',
            subtitle: 'Everyday Checking ·· 4821 · Updated just now',
          ),
          const SizedBox(height: 14),
          const SizedBox(height: 12),
          const FieldLabel('Search transactions'),
          TextField(
            controller: _query,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search merchant, amount or reference',
            ),
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      _message(context, 'Showing October 2026 activity.'),
                  child: const Text('October 2026 ⌄'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _message(
                    context,
                    'Use the filters below to narrow activity.',
                  ),
                  child: const Text('Filters (2) ⌄'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'All', label: Text('All')),
              ButtonSegment(value: 'Income', label: Text('Income')),
              ButtonSegment(value: 'Expenses', label: Text('Expenses')),
            ],
            selected: {_filter},
            onSelectionChanged: (selection) =>
                setState(() => _filter = selection.first),
          ),
          const SizedBox(height: 14),
          const SectionHeading('Categories'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in [
                  'All categories',
                  'Food',
                  'Groceries',
                  'Bills',
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _category == category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Column(
                children: [
                  const SectionHeading('October activity', action: 'Export'),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'In LKR 4,250.00 / Out LKR 2,340.00 this month',
                      style: TextStyle(color: muted, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...visible.map(
                    (transaction) => TransactionTile(
                      transaction: transaction,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => TransactionDetailsScreen(
                            transaction: transaction,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (visible.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(25),
                      child: Center(child: Text('No matching transactions.')),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _message(
              context,
              'More transactions are not available in this local demo.',
            ),
            child: const Text('Load more transactions'),
          ),
        ],
      ),
    );
  }
}

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({required this.transaction, super.key});

  final BankTransaction transaction;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Transaction details',
          subtitle: 'Everyday Checking ·· 4821 · Updated just now',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeading(
                  'Selected transaction',
                  action: 'Close ×',
                  onAction: () => Navigator.of(context).pop(),
                ),
                TransactionTile(transaction: transaction),
                const SizedBox(height: 6),
                const DetailRow(
                  label: 'Status / Method',
                  value: 'Completed / QR',
                ),
                const SizedBox(height: 12),
                const DetailRow(
                  label: 'Transaction ID',
                  value: 'NB-261006-0841',
                ),
                const SizedBox(height: 12),
                const DetailRow(label: 'Category', value: 'Food & drink ⌄'),
                const SizedBox(height: 12),
                const DetailRow(label: 'Note', value: 'Coffee & breakfast'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => PaymentReceiptScreen(
                              amount: transaction.amount.abs(),
                              recipient: transaction.name,
                            ),
                          ),
                        ),
                        child: const Text('View receipt'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _message(
                          context,
                          'Issue reporting is simulated in this demo.',
                        ),
                        child: const Text('Report an issue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedView = 0;
  final Map<String, bool> _preferences = {
    'Transactions': true,
    'Low balance': true,
    'Bill reminders': true,
    'Security alerts': true,
    'Offers & recommendations': false,
    'Push notifications': true,
    'Email · K•••@email.com': true,
    'SMS · •••• 4821': false,
  };

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        ScreenHeading(
          title: _selectedView == 2
              ? 'Notification preferences'
              : 'Notifications',
          subtitle: _selectedView == 2
              ? 'Choose what you want to see and how you want to receive updates.'
              : 'Real-time updates · 3 unread alerts',
        ),
        const SizedBox(height: 18),
        SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 0, label: Text('All alerts')),
            ButtonSegment(value: 1, label: Text('Unread (3)')),
            ButtonSegment(value: 2, label: Text('Preferences')),
          ],
          selected: {_selectedView},
          onSelectionChanged: (selection) =>
              setState(() => _selectedView = selection.first),
        ),
        if (_selectedView != 2) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SectionHeading('Today', action: 'Mark all read'),
                  _AlertRow(
                    icon: Icons.check_circle_outline,
                    title: 'Payment completed',
                    detail: 'LKR 18.50 to Corner Coffee · Just now',
                    action: '✓',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PaymentReceiptScreen(),
                      ),
                    ),
                  ),
                  const _AlertRow(
                    icon: Icons.shield_outlined,
                    title: 'New sign-in detected',
                    detail: 'iPhone 15 · Central City · 9:38 AM',
                    action: 'Review',
                  ),
                  const _AlertRow(
                    icon: Icons.bolt,
                    title: 'City Electric bill reminder',
                    detail: 'LKR 74.60 due on 10 Oct · 8:00 AM',
                    action: 'View',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SectionHeading('Earlier'),
                  _AlertRow(
                    icon: Icons.south_west,
                    title: 'Salary received',
                    detail: 'LKR 4,250.00 from Acme Co. · 3 Oct',
                  ),
                ],
              ),
            ),
          ),
        ],
        if (_selectedView != 1) ...[
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading('Alert preferences'),
                  ..._preferences.entries
                      .take(5)
                      .map(
                        (entry) => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          subtitle: Text(switch (entry.key) {
                            'Transactions' =>
                              'Payments, transfers and deposits',
                            'Low balance' =>
                              'Alert when Checking falls below LKR 500',
                            'Bill reminders' =>
                              'Notify me 3 days before a due date',
                            'Security alerts' =>
                              'Always on for your protection',
                            _ => 'Personalized offers and tips',
                          }, style: const TextStyle(fontSize: 11)),
                          value: entry.value,
                          onChanged: (value) =>
                              setState(() => _preferences[entry.key] = value),
                        ),
                      ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeading('Delivery channels'),
                  ..._preferences.entries
                      .skip(5)
                      .map(
                        (entry) => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          value: entry.value,
                          onChanged: (value) =>
                              setState(() => _preferences[entry.key] = value),
                        ),
                      ),
                  const Text(
                    'Quiet hours: 10 PM–7 AM · Security alerts still arrive.',
                    style: TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            label: 'Save preferences',
            onPressed: () => _message(
              context,
              'Notification preferences saved on this device.',
            ),
          ),
        ],
      ],
    ),
  );
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({
    required this.icon,
    required this.title,
    required this.detail,
    this.action,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: mint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: teal),
    ),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    ),
    subtitle: Text(detail, style: const TextStyle(fontSize: 11)),
    trailing: action == null
        ? null
        : Text(
            action!,
            style: const TextStyle(color: teal, fontWeight: FontWeight.w600),
          ),
    onTap: onTap,
  );
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _messageController = TextEditingController();
  final List<(bool, String)> _messages = [
    (
      false,
      'Hi Kavi. I can help with pending payments, accounts and everyday banking. What would you like to know?',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
          child: Row(
            children: [
              const Expanded(
                child: ScreenHeading(
                  title: 'AI banking assistant',
                  subtitle: 'North Assistant · Secure banking conversation',
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _messages
                    ..clear()
                    ..add((false, 'Hi Kavi. How can I help?'));
                }),
                child: const Text('New chat +'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeading('Chat with your assistant'),
                      for (final message in _messages)
                        Align(
                          alignment: message.$1
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(13),
                            constraints: const BoxConstraints(maxWidth: 310),
                            decoration: BoxDecoration(
                              color: message.$1
                                  ? teal
                                  : const Color(0xFFF2F2F4),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              message.$2,
                              style: TextStyle(
                                color: message.$1 ? Colors.white : ink,
                              ),
                            ),
                          ),
                        ),
                      OutlinedButton(
                        onPressed: () => _answer('Show my budget'),
                        child: const Text('View my budget'),
                      ),
                      const Text(
                        'AI responses may be imperfect. Confirm important details.',
                        style: TextStyle(color: muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const FieldLabel('Message your assistant'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onSubmitted: (_) => _send(),
                          decoration: const InputDecoration(
                            hintText: 'Type a question…',
                            border: InputBorder.none,
                            filled: false,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Send message',
                        onPressed: _send,
                        icon: const Icon(Icons.send_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Find a payment'),
                    onPressed: () => _answer(
                      'Your latest payment was at Corner Coffee for LKR 18.50. Open transaction history to review it.',
                    ),
                  ),
                  ActionChip(
                    label: const Text('Upcoming bills'),
                    onPressed: () => _answer(
                      'City Electric is due on 10 October. You can open Payments to pay it.',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  void _send() {
    final question = _messageController.text.trim();
    if (question.isEmpty) return;
    _messageController.clear();
    _answer(question);
  }

  void _answer(String question) {
    setState(() {
      _messages.add((true, question));
      final lower = question.toLowerCase();
      final answer = lower.contains('payment') || lower.contains('coffee')
          ? 'Your recent Corner Coffee payment was LKR 18.50. You can review it in transaction history.'
          : lower.contains('bill')
          ? 'Your City Electric bill is LKR 74.60, due on 10 October. Open Payments to continue.'
          : 'I can help with accounts, payments and bills. For account-specific support, contact the Fintrust Digital App support team.';
      _messages.add((false, answer));
    });
  }
}

class SupportHelpScreen extends StatelessWidget {
  const SupportHelpScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Support & help',
          subtitle: 'Talk to a person, secure messaging and quick answers',
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeading('Talk to a person'),
                _AlertRow(
                  icon: Icons.headset_mic_outlined,
                  title: 'Live support',
                  detail: 'Available 24/7 · Typical wait 2 min',
                  action: 'Start chat',
                ),
                _AlertRow(
                  icon: Icons.mail_outline,
                  title: 'Secure messaging',
                  detail: '2 messages · Reply within 1 business day',
                  action: 'Inbox ›',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeading('Frequently asked questions'),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Accounts & statements'),
                  trailing: Icon(Icons.chevron_right, color: teal),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Payments & transfers'),
                  trailing: Icon(Icons.chevron_right, color: teal),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Cards & lost card help'),
                  trailing: Icon(Icons.chevron_right, color: teal),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Security & login'),
                  trailing: Icon(Icons.chevron_right, color: teal),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const InfoBanner(
          icon: Icons.shield_outlined,
          text: 'Never share your PIN, password or one-time code in chat.',
        ),
      ],
    ),
  );
}

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _multiFactor = true;
  bool _faceId = true;
  bool _deviceTrust = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Account security',
          subtitle: 'Protect your account and control your data',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SectionHeading(
                  'Account protection',
                  action: 'Privacy ›',
                  onAction: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PrivacyPreferencesScreen(),
                    ),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Multi-factor authentication'),
                  subtitle: const Text('Authenticator app + backup SMS'),
                  value: _multiFactor,
                  onChanged: (value) => setState(() => _multiFactor = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Face recognition'),
                  subtitle: const Text('Enabled on this device'),
                  value: _faceId,
                  onChanged: (value) => setState(() => _faceId = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Fingerprint sign-in'),
                  subtitle: const Text('Enable on a supported device'),
                  value: _deviceTrust,
                  onChanged: (value) => setState(() => _deviceTrust = value),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _message(
                          context,
                          'Password update is available in the secure banking service.',
                        ),
                        child: const Text('Change password'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _message(
                          context,
                          'Manage MFA in the secure banking service.',
                        ),
                        child: const Text('Manage MFA'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: Column(
              children: [
                const SectionHeading('Trusted devices', action: 'Manage'),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: mint,
                    child: Icon(Icons.phone_iphone, color: teal),
                  ),
                  title: Text('iPhone 15'),
                  subtitle: Text('This device · Last active just now'),
                  trailing: Text('Trusted', style: TextStyle(color: positive)),
                ),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: mint,
                    child: Icon(Icons.laptop_mac, color: teal),
                  ),
                  title: Text('MacBook Air'),
                  subtitle: Text('Last active 5 Oct · Central City'),
                  trailing: Text('Remove', style: TextStyle(color: teal)),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SectionHeading('Login history', action: 'View all'),
                const _AlertRow(
                  icon: Icons.phone_iphone,
                  title: '6 Oct, 9:38 AM',
                  detail: 'iPhone 15 · Central City',
                  action: 'Successful',
                ),
                const _AlertRow(
                  icon: Icons.laptop_mac,
                  title: '5 Oct, 7:12 PM',
                  detail: 'Safari / MacBook · Central City',
                  action: 'Successful',
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class PrivacyPreferencesScreen extends StatefulWidget {
  const PrivacyPreferencesScreen({super.key});

  @override
  State<PrivacyPreferencesScreen> createState() =>
      _PrivacyPreferencesScreenState();
}

class _PrivacyPreferencesScreenState extends State<PrivacyPreferencesScreen> {
  bool _recommendations = true;
  bool _shareAnalytics = false;
  bool _suspiciousActivity = true;
  String _theme = 'Light';

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 22),
      children: [
        const ScreenHeading(
          title: 'Privacy & preferences',
          subtitle: 'Protect your account and control your data',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Privacy controls'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Personalized recommendations'),
                  subtitle: const Text('Use my activity to tailor insights'),
                  value: _recommendations,
                  onChanged: (value) =>
                      setState(() => _recommendations = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Share optional analytics'),
                  subtitle: const Text('Help improve the banking experience'),
                  value: _shareAnalytics,
                  onChanged: (value) => setState(() => _shareAnalytics = value),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data & permissions'),
                  trailing: TextButton(
                    onPressed: () => _message(
                      context,
                      'Data permissions are managed in the secure banking service.',
                    ),
                    child: const Text('Manage ›'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Security monitoring'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Suspicious activity alerts'),
                  subtitle: const Text('Always on · No unusual activity found'),
                  value: _suspiciousActivity,
                  onChanged: (value) =>
                      setState(() => _suspiciousActivity = value),
                ),
                OutlinedButton.icon(
                  onPressed: () => _message(
                    context,
                    'Your report has been recorded in this demo.',
                  ),
                  icon: const Icon(Icons.shield_outlined),
                  label: const Text('Report suspicious activity'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading('Theme settings'),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'Light', label: Text('Light')),
                    ButtonSegment(value: 'Dark', label: Text('Dark')),
                    ButtonSegment(value: 'System', label: Text('System')),
                  ],
                  selected: {_theme},
                  onSelectionChanged: (selection) =>
                      setState(() => _theme = selection.first),
                ),
                const SizedBox(height: 10),
                Text(
                  '$_theme mode selected · Applies across your devices.',
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => _message(
            context,
            'You have been signed out of other demo devices.',
          ),
          child: const Text('Sign out of all other devices'),
        ),
      ],
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {this.action, this.onAction, super.key});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19),
        ),
      ),
      if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
    ],
  );
}

class ScreenHeading extends StatelessWidget {
  const ScreenHeading({required this.title, required this.subtitle, super.key});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 6),
      Text(subtitle, style: const TextStyle(color: muted)),
    ],
  );
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const BrandMark(),
      const SizedBox(width: 12),
      const Expanded(
        child: Text(
          'Fintrust Digital App',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: teal,
            fontSize: 16,
          ),
        ),
      ),
    ],
  );
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: teal,
      borderRadius: BorderRadius.circular(9),
    ),
    child: const Icon(
      Icons.account_balance_outlined,
      color: Colors.white,
      size: 20,
    ),
  );
}

class QuickAction extends StatelessWidget {
  const QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: line),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        child: Column(
          children: [
            Icon(icon, color: teal, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    ),
  );
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({required this.transaction, this.onTap, super.key});
  final BankTransaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
    leading: CircleAvatar(
      backgroundColor: mint,
      child: Icon(_transactionIcon(transaction.name), color: teal),
    ),
    title: Text(
      transaction.name,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
    subtitle: Text(transaction.detail),
    trailing: Text(
      '${transaction.amount < 0 ? '−' : '+'}${money(transaction.amount)}',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: transaction.amount < 0 ? teal : positive,
      ),
    ),
    onTap: onTap,
  );
}

IconData _transactionIcon(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('coffee')) return Icons.coffee_outlined;
  if (lower.contains('market')) return Icons.shopping_basket_outlined;
  if (lower.contains('salary')) return Icons.trending_up;
  if (lower.contains('electric')) return Icons.bolt;
  return Icons.swap_horiz;
}

class DetailRow extends StatelessWidget {
  const DetailRow({required this.label, required this.value, super.key});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(label, style: const TextStyle(color: muted)),
      ),
      Flexible(
        child: Text(
          value,
          textAlign: TextAlign.end,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, color: teal),
    ),
  );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    ),
  );
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({required this.icon, required this.text, super.key});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: mint,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: teal, size: 21),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: ink, fontSize: 13, height: 1.4),
          ),
        ),
      ],
    ),
  );
}

void _message(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );
}

String _month(int month) => const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][month - 1];

String _initials(String name) => name
    .trim()
    .split(RegExp(r'\s+'))
    .take(2)
    .map((part) => part.isEmpty ? '' : part[0])
    .join()
    .toUpperCase();
