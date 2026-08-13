import 'package:flutter/material.dart';
import 'package:point_sale/core/constants/app_color.dart';

class CustomerInformationModal extends StatefulWidget {
  const CustomerInformationModal({super.key});

  @override
  State<CustomerInformationModal> createState() =>
      _CustomerInformationModalState();
}

class _CustomerInformationModalState extends State<CustomerInformationModal> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.whiteWithOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Customer Information',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 20,
                    color: AppColor.textPrimary,
                    height: 1.4,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: AppColor.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Nickname',
              hint: 'AhBen',
              controller: _nicknameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Address',
              hint: 'Phnom Penh',
              controller: _addressController,
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Phone Number',
              hint: '',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColor.textPrimary,
                        side: const BorderSide(
                          color: AppColor.borderMedium,
                          width: 1.15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'nickname': _nicknameController.text.trim(),
                          'address': _addressController.text.trim(),
                          'phoneNumber': _phoneController.text.trim(),
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryDark,
                        foregroundColor: AppColor.backgroundWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Arimo',
            fontSize: 14,
            color: AppColor.textLabel,
            height: 1.43,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Arimo',
            fontSize: 16,
            color: AppColor.textPrimary,
            height: 1.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 16,
              color: AppColor.textPrimaryWithOpacity(0.5),
              height: 1.5,
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.borderMedium,
                width: 1.15,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColor.borderMedium,
                width: 1.15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}