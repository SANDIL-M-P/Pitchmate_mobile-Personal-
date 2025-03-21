import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/loging/forgot_password_screen.dart';
import 'package:flutter_application_1/screens/loging/loging_controller.dart';
import 'package:flutter_application_1/screens/main_nav/main_nav.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color primaryYellow = Color(0xFFF5A623);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color lightBackground = Color(0xFFF5F5F5);

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _logingController = LogingController();

  bool _isLoading = false;
  bool _obscureText = true;
  bool _showPasswordPeek = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final isSuccess = await _logingController.signIn(
        _usernameController.text,
        _passwordController.text,
      );
      setState(() => _isLoading = false);

      if (isSuccess) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainNav()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inputFillColor = isDarkMode ? darkBackground : Colors.white;

    return Scaffold(
      backgroundColor: isDarkMode ? darkBackground : lightBackground,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoading
                ? _buildLoadingIndicator()
                : _buildLoginForm(isDarkMode, inputFillColor),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(primaryYellow),
          strokeWidth: 3,
        ),
        const SizedBox(height: 16),
        Text(
          'Authenticating...',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(bool isDarkMode, Color inputFillColor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: isDarkMode ? Colors.white12 : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLogo(),
              const SizedBox(height: 24),
              _buildWelcomeText(),
              const SizedBox(height: 24),
              _buildUsernameField(inputFillColor),
              const SizedBox(height: 16),
              _buildPasswordField(inputFillColor),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 16),
              _buildForgotPasswordLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: primaryYellow.withOpacity(0.15),
        image: const DecorationImage(
          image: AssetImage('lib/images/pitchmate-logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: primaryYellow,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sign in to access your account',
          style: TextStyle(
            fontSize: 16,
            color:
                Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField(Color fillColor) {
    return TextFormField(
      controller: _usernameController,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryYellow, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Username is required' : null,
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildPasswordField(Color fillColor) {
    return StatefulBuilder(
      builder: (context, setState) => TextFormField(
        controller: _passwordController,
        style: const TextStyle(fontSize: 16),
        obscureText: !_showPasswordPeek && _obscureText,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            color:
                Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
          ),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryYellow, width: 2),
          ),
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _showPasswordPeek = !_showPasswordPeek),
            onLongPress: () => setState(() => _obscureText = false),
            onLongPressEnd: (_) => setState(() => _obscureText = true),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                _showPasswordPeek || !_obscureText
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.6),
                size: 20,
              ),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Password is required' : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: primaryYellow,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
