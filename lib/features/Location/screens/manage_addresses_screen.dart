import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spicy_eats/features/Home/model/AddressModel.dart';
import 'package:spicy_eats/features/Location/Widgets/custommap.dart';
import 'package:spicy_eats/features/Location/controller/address_controller.dart';

class ManageAddressesScreen extends ConsumerStatefulWidget {
  static const String routename = '/manage-addresses';

  const ManageAddressesScreen({super.key});

  @override
  ConsumerState<ManageAddressesScreen> createState() =>
      _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends ConsumerState<ManageAddressesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(addressControllerProvider.notifier).load();
    });
  }

  void _showMessage(String text, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text)),
            ],
          ),
          backgroundColor: isError ? Colors.red[600] : Colors.green[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }

  void _openAddEditBottomSheet({AddressModel? addressToEdit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        addressToEdit: addressToEdit,
        onSaved: () {
          _showMessage(addressToEdit == null
              ? 'Address added successfully!'
              : 'Address updated successfully!');
        },
      ),
    );
  }

  void _confirmDelete(AddressModel address) {
    if (address.id == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline, color: Colors.red[700], size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Delete Address',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${address.label?.isNotEmpty == true ? address.label : 'this address'}" from your saved locations?',
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(addressControllerProvider.notifier)
                  .deleteAddress(address.id!);
              if (success) {
                _showMessage('Address deleted successfully');
              } else {
                _showMessage('Failed to delete address', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('home')) return Icons.home_rounded;
    if (lower.contains('work') || lower.contains('office')) return Icons.work_rounded;
    if (lower.contains('apartment') || lower.contains('flat')) return Icons.apartment_rounded;
    return Icons.location_on_rounded;
  }

  Color _getColorForLabel(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('home')) return Colors.orange[700]!;
    if (lower.contains('work') || lower.contains('office')) return Colors.blue[700]!;
    if (lower.contains('apartment') || lower.contains('flat')) return Colors.teal[700]!;
    return Colors.purple[700]!;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addressControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Addresses',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _openAddEditBottomSheet(),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.orange[700], size: 22),
            ),
            tooltip: 'Add New Address',
          ),
          IconButton(
            onPressed: () =>
                ref.read(addressControllerProvider.notifier).load(force: true),
            icon: state.isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
                  )
                : Icon(Icons.refresh, color: Colors.grey[700]),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: state.isLoading && state.addresses.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            )
          : state.addresses.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  color: Colors.orange,
                  onRefresh: () => ref
                      .read(addressControllerProvider.notifier)
                      .load(force: true),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    children: [
                      // Active delivery badge info banner
                      if (state.activeAddress != null)
                        _buildActiveBanner(state.activeAddress!),
                      const SizedBox(height: 16),
                      Text(
                        'Saved Locations (${state.addresses.length})',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...state.addresses.map((address) {
                        final isActive = state.activeAddress?.id == address.id ||
                            (state.activeAddress?.id == null &&
                                state.activeAddress?.address == address.address);
                        return _buildAddressCard(address, isActive: isActive);
                      }),
                    ],
                  ),
                ),
      bottomSheet: state.addresses.isNotEmpty
          ? Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _openAddEditBottomSheet(),
                  icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
                  label: const Text(
                    'Add New Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildActiveBanner(AddressModel active) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange[700],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivering To: ${active.label?.isNotEmpty == true ? active.label : 'Active Location'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  active.address ?? 'No address string',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, {required bool isActive}) {
    final label = address.label?.isNotEmpty == true ? address.label! : 'Home';
    final labelColor = _getColorForLabel(label);
    final labelIcon = _getIconForLabel(label);

    final detailsList = <String>[];
    if (address.streetNumber?.isNotEmpty == true) {
      detailsList.add('Street: ${address.streetNumber}');
    }
    if (address.floor?.isNotEmpty == true) {
      detailsList.add('Floor/Apt: ${address.floor}');
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? Colors.orange[400]! : Colors.grey[200]!,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isActive ? 0.06 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: labelColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(labelIcon, size: 14, color: labelColor),
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: labelColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green[300]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 12, color: Colors.green[700]),
                        const SizedBox(width: 4),
                        Text(
                          'ACTIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              address.address ?? 'No address provided',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (detailsList.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                detailsList.join(' • '),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (address.othersDetails?.isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes_rounded, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      address.othersDetails!,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[500],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Divider(color: Colors.grey[100], height: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                if (!isActive)
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(addressControllerProvider.notifier)
                          .setActiveAddress(address);
                      _showMessage('Set "$label" as active delivery location');
                    },
                    icon: Icon(Icons.radio_button_unchecked,
                        size: 16, color: Colors.orange[700]),
                    label: Text(
                      'Deliver Here',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  )
                else
                  Text(
                    'Selected Delivery Address',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: () => _openAddEditBottomSheet(addressToEdit: address),
                  icon: Icon(Icons.edit_outlined, size: 18, color: Colors.grey[600]),
                  tooltip: 'Edit Address',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => _confirmDelete(address),
                  icon: Icon(Icons.delete_outline, size: 18, color: Colors.red[400]),
                  tooltip: 'Delete Address',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_outlined,
                size: 64,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Saved Addresses Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[850],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add your home, office, or favorite delivery locations to enjoy seamless, one-tap ordering.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _openAddEditBottomSheet(),
                icon: const Icon(Icons.add_location_alt_outlined, color: Colors.white),
                label: const Text(
                  'Add Your First Address',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressFormSheet extends ConsumerStatefulWidget {
  final AddressModel? addressToEdit;
  final VoidCallback onSaved;

  const _AddressFormSheet({this.addressToEdit, required this.onSaved});

  @override
  ConsumerState<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends ConsumerState<_AddressFormSheet> {
  late final TextEditingController _addressController;
  late final TextEditingController _streetController;
  late final TextEditingController _floorController;
  late final TextEditingController _detailsController;
  late final TextEditingController _customLabelController;

  String _selectedLabel = 'Home';
  double _lat = 24.8607;
  double _long = 67.0011;
  bool _isSaving = false;
  bool _isLocating = false;

  final List<String> _labelOptions = ['Home', 'Work', 'Apartment', 'Other'];

  @override
  void initState() {
    super.initState();
    final edit = widget.addressToEdit;
    _addressController = TextEditingController(text: edit?.address ?? '');
    _streetController = TextEditingController(text: edit?.streetNumber ?? '');
    _floorController = TextEditingController(text: edit?.floor ?? '');
    _detailsController = TextEditingController(text: edit?.othersDetails ?? '');

    if (edit?.label != null && edit!.label!.isNotEmpty) {
      if (_labelOptions.contains(edit.label)) {
        _selectedLabel = edit.label!;
        _customLabelController = TextEditingController();
      } else {
        _selectedLabel = 'Other';
        _customLabelController = TextEditingController(text: edit.label);
      }
    } else {
      _customLabelController = TextEditingController();
    }

    _lat = edit?.lat ?? 24.8607;
    _long = edit?.long ?? 67.0011;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _streetController.dispose();
    _floorController.dispose();
    _detailsController.dispose();
    _customLabelController.dispose();
    super.dispose();
  }

  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLocating = true);

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission was denied.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLocating = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _lat = position.latitude;
      _long = position.longitude;

      final res = await getLocationResult(latitude: _lat, longitude: _long);
      if (mounted) {
        if (res.completeAddress != null && res.completeAddress!.isNotEmpty) {
          _addressController.text = res.completeAddress!;
        } else if (res.locationName != null) {
          _addressController.text = res.locationName!;
        }
      }
    } catch (e) {
      debugPrint('Error getting GPS location: $e');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _handleSave() async {
    final addressText = _addressController.text.trim();
    if (addressText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an address.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final finalLabel = _selectedLabel == 'Other' &&
            _customLabelController.text.trim().isNotEmpty
        ? _customLabelController.text.trim()
        : _selectedLabel;

    setState(() => _isSaving = true);

    bool success = false;
    if (widget.addressToEdit != null) {
      final updated = widget.addressToEdit!.copyWith(
        address: addressText,
        streetNumber: _streetController.text.trim(),
        floor: _floorController.text.trim(),
        label: finalLabel,
        othersDetails: _detailsController.text.trim(),
        lat: _lat,
        long: _long,
      );
      success = await ref
          .read(addressControllerProvider.notifier)
          .updateAddress(updated);
    } else {
      success = await ref.read(addressControllerProvider.notifier).addAddress(
            address: addressText,
            streetNumber: _streetController.text.trim(),
            floor: _floorController.text.trim(),
            label: finalLabel,
            othersDetails: _detailsController.text.trim(),
            lat: _lat,
            long: _long,
            setAsActive: true,
          );
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
        widget.onSaved();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save address. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isEditing = widget.addressToEdit != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  isEditing ? Icons.edit_location_alt : Icons.add_location_alt,
                  color: Colors.orange[700],
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  isEditing ? 'Edit Address' : 'Add New Address',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Label Selector
            const Text(
              'Save Address As',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _labelOptions.map((opt) {
                final isSelected = _selectedLabel == opt;
                return ChoiceChip(
                  label: Text(opt),
                  selected: isSelected,
                  selectedColor: Colors.orange[700],
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedLabel = opt);
                  },
                );
              }).toList(),
            ),
            if (_selectedLabel == 'Other') ...[
              const SizedBox(height: 10),
              TextField(
                controller: _customLabelController,
                decoration: InputDecoration(
                  hintText: 'e.g. Grandma\'s House, Gym',
                  labelText: 'Custom Label',
                  prefixIcon: const Icon(Icons.tag, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Address field
            Row(
              children: [
                const Text(
                  'Address Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _isLocating ? null : _fetchCurrentLocation,
                  icon: _isLocating
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.my_location, size: 16, color: Colors.orange[700]),
                  label: Text(
                    'Use GPS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'House/Building name, street, area',
                prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 14),

            // Street & Floor
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _streetController,
                    decoration: InputDecoration(
                      labelText: 'Street / Road #',
                      hintText: 'e.g. St 14',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _floorController,
                    decoration: InputDecoration(
                      labelText: 'Floor / Unit #',
                      hintText: 'e.g. Apt 4B',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Extra Instructions
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                labelText: 'Delivery Instructions (Optional)',
                hintText: 'e.g. Ring buzzer twice, leave at reception',
                prefixIcon: const Icon(Icons.info_outline, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 24),

            // Save CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEditing ? 'Update Address' : 'Save Address',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
