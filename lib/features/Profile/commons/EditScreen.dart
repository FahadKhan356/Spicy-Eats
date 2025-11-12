import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/Profile/repo/ProfileRepo.dart';
import 'package:spicy_eats/features/Profile/screen/ProfileScreen.dart';

// class EditScreen extends ConsumerStatefulWidget {
//   static const String routname = '/Edit-Screen';
//   final String editType;

//   const EditScreen({super.key, required this.editType});

//   @override
//   ConsumerState<EditScreen> createState() => _EditScreenState();
// }

// class _EditScreenState extends ConsumerState<EditScreen> {
//   bool isloader = false;
//   final firstnamecontroller = TextEditingController();

//   final lastnamecontroller = TextEditingController();
//   final emailcontroller = TextEditingController();
//   final contactnocontroller = TextEditingController();

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     firstnamecontroller.dispose();
//     lastnamecontroller.dispose();
//     emailcontroller.dispose();
//     contactnocontroller.dispose();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     firstnamecontroller.text = ref.read(userProvider)!.firstname!;
//     lastnamecontroller.text = ref.read(userProvider)!.lastname!;
//     emailcontroller.text = ref.read(userProvider)!.email!;
//     contactnocontroller.text = ref.read(userProvider)!.contactno.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(userProvider);
//     return Scaffold(
//       appBar: AppBar(
//         // leading: TextButton(
//         //   onPressed: () => Navigator.pop(context),
//         //   child: const Text(
//         //     'X',
//         //     style: TextStyle(fontSize: 15, color: Colors.black),
//         //   ),
//         // ),
//         centerTitle: true,
//         title: Text(
//           widget.editType,
//           style: const TextStyle(fontSize: 20, color: Colors.black),
//         ),
//       ),
//       body: isloader
//           ? const Center(
//               child: CircularProgressIndicator(
//               backgroundColor: Colors.black12,
//               color: Colors.black,
//             ))
//           : Column(
//               children: [
//                 widget.editType == 'Name'
//                     ? Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10),
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             TextFormField(
//                               controller: firstnamecontroller,
//                               decoration: InputDecoration(
//                                 suffixIcon: TextButton(
//                                   child: const Text('x'),
//                                   onPressed: () {
//                                     firstnamecontroller.text = '';
//                                   },
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide:
//                                         const BorderSide(color: Colors.black),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide:
//                                         const BorderSide(color: Colors.black),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 10),
//                                 label: const Text('First name'),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             TextFormField(
//                               controller: lastnamecontroller,
//                               decoration: InputDecoration(
//                                 suffixIcon: TextButton(
//                                   child: const Text('x'),
//                                   onPressed: () {
//                                     lastnamecontroller.text = '';
//                                   },
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide:
//                                         const BorderSide(color: Colors.black),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide:
//                                         const BorderSide(color: Colors.black),
//                                     borderRadius: BorderRadius.circular(10)),
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 10),
//                                 label: const Text('Last name'),
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : widget.editType == 'Email'
//                         ? TextFormField(
//                             controller: emailcontroller,
//                             decoration: InputDecoration(
//                               suffixIcon: TextButton(
//                                 child: const Text('x'),
//                                 onPressed: () {
//                                   emailcontroller.text = '';
//                                 },
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide:
//                                       const BorderSide(color: Colors.black),
//                                   borderRadius: BorderRadius.circular(10)),
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide:
//                                       const BorderSide(color: Colors.black),
//                                   borderRadius: BorderRadius.circular(10)),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 10),
//                               label: const Text('Email'),
//                             ),
//                           )
//                         : widget.editType == 'Contactnumber'
//                             ? TextFormField(
//                                 controller: contactnocontroller,
//                                 decoration: InputDecoration(
//                                   suffixIcon: TextButton(
//                                     child: const Text('x'),
//                                     onPressed: () {
//                                       contactnocontroller.text = '';
//                                     },
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide:
//                                           const BorderSide(color: Colors.black),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   enabledBorder: OutlineInputBorder(
//                                       borderSide:
//                                           const BorderSide(color: Colors.black),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   contentPadding: const EdgeInsets.symmetric(
//                                       vertical: 10, horizontal: 10),
//                                   label: const Text('Mobile number'),
//                                 ),
//                               )
//                             : const SizedBox(),
//                 const Spacer(),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                   child: SizedBox(
//                     width: double.maxFinite,
//                     height: 50,
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.black,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10))),
//                         onPressed: () {
//                           if (firstnamecontroller.text.isNotEmpty &&
//                               lastnamecontroller.text.isNotEmpty) {
//                             setState(() {
//                               isloader = true;
//                             });
//                             ref.read(profileRepoProvider).updatePersonalDetails(
//                                   // firstnamecontroller.text != user!.firstname
//                                   //     ? firstnamecontroller.text
//                                   //     : null,
//                                   // lastnamecontroller.text != user.lastname
//                                   //     ? lastnamecontroller.text
//                                   //     : null,
//                                   // ref.read(userProvider)!.id!,
//                                   // emailcontroller.text != user.email
//                                   //     ? emailcontroller.text
//                                   //     : null,
//                                   // contactnocontroller.text !=
//                                   //         user.contactno.toString()
//                                   //     ? (contactnocontroller.text as num)
//                                   //         .toInt()
//                                   //     : null,
//                                   ref,
//                                   firstnamecontroller.text,
//                                   lastnamecontroller.text,
//                                   ref.read(userProvider)!.id!,
//                                   emailcontroller.text,
//                                   contactnocontroller.text,
//                                 );

//                             ref
//                                 .read(profileRepoProvider)
//                                 .fetchuser(ref.read(userProvider)!.id!, ref);

//                             Navigator.pushNamed(
//                                 context, ProfileScreen.routename);
//                             setState(() {
//                               isloader = false;
//                             });

//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(const SnackBar(
//                                     margin: EdgeInsets.symmetric(vertical: 100),
//                                     behavior: SnackBarBehavior.floating,
//                                     content: Text(
//                                       'Successfully updated',
//                                     )));
//                           }
//                         },
//                         child: const Text(
//                           'Save',
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.bold),
//                         )),
//                   ),
//                 )
//               ],
//             ),
//     );
//   }
// }
///////////////////////////////////////
///
class EditScreen extends ConsumerStatefulWidget {
  static const String routname = '/Edit-Screen';
  final String editType;

  const EditScreen({super.key, required this.editType});

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  bool isLoader = false;
  final _formKey = GlobalKey<FormState>();
  
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final contactnoController = TextEditingController();

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    contactnoController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    firstnameController.text = user?.firstname ?? '';
    lastnameController.text = user?.lastname ?? '';
    emailController.text = user?.email ?? '';
    contactnoController.text = user?.contactno?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: Text(
          _getPageTitle(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoader
          ? Center(
              child: CircularProgressIndicator(color: Colors.orange[600]),
            )
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Section
                          _buildHeaderSection(),
                          
                          const SizedBox(height: 32),

                          // Form Fields
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
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: _buildFormFields(),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Help Text
                          if (widget.editType == 'Email')
                            _buildInfoBox(
                              'Changing your email will require verification',
                              Icons.info_outline,
                              Colors.blue,
                            ),
                          
                          if (widget.editType == 'Contactnumber')
                            _buildInfoBox(
                              'Enter your mobile number with country code',
                              Icons.phone_outlined,
                              Colors.green,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Save Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
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
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderSection() {
    IconData headerIcon;
    String headerDescription;

    switch (widget.editType) {
      case 'Name':
        headerIcon = Icons.person_outline;
        headerDescription = 'Update your name as it appears on your profile';
        break;
      case 'Email':
        headerIcon = Icons.email_outlined;
        headerDescription = 'Change your email address for account access';
        break;
      case 'Contactnumber':
        headerIcon = Icons.phone_outlined;
        headerDescription = 'Update your contact number for notifications';
        break;
      default:
        headerIcon = Icons.edit;
        headerDescription = 'Update your information';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(headerIcon, color: Colors.orange[600], size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            headerDescription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    switch (widget.editType) {
      case 'Name':
        return Column(
          children: [
            _buildTextField(
              controller: firstnameController,
              label: 'First Name',
              hint: 'Enter your first name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'First name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: lastnameController,
              label: 'Last Name',
              hint: 'Enter your last name',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Last name is required';
                }
                return null;
              },
            ),
          ],
        );
      case 'Email':
        return _buildTextField(
          controller: emailController,
          label: 'Email Address',
          hint: 'your@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!value.contains('@')) {
              return 'Enter a valid email';
            }
            return null;
          },
        );
      case 'Contactnumber':
        return _buildTextField(
          controller: contactnoController,
          label: 'Mobile Number',
          hint: '+1 234 567 8900',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mobile number is required';
            }
            return null;
          },
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 16, color: Colors.grey[900]),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.orange[600]),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                onPressed: () {
                  setState(() {
                    controller.clear();
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
      onChanged: (value) {
        setState(() {}); // Rebuild to show/hide clear button
      },
    );
  }

  Widget _buildInfoBox(String message, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: color.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPageTitle() {
    switch (widget.editType) {
      case 'Name':
        return 'Edit Name';
      case 'Email':
        return 'Edit Email';
      case 'Contactnumber':
        return 'Edit Mobile Number';
      default:
        return 'Edit Profile';
    }
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoader = true;
    });

    try {
      await ref.read(profileRepoProvider).updatePersonalDetails(
            ref,
            firstnameController.text,
            lastnameController.text,
            ref.read(userProvider)!.id!,
            emailController.text,
            contactnoController.text,
          );

      await ref
          .read(profileRepoProvider)
          .fetchuser(ref.read(userProvider)!.id!, ref);

      if (mounted) {
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Profile updated successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoader = false;
        });
      }
    }
  }
}