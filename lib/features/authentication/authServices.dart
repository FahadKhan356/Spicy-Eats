// ==================== SETUP INSTRUCTIONS ====================
/*
1. Add to pubspec.yaml:
dependencies:
  supabase_flutter: ^2.0.0
  google_sign_in: ^6.1.5

2. Initialize Supabase in main.dart:
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);

3. Setup Google Cloud Console (console.cloud.google.com):
   A. Create OAuth 2.0 Client IDs for:
      * Web application → Get Web Client ID
      * Android → Get Android Client ID
      * iOS (with Bundle ID) → Get iOS Client ID

   B. For Android Client ID:
      - Get SHA-1 fingerprint (see step 5 below)
      - Package name: com.yourcompany.yourapp (from AndroidManifest.xml)

4. Setup Supabase Dashboard:
   - Go to Authentication → Providers → Google
   - Enable Google
   - Paste your Web Client ID
   - Paste your Web Client Secret
   - For iOS: Check "Skip nonce checks for iOS client"
   - Save

5. Get SHA-1 Fingerprint for Android:
   Open terminal in your project and run:
   
   For Debug:
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   For Release:
   keytool -list -v -keystore /path/to/your/release.keystore -alias your-alias-name
   
   Copy the SHA-1 and add to Google Console → Android OAuth Client

6. Android Setup:
   
   A. android/app/build.gradle:
      - Ensure minSdkVersion is at least 21
      
      android {
          defaultConfig {
              minSdkVersion 21
              // ... other configs
          }
      }
   
   B. android/app/src/main/AndroidManifest.xml:
      Add inside <application> tag:
      
      <meta-data
          android:name="com.google.android.gms.version"
          android:value="@integer/google_play_services_version" />

7. iOS Setup (ios/Runner/Info.plist):
   Add before </dict>:
   
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleTypeRole</key>
       <string>Editor</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   
   <key>GIDClientID</key>
   <string>YOUR_IOS_CLIENT_ID.apps.googleusercontent.com</string>
   
   Note: Reversed Client ID format: com.googleusercontent.apps.123456789

8. IMPORTANT - Client IDs Explained:
   - Web Client ID: Used for serverClientId parameter
   - Android Client ID: Auto-detected by package name + SHA-1
   - iOS Client ID: Used for clientId parameter
   - All three must be from the SAME Google Cloud project!
*/

// ==================== AUTH SERVICE ====================
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:spicy_eats/features/Home/screens/home_screen.dart';
import 'package:spicy_eats/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// ==================== FACEBOOK SETUP INSTRUCTIONS ====================
/*
1. Add to pubspec.yaml:
dependencies:
  supabase_flutter: ^2.0.0
  flutter_facebook_auth: ^6.0.0

2. Setup Facebook Developers (developers.facebook.com):
   
   A. Create a Facebook App:
      - Go to developers.facebook.com
      - Click "Create App" → Choose "Consumer" type
      - Enter App Name and Contact Email
      - Create App ID

   B. Add Facebook Login Product:
      - In left sidebar → Click "Add Product"
      - Find "Facebook Login" → Click "Set Up"
      - Choose "Native" or "Web" platform

   C. Configure OAuth Redirect URIs:
      - Settings → Basic → Get your App ID and App Secret
      - Facebook Login → Settings
      - Add Valid OAuth Redirect URIs:
        https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback
      - Save Changes

3. Setup Supabase Dashboard:
   - Go to Authentication → Providers → Facebook
   - Enable Facebook
   - Enter Facebook App ID
   - Enter Facebook App Secret
   - Save

4. ANDROID Setup (android/app/src/main/AndroidManifest.xml):
   Add inside <application> tag:

   <meta-data 
       android:name="com.facebook.sdk.ApplicationId" 
       android:value="@string/facebook_app_id"/>
   
   <meta-data 
       android:name="com.facebook.sdk.ClientToken" 
       android:value="@string/facebook_client_token"/>
   
   <activity 
       android:name="com.facebook.FacebookActivity"
       android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation"
       android:label="@string/app_name" />
   
   <activity
       android:name="com.facebook.CustomTabActivity"
       android:exported="true">
       <intent-filter>
           <action android:name="android.intent.action.VIEW" />
           <category android:name="android.intent.category.DEFAULT" />
           <category android:name="android.intent.category.BROWSABLE" />
           <data android:scheme="@string/fb_login_protocol_scheme" />
       </intent-filter>
   </activity>

   Create: android/app/src/main/res/values/strings.xml:
   
   <?xml version="1.0" encoding="utf-8"?>
   <resources>
       <string name="app_name">Your App Name</string>
       <string name="facebook_app_id">YOUR_FACEBOOK_APP_ID</string>
       <string name="facebook_client_token">YOUR_FACEBOOK_CLIENT_TOKEN</string>
       <string name="fb_login_protocol_scheme">fbYOUR_FACEBOOK_APP_ID</string>
   </resources>

5. iOS Setup (ios/Runner/Info.plist):
   Add before </dict>:

   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>fbYOUR_FACEBOOK_APP_ID</string>
       </array>
     </dict>
   </array>
   
   <key>FacebookAppID</key>
   <string>YOUR_FACEBOOK_APP_ID</string>
   
   <key>FacebookClientToken</key>
   <string>YOUR_FACEBOOK_CLIENT_TOKEN</string>
   
   <key>FacebookDisplayName</key>
   <string>Your App Name</string>
   
   <key>LSApplicationQueriesSchemes</key>
   <array>
     <string>fbapi</string>
     <string>fb-messenger-share-api</string>
   </array>

6. Get Facebook Client Token:
   - Go to Facebook App Dashboard
   - Settings → Advanced
   - Scroll to "Security" section
   - Copy Client Token

7. Testing:
   - Add test users in Facebook App Dashboard → Roles → Test Users
   - Or make app live: App Review → Request Advanced Access
*/

// ==================== ENHANCED AUTH SERVICE ====================
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Get current user
  User? get currentUser => _supabase.auth.currentUser;
  
  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;
  
  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // ==================== EMAIL SIGN UP ====================
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== EMAIL SIGN IN ====================
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ==================== GOOGLE SIGN IN ====================
  Future<AuthResponse?> signInWithGoogle() async {
    try {
      const webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';
      const iosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
        scopes: ['email', 'profile'],
      );

      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Failed to get Google credentials';
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response;
    } catch (e) {
      print('Error signing in with Google: $e');
      rethrow;
    }
  }

  // ==================== FACEBOOK SIGN IN (NATIVE) ====================
  Future<AuthResponse?> signInWithFacebook() async {
    try {
      // Trigger Facebook Login
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      // Check login status
      if (result.status == LoginStatus.success) {
        // Get access token
        final accessToken = result.accessToken;
        
        if (accessToken == null) {
          throw 'Failed to get Facebook access token';
        }

        // Sign in to Supabase with Facebook credentials
        final response = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.facebook,
          idToken: accessToken.token,
        );

        return response;
      } else if (result.status == LoginStatus.cancelled) {
        // User cancelled the login
        return null;
      } else {
        // Login failed
        throw 'Facebook login failed: ${result.message}';
      }
    } catch (e) {
      print('Error signing in with Facebook: $e');
      rethrow;
    }
  }

  // ==================== FACEBOOK SIGN IN (WEB REDIRECT) ====================
  // Alternative method - simpler but uses web redirect
  Future<bool> signInWithFacebookRedirect() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'io.supabase.flutterdemo://login-callback/',
      );
      return true;
    } catch (e) {
      print('Error with Facebook redirect: $e');
      return false;
    }
  }

  // ==================== GET FACEBOOK USER DATA ====================
  Future<Map<String, dynamic>?> getFacebookUserData() async {
    try {
      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200)",
      );
      return userData;
    } catch (e) {
      print('Error getting Facebook user data: $e');
      return null;
    }
  }

  // ==================== SIGN OUT ====================
  Future<void> signOut() async {
    try {
      // Sign out from Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      
      // Sign out from Facebook
      await FacebookAuth.instance.logOut();
      
      // Sign out from Supabase
      await _supabase.auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // ==================== PASSWORD RESET ====================
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== UPDATE USER ====================
  Future<UserResponse> updateUser({
    String? fullName,
    String? phone,
  }) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(
          data: {
            if (fullName != null) 'full_name': fullName,
            if (phone != null) 'phone': phone,
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// ==================== UPDATED SIGN IN SCREEN ====================
class SignInScreen extends StatefulWidget {
  static const routeName = '/signin';
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Email Sign In
  Future<void> _handleEmailSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, HomeScreen.routename);
        }
      }
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('An error occurred. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Google Sign In
  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final response = await _authService.signInWithGoogle();

      if (response?.user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('Google sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Facebook Sign In
  Future<void> _handleFacebookSignIn() async {
    setState(() => _isLoading = true);

    try {
      final response = await _authService.signInWithFacebook();

      if (response?.user != null) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on AuthException catch (e) {
      _showErrorSnackBar(e.message);
    } catch (e) {
      _showErrorSnackBar('Facebook sign in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.orange[50]!, Colors.white, Colors.orange[50]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(Icons.restaurant_menu, size: 60, color: Colors.orange[600]),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'Welcome Back!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey[900]),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text('Sign in to continue', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  
                  const SizedBox(height: 40),
                  
                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'your@email.com',
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.orange[600]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your email';
                              if (!value.contains('@')) return 'Please enter a valid email';
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: '••••••••',
                              prefixIcon: Icon(Icons.lock_outlined, color: Colors.orange[600]),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter your password';
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 12),
                          
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Show reset password dialog
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.orange[600], fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleEmailSignIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.orange[600]!, Colors.orange[400]!],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text(
                                          'Sign In',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR', style: TextStyle(color: Colors.grey[600])),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Social Login Buttons
                  Column(
                    children: [
                      // Google Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey[300]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: Image.network(
                            'https://www.google.com/favicon.ico',
                            height: 24,
                            width: 24,
                          ),
                          label: const Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Facebook Sign In Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _handleFacebookSignIn,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFF1877F2),
                            side: const BorderSide(color: Color(0xFF1877F2)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: 24,
                          ),
                          label: const Text(
                            'Continue with Facebook',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.grey[700])),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}