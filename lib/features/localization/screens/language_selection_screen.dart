import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spicy_eats/features/localization/app_localizations.dart';
import 'package:spicy_eats/features/localization/controller/locale_provider.dart';
import 'package:spicy_eats/features/localization/model/app_language.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  static const String routename = '/language_selection';

  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState
    extends ConsumerState<LanguageSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(appLocaleProvider);
    final isRtl = context.isRtl;

    final filteredLanguages = AppLanguage.supportedLanguages.where((lang) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return lang.name.toLowerCase().contains(q) ||
          lang.nativeName.toLowerCase().contains(q) ||
          lang.code.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios_new,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('select_language'),
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header info banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('choose_preferred_language'),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                // Search field
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: context.tr('search_language'),
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.orange, size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF4F6F8),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Languages list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredLanguages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final lang = filteredLanguages[index];
                final isSelected = lang.code == currentLocale.languageCode;

                return InkWell(
                  onTap: () async {
                    await ref.read(appLocaleProvider.notifier).setLocale(lang.code);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${lang.flag} ${lang.nativeName} (${lang.name}) selected',
                          ),
                          backgroundColor: Colors.black87,
                          duration: const Duration(milliseconds: 1400),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey.withValues(alpha: 0.15),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? Colors.orange.withValues(alpha: 0.12)
                              : Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Flag avatar
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.orange.withValues(alpha: 0.1)
                                : const Color(0xFFF5F6F8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            lang.flag,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Language Name & Native Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    lang.nativeName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      color: isSelected ? Colors.orange[800] : Colors.black87,
                                    ),
                                  ),
                                  if (lang.isRtl) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'RTL',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                lang.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Radio / check indicator
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.orange : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? Colors.orange : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
