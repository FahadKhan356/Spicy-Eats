import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Favorites/Screens/FavoriteScrren.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Profile/screen/ProfileScreen.dart';
import 'package:spicy_eats/features/account/commons/RowContainer.dart';
import 'package:spicy_eats/features/authentication/controller/AuthenicationController.dart';
import 'package:spicy_eats/features/orders/screens/order_screen.dart';
import 'package:spicy_eats/main.dart';

// class AccountScreen extends ConsumerStatefulWidget {
//   static const String routename = '/Account-screen';
//   const AccountScreen({super.key});

//   @override
//   ConsumerState<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends ConsumerState<AccountScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final authController = ref.watch(authenticationControllerProvider);
//     final identities =supabaseClient.auth.currentUser!.identities!;
//     final user = ref.watch(userProvider);
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               'Account',
//               style: TextStyle(fontSize: 20, color: Colors.black),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Center(
//                 child: InkWell(
//                   onTap: () =>
//                       Navigator.pushNamed(context, ProfileScreen.routename),
//                   child: Container(
//                     child: Column(
//                       // crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '${user!.firstname}${user.lastname}',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 22),
//                         ),
//                         const Text(
//                           'view profile',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   rowContainer(
//                       icon: Icons.menu_book,
//                       onpressed: () =>
//                           Navigator.pushNamed(context, OrdersScreen.routename),
//                       title: 'Orders'),
//                   rowContainer(
//                       icon: Icons.favorite_border,
//                       onpressed: () => Navigator.pushNamed(
//                           context, Favoritescrren.routename),
//                       title: 'Favourites'),
//                   rowContainer(
//                       icon: Icons.location_on_outlined,
//                       onpressed: () {},
//                       title: 'Addresses'),
//                 ],
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                 child: SizedBox(
//                   width: double.maxFinite,
//                   height: 50,
//                   child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10))),
//                       onPressed: () {
//                         authController.logout(context, ref);
//                       },
//                       child: const Text(
//                         'Log out',
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       )),
//                 ),
//               ),
            
//             //const Spacer(),
//             identities.isNotEmpty?
//             Column(children: identities.map((e)=>Text('${e.provider} ${supabaseClient.auth.currentUser!.email}')).toList(),):const SizedBox()
            
            
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//////////////////////////

class AccountScreen extends ConsumerStatefulWidget {
  static const String routename = '/Account-screen';
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authenticationControllerProvider);
    final identities = supabaseClient.auth.currentUser!.identities!;
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange[600]!, Colors.orange[400]!],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Profile Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: Text(
                            '${user!.firstname?.substring(0, 1).toUpperCase() ?? 'U'}${user.lastname?.substring(0, 1).toUpperCase() ?? ''}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[600],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // User Name
                      Text(
                        '${user.firstname ?? ''} ${user.lastname ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // View Profile Button
                      TextButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, ProfileScreen.routename),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                        label: const Text(
                          'View Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Quick Actions Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              context: context,
                              icon: Icons.receipt_long,
                              title: 'Orders',
                              subtitle: 'View history',
                              color: Colors.blue,
                              onTap: () => Navigator.pushNamed(
                                  context, OrdersScreen.routename),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              context: context,
                              icon: Icons.favorite,
                              title: 'Favorites',
                              subtitle: 'Saved items',
                              color: Colors.red,
                              onTap: () => Navigator.pushNamed(
                                  context, Favoritescreen.routename),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              context: context,
                              icon: Icons.location_on,
                              title: 'Addresses',
                              subtitle: 'Manage locations',
                              color: Colors.green,
                              onTap: () {
                                // Navigate to addresses
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildActionCard(
                              context: context,
                              icon: Icons.payment,
                              title: 'Payments',
                              subtitle: 'Cards & wallets',
                              color: Colors.purple,
                              onTap: () {
                                // Navigate to payments
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Settings & Preferences Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings & Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildSettingsTile(
                              icon: Icons.notifications_outlined,
                              title: 'Notifications',
                              subtitle: 'Manage your alerts',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildSettingsTile(
                              icon: Icons.language,
                              title: 'Language',
                              subtitle: 'English',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildSettingsTile(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              subtitle: 'Get assistance',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildSettingsTile(
                              icon: Icons.info_outline,
                              title: 'About',
                              subtitle: 'App version & info',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Connected Accounts Section
                if (identities.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connected Accounts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: identities.map((identity) {
                              return _buildConnectedAccount(identity);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),

                // Logout Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context, authController);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.grey[700], size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[900],
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildConnectedAccount(dynamic identity) {
    IconData providerIcon;
    Color providerColor;

    switch (identity.provider.toLowerCase()) {
      case 'google':
        providerIcon = Icons.g_mobiledata;
        providerColor = Colors.red;
        break;
      case 'facebook':
        providerIcon = Icons.facebook;
        providerColor = Colors.blue;
        break;
      case 'apple':
        providerIcon = Icons.apple;
        providerColor = Colors.black;
        break;
      default:
        providerIcon = Icons.person;
        providerColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: providerColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(providerIcon, color: providerColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  identity.provider.toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  supabaseClient.auth.currentUser!.email ?? 'Connected',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green[600], size: 14),
                const SizedBox(width: 4),
                Text(
                  'Connected',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: Colors.grey[200], height: 1),
    );
  }

  void _showLogoutDialog(
      BuildContext context, dynamic authController) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red[600]),
            const SizedBox(width: 12),
            const Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              authController.logout(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}