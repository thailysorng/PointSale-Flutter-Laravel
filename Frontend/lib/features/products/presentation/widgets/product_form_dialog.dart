import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:point_sale/features/products/data/models/category_model.dart';
import 'package:provider/provider.dart';
import 'package:point_sale/features/products/data/models/product_inventory.dart';
import 'package:point_sale/features/products/providers/product_inventory_provider.dart';
import 'dart:typed_data';

class ProductFormDialog extends StatefulWidget {
  final ProductInventory? productToEdit;

  const ProductFormDialog({super.key, this.productToEdit});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _skuController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;
  bool _isCreatingNewCategory = false;
  bool _isSaving = false;
  Category? _selectedCategory;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productToEdit?.name ?? '');
    _categoryController = TextEditingController(text: widget.productToEdit?.category?.name ?? '');
    _skuController = TextEditingController(text: widget.productToEdit?.skuCode ?? '');
    _priceController = TextEditingController(text: widget.productToEdit != null ? widget.productToEdit!.price.toString() : '');
    _stockController = TextEditingController(text: widget.productToEdit != null ? widget.productToEdit!.quantity.toString() : '');
    _minStockController = TextEditingController(text: widget.productToEdit?.minStock.toString() ?? '');
    _maxStockController = TextEditingController(text: widget.productToEdit?.maxStock.toString() ?? '');
    _selectedCategory = widget.productToEdit?.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _createCategory() async {
    final name = _categoryController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isSaving = true);
    final provider = Provider.of<ProductInventoryProvider>(context, listen: false);
    final category = await provider.addCategory(name);
    setState(() => _isSaving = false);

    if (category != null) {
      setState(() {
        _selectedCategory = category;
        _isCreatingNewCategory = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create category: ${provider.error ?? 'Unknown error'}')),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select or create a category')),
        );
        return;
      }

      final name = _nameController.text.trim();
      final sku = _skuController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
      final stock = int.tryParse(_stockController.text.trim()) ?? 0;
      final minStock = int.tryParse(_minStockController.text.trim()) ?? 0;
      
      final maxStockInput = _maxStockController.text.trim();
      int maxStock = maxStockInput.isEmpty ? stock : (int.tryParse(maxStockInput) ?? stock);
      
      // If stock is increased beyond current max stock, update max stock to match
      if (stock > maxStock) {
        maxStock = stock;
      }

      setState(() => _isSaving = true);
      final provider = Provider.of<ProductInventoryProvider>(context, listen: false);

      final productData = {
        'name': name,
        'sku_code': sku.isEmpty ? null : sku,
        'category_id': _selectedCategory!.id,
        'price': price,
        'quantity': stock,
        'min_stock': minStock,
        'max_stock': maxStock,
      };

      bool success;
      if (widget.productToEdit != null) {
        success = await provider.updateProduct(
          widget.productToEdit!.id!,
          productData,
          imageFile: _imageFile,
        );
      } else {
        success = await provider.addProduct(
          productData,
          imageFile: _imageFile,
        );
      }

      if (mounted) {
        setState(() => _isSaving = false);
        if (success) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save product: ${provider.error ?? 'Unknown error'}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.productToEdit == null ? 'Add New Product' : 'Edit Product',
                      style: const TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0A0A0A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Image Picker
                _buildLabel('Product Image'),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD1D5DC), width: 1),
                      ),
                      child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FutureBuilder<Uint8List>(
                            future: _imageFile!.readAsBytes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        )
                      : widget.productToEdit?.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.productToEdit!.imageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: Color(0xFF9CA3AF),
                                  size: 32,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Upload',
                                  style: TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Product Name
                _buildLabel('Product Name *'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nameController,
                  hint: 'Enter product name',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Category
                _buildLabel('Category *'),
                const SizedBox(height: 8),
                if (_isCreatingNewCategory) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                            hintText: 'Enter category name',
                            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 16),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFD1D5DC), width: 1.15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFD1D5DC), width: 1.15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF00B8DB), width: 1.15),
                            ),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _createCategory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B8DB),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _isSaving 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Create', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _categoryController.clear();
                        _isCreatingNewCategory = false;
                      });
                    },
                    child: const Text(
                      '< Back to existing categories',
                      style: TextStyle(color: Color(0xFF2563EB), fontSize: 14),
                    ),
                  ),
                ] else ...[
                  LayoutBuilder(
                    builder: (context, constraints) => Autocomplete<Category>(
                      displayStringForOption: (Category option) => option.name,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final provider = Provider.of<ProductInventoryProvider>(context, listen: false);
                        final existingCategories = provider.categories;
                        if (textEditingValue.text.isEmpty) {
                          return existingCategories;
                        }
                        return existingCategories.where((cat) => cat.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (Category selection) {
                        setState(() {
                          _selectedCategory = selection;
                          _categoryController.text = selection.name;
                        });
                      },
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        if (_selectedCategory != null && controller.text != _selectedCategory!.name) {
                          controller.text = _selectedCategory!.name;
                        }
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) => onFieldSubmitted(),
                          decoration: InputDecoration(
                            hintText: 'Select a category',
                            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 16),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                            suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFD1D5DC), width: 1.15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFD1D5DC), width: 1.15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF00B8DB), width: 1.15),
                            ),
                          ),
                          validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 200, maxWidth: constraints.maxWidth),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);
                                  return InkWell(
                                    onTap: () => onSelected(option),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                      child: Text(option.name, style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8))),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _categoryController.clear();
                        _isCreatingNewCategory = true;
                        _selectedCategory = null;
                      });
                    },
                    child: const Text(
                      'Create a new category>',
                      style: TextStyle(color: Color(0xFF2563EB), fontSize: 14),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // SKU
                _buildLabel('SKU'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _skuController,
                  hint: 'Auto-generated if empty',
                ),
                const SizedBox(height: 16),

                // Price & Stock
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Price *'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _priceController,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Stock *'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _stockController,
                            hint: '0',
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Min & Max Stock
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Min Stock *'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _minStockController,
                            hint: '10',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Max Stock *'),
                          const SizedBox(height: 8),
                          _buildTextField(
                            controller: _maxStockController,
                            hint: '50',
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Footer Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFD1D5DC), width: 1.15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF0A0A0A), fontSize: 16, fontWeight: FontWeight.normal)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProduct,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B8DB),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _isSaving 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(widget.productToEdit == null ? 'Add Product' : 'Save Changes', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Color(0xFF364153),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DC), width: 1.15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DC), width: 1.15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF00B8DB), width: 1.15),
        ),
      ),
    );
  }
}
