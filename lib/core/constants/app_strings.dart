/// Centralized string constants used across the entire app.
///
/// Avoids scattered string literals in widget trees. Each nested class
/// groups strings by feature / screen for easy discoverability.
class AppStrings {
  // ── Register screen ────────────────────────────────────────────────────────
  static const register = _Register();

  // ── Login screen ───────────────────────────────────────────────────────────
  static const login = _Login();

  // ── Shared / Common ────────────────────────────────────────────────────────
  static const common = _Common();
}

class _Register {
  const _Register();

  // Header
  String get title => 'Start Your Shop';
  String get subtitle =>
      'Create your account to manage your inventory\nefficiently.';

  // Sections
  String get personalInfoSection => 'Personal Information';
  String get shopDetailsSection => 'Shop Details';

  // Field labels
  String get fullNameLabel => 'Full Name';
  String get emailLabel => 'Email Address';
  String get phoneLabel => 'Phone Number';
  String get shopNameLabel => 'Shop Name';

  // Field hints
  String get fullNameHint => 'e.g. Nguyen Van A';
  String get emailHint => 'your@email.com';
  String get phoneHint => '+84 xxx xxx xxx';
  String get shopNameHint => 'e.g. My Awesome Store';

  // Button
  String get createButton => 'Create My Shop';

  // Footer
  String get footerPrefix => 'Already have a shop? ';
  String get footerLink => 'Login';
}

class _Login {
  const _Login();

  String get title => 'Welcome Back';
  String get subtitle => 'Sign in to your workspace';

  String get emailLabel => 'Email Address';
  String get emailHint => 'admin@storagepro.com';
  String get passwordLabel => 'Password';
  String get passwordHint => '••••••••';
  String get forgotPassword => 'Forgot Password?';

  String get submitButton => 'Login';

  String get footerPrefix => "Don't have a shop? ";
  String get footerLink => 'Create a new Shop';

  String get errorDefault => 'Authentication Failed';
  String get successMessage => 'Login Successful';
}

class _Common {
  const _Common();

  String get unknownError => 'An unexpected error occurred.';
}
