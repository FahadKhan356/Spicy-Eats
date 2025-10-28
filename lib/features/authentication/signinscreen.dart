// import 'package:flutter/material.dart';
// import 'package:spicy_eats/features/authentication/signupscreeen.dart';

// class SignInScreen extends StatefulWidget {
//   static const routeName = '/signin';
//   const SignInScreen({Key? key}) : super(key: key);

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _isLoading = false;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Colors.orange[50]!,
//               Colors.white,
//               Colors.orange[50]!,
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Logo Section
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.orange.withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.restaurant_menu,
//                         size: 60,
//                         color: Colors.orange[600],
//                       ),
//                     ),
                    
//                     const SizedBox(height: 32),
                    
//                     // Welcome Text
//                     Text(
//                       'Welcome Back!',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[900],
//                       ),
//                     ),
                    
//                     const SizedBox(height: 8),
                    
//                     Text(
//                       'Sign in to continue',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[600],
//                       ),
//                     ),
                    
//                     const SizedBox(height: 40),
                    
//                     // Form Card
//                     Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.1),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             // Email Field
//                             TextFormField(
//                               controller: _emailController,
//                               keyboardType: TextInputType.emailAddress,
//                               decoration: InputDecoration(
//                                 labelText: 'Email',
//                                 hintText: 'your@email.com',
//                                 prefixIcon: Icon(Icons.email_outlined, color: Colors.orange[600]),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: BorderSide(color: Colors.grey[300]!),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: BorderSide(color: Colors.grey[300]!),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.grey[50],
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 }
//                                 if (!value.contains('@')) {
//                                   return 'Please enter a valid email';
//                                 }
//                                 return null;
//                               },
//                             ),
                            
//                             const SizedBox(height: 20),
                            
//                             // Password Field
//                             TextFormField(
//                               controller: _passwordController,
//                               obscureText: _obscurePassword,
//                               decoration: InputDecoration(
//                                 labelText: 'Password',
//                                 hintText: '••••••••',
//                                 prefixIcon: Icon(Icons.lock_outlined, color: Colors.orange[600]),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                     _obscurePassword ? Icons.visibility_off : Icons.visibility,
//                                     color: Colors.grey[600],
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       _obscurePassword = !_obscurePassword;
//                                     });
//                                   },
//                                 ),
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: BorderSide(color: Colors.grey[300]!),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: BorderSide(color: Colors.grey[300]!),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(16),
//                                   borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.grey[50],
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 }
//                                 if (value.length < 6) {
//                                   return 'Password must be at least 6 characters';
//                                 }
//                                 return null;
//                               },
//                             ),
                            
//                             const SizedBox(height: 12),
                            
//                             // Forgot Password
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton(
//                                 onPressed: () {
//                                   // Handle forgot password
//                                 },
//                                 child: Text(
//                                   'Forgot Password?',
//                                   style: TextStyle(
//                                     color: Colors.orange[600],
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
                            
//                             const SizedBox(height: 24),
                            
//                             // Sign In Button
//                             SizedBox(
//                               width: double.infinity,
//                               height: 56,
//                               child: ElevatedButton(
//                                 onPressed: _isLoading ? null : _handleSignIn,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.transparent,
//                                   shadowColor: Colors.transparent,
//                                   padding: EdgeInsets.zero,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                 ),
//                                 child: Ink(
//                                   decoration: BoxDecoration(
//                                     gradient: LinearGradient(
//                                       colors: [Colors.orange[600]!, Colors.orange[400]!],
//                                     ),
//                                     borderRadius: BorderRadius.circular(16),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.orange.withOpacity(0.4),
//                                         blurRadius: 12,
//                                         offset: const Offset(0, 6),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     child: _isLoading
//                                         ? const CircularProgressIndicator(color: Colors.white)
//                                         : const Text(
//                                             'Sign In',
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     const SizedBox(height: 24),
                    
//                     // Divider
//                     Row(
//                       children: [
//                         Expanded(child: Divider(color: Colors.grey[400])),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           child: Text(
//                             'OR',
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                         ),
//                         Expanded(child: Divider(color: Colors.grey[400])),
//                       ],
//                     ),
                    
//                     const SizedBox(height: 24),
                    
//                     // Social Login Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _socialButton(Icons.g_mobiledata, Colors.red),
//                         const SizedBox(width: 16),
//                         _socialButton(Icons.facebook, Colors.blue),
//                         const SizedBox(width: 16),
//                         _socialButton(Icons.apple, Colors.black),
//                       ],
//                     ),
                    
//                     const SizedBox(height: 32),
                    
//                     // Sign Up Link
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Don't have an account? ",
//                           style: TextStyle(color: Colors.grey[700]),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushNamed(context, SignUpScreen.routeName);
//                           },
//                           child: Text(
//                             'Sign Up',
//                             style: TextStyle(
//                               color: Colors.orange[600],
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _socialButton(IconData icon, Color color) {
//     return Container(
//       width: 56,
//       height: 56,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.grey[300]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: color, size: 28),
//         onPressed: () {
//           // Handle social login
//         },
//       ),
//     );
//   }

//   void _handleSignIn() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//       });
      
//       // Simulate API call
//       await Future.delayed(const Duration(seconds: 2));
      
//       setState(() {
//         _isLoading = false;
//       });
      
//       // Navigate to home or show error
//     }
//   }
// }
