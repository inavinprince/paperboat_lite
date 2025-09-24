import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:paperboat_lite/app_theme.dart';
import 'package:paperboat_lite/product.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';


import 'package:responsive_framework/responsive_framework.dart';

class AmountCalculatorPage extends StatefulWidget {
  const AmountCalculatorPage({super.key});

  @override
  State<AmountCalculatorPage> createState() => _AmountCalculatorPageState();
}

class _AmountCalculatorPageState extends State<AmountCalculatorPage> {
  final List<Products> _products = [
    Products(name: 'Product 1', balance: 200, rate: 50),
    Products(name: 'Product 2', balance: 150, rate: 50),
  ];

  double get totalAmount => _products.fold(0, (sum, product) => sum + product.amount);

  void _addProduct() {
    setState(() {
      _products.add(Products(
        name: 'Product ${_products.length + 1}', 
        balance: 0, 
        rate: 0
      ));
    });
  }

  void _removeProduct(int index) {
    if (_products.length > 1) {
      setState(() {
        _products.removeAt(index);
      });
    }
  }

  void _updateProduct(int index, Products updatedProduct) {
    setState(() {
      _products[index] = updatedProduct;
    });
  }

  void _toggleTheme() {
    setState(() {
      AppTheme.toggleTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final padding = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Paperboat Calculator',
          style: AppTheme.titleTextStyle(isMobile),
        ),
        actions: [
          IconButton(
            onPressed: _toggleTheme,
            icon: Icon(
              AppTheme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              // Header Section
              _buildHeaderSection(isMobile),
              const SizedBox(height: 24),

              // Table Header
              _buildTableHeader(isMobile),
              const SizedBox(height: 8),

              // Products List
              Expanded(
                child: _buildProductsList(isMobile),
              ),

              // Action Section
              _buildActionSection(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calculate totals effortlessly',
                style: AppTheme.subtitleTextStyle(isMobile),
              ),
            ],
          ),
        ),
        if (!isMobile) _buildTotalBadge(isMobile, false),
      ],
    );
  }

  Widget _buildTotalBadge(bool isMobile, bool isMobileVersion) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: isMobileVersion 
          ? const EdgeInsets.all(12)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(isMobileVersion ? 8 : 12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calculate, color: Colors.white, size: isMobile ? 16 : 18),
          const SizedBox(width: 6),
          Text(
            'Total: \$${totalAmount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: isMobile ? 3 : 2,
            child: Text('Product', style: AppTheme.headerTextStyle(isMobile)),
          ),
          Expanded(child: Text('Balance', style: AppTheme.headerTextStyle(isMobile))),
          Expanded(child: Text('Rate %', style: AppTheme.headerTextStyle(isMobile))),
          Expanded(child: Text('Amount', style: AppTheme.headerTextStyle(isMobile))),
          SizedBox(width: isMobile ? 30 : 40),
        ],
      ),
    );
  }

  Widget _buildProductsList(bool isMobile) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 6),
          child: ProductRow(
            product: _products[index],
            onChanged: (updatedProduct) => _updateProduct(index, updatedProduct),
            onDelete: () => _removeProduct(index),
            canDelete: _products.length > 1,
            isMobile: isMobile,
          ),
        );
      },
    );
  }

  Widget _buildActionSection(bool isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildAddButton(isMobile)),
            const SizedBox(width: 12),
            Expanded(child: _buildExportButton(isMobile)),
          ],
        ),
        const SizedBox(height: 16),
        _buildTotalCard(isMobile),
        const SizedBox(height: 20),
        _buildFooter(),
      ],
    );
  }

  Widget _buildAddButton(bool isMobile) {
    return ElevatedButton.icon(
      onPressed: _addProduct,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.buttonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isMobile ? 10 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(Icons.add, size: isMobile ? 16 : 18),
      label: Text('Add Product', style: AppTheme.buttonTextStyle(isMobile)),
    );
  }

  Widget _buildExportButton(bool isMobile) {
    return ElevatedButton.icon(
      onPressed: () => PDFExportService.generateAndExportPDF(_products, context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.secondaryButtonColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: isMobile ? 10 : 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(Icons.picture_as_pdf, size: isMobile ? 16 : 18),
      label: Text('Export PDF', style: AppTheme.buttonTextStyle(isMobile)),
    );
  }

  Widget _buildTotalCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.totalGradient,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Amount:', style: AppTheme.totalLabelTextStyle(isMobile)),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: AppTheme.totalAmountTextStyle(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      'Developed by: @navinprince',
      style: AppTheme.footerTextStyle(),
    );
  }
}

class ProductRow extends StatefulWidget {
  final Products product;
  final Function(Products) onChanged;
  final VoidCallback onDelete;
  final bool canDelete;
  final bool isMobile;

  const ProductRow({
    super.key,
    required this.product,
    required this.onChanged,
    required this.onDelete,
    required this.canDelete,
    required this.isMobile,
  });

  @override
  State<ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<ProductRow> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.product.name);
    _balanceController = TextEditingController(text: widget.product.balance.toStringAsFixed(0));
    _rateController = TextEditingController(text: widget.product.rate.toStringAsFixed(0));
    
    // Add listeners for real-time updates
    _nameController.addListener(_onNameChanged);
    _balanceController.addListener(_onBalanceChanged);
    _rateController.addListener(_onRateChanged);
  }

  void _onNameChanged() {
    widget.onChanged(widget.product.copyWith(name: _nameController.text));
  }

  void _onBalanceChanged() {
    final balance = double.tryParse(_balanceController.text) ?? 0;
    widget.onChanged(widget.product.copyWith(balance: balance));
  }

  void _onRateChanged() {
    final rate = double.tryParse(_rateController.text) ?? 0;
    widget.onChanged(widget.product.copyWith(rate: rate));
  }

  @override
  void didUpdateWidget(ProductRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update controllers only if the product data actually changed
    if (oldWidget.product.name != widget.product.name && 
        _nameController.text != widget.product.name) {
      _nameController.text = widget.product.name;
    }
    if (oldWidget.product.balance != widget.product.balance &&
        _balanceController.text != widget.product.balance.toStringAsFixed(0)) {
      _balanceController.text = widget.product.balance.toStringAsFixed(0);
    }
    if (oldWidget.product.rate != widget.product.rate &&
        _rateController.text != widget.product.rate.toStringAsFixed(0)) {
      _rateController.text = widget.product.rate.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.isMobile ? 10 : 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          _buildTextField(_nameController, 'Product name', flex: widget.isMobile ? 3 : 2),
          _buildNumberField(_balanceController, ''),
          _buildNumberField(_rateController, '', isRate: true),
          _buildAmountDisplay(),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: widget.isMobile ? 10 : 12,
          ),
        ),
        style: AppTheme.bodyTextStyle(widget.isMobile),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String suffix, {bool isRate = false}) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffixText: suffix,
          suffixStyle: TextStyle(color: Colors.grey[500], fontSize: 10),
        ),
        style: AppTheme.bodyTextStyle(widget.isMobile),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildAmountDisplay() {
    return Expanded(
      child: Text(
        '\$${widget.product.amount.toStringAsFixed(2)}',
        style: AppTheme.amountTextStyle(widget.isMobile),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      onPressed: widget.canDelete ? widget.onDelete : null,
      icon: Icon(
        Icons.delete_outline,
        size: widget.isMobile ? 16 : 18,
        color: Colors.grey[500],
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}






// pdf invoice part
class Product {
  String name;
  double balance;
  double rate;

  Product({
    required this.name,
    required this.balance,
    required this.rate,
  });

  double get amount => (balance * (rate / 100));
}

class PDFExportService {
  static Future<void> generateAndExportPDF(
      List<Products> products, BuildContext context) async {
    // Create PDF document
    final pdf = pw.Document();

    // Add a page with modern styling
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header section
                _buildHeader(),
                pw.SizedBox(height: 20),

                // Products table
                _buildProductsTable(products),
                pw.SizedBox(height: 20),

                // Total amount section
                _buildTotalAmount(products),
              ],
            ),
          );
        },
      ),
    );

    // Show export options
    await _showExportOptions(context, pdf, products);
  }

  static pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Paperboat Invoice',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'Generated on: ${DateTime.now().toString().split(' ')[0]}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Container(
          width: 60,
          height: 60,
          decoration: pw.BoxDecoration(
            color: PdfColors.blue100,
            borderRadius: pw.BorderRadius.circular(30),
          ),
          child: pw.Center(
            child: pw.Icon(
              pw.IconData(0xe922), // Analytics icon code
              size: 24,
              color: PdfColors.blue800,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildProductsTable(List<Products> products) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.TableHelper.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          color: PdfColors.blue50,
          borderRadius: const pw.BorderRadius.only(
            topLeft: pw.Radius.circular(8),
            topRight: pw.Radius.circular(8),
          ),
        ),
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
          fontSize: 12,
        ),
        cellStyle: const pw.TextStyle(fontSize: 10),
        rowDecoration: pw.BoxDecoration(
          border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5)),
        ),
        headers: ['Product Name', 'Balance', 'Rate %', 'Amount'],
        data: products
            .map((product) => [
                  product.name,
                  '\$${product.balance.toStringAsFixed(2)}',
                  '${product.rate.toStringAsFixed(1)}%',
                  '\$${product.amount.toStringAsFixed(2)}',
                ])
            .toList(),
      ),
    );
  }

  static pw.Widget _buildTotalAmount(List<Products> products) {
    final totalAmount = products.fold<double>(0.0, (sum, product) {
      final productAmount = product.amount;
      return sum + (productAmount ?? 0.0);
    });

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green300, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'TOTAL AMOUNT:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green900,
            ),
          ),
          pw.Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green900,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _showExportOptions(
      BuildContext context, pw.Document pdf, List<Products> products) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Report',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.preview, color: Colors.blue),
              title: const Text('Preview PDF'),
              subtitle: const Text('View the report before exporting'),
              onTap: () => Navigator.pop(context, 1),
            ),
            ListTile(
              leading: const Icon(Icons.print, color: Colors.green),
              title: const Text('Print Directly'),
              subtitle: const Text('Send to printer'),
              onTap: () => Navigator.pop(context, 2),
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.orange),
              title: const Text('Save as PDF'),
              subtitle: const Text('Download to your device'),
              onTap: () => Navigator.pop(context, 3),
            ),
          ],
        ),
      ),
    );

    switch (result) {
      case 1:
        await Printing.layoutPdf(
          onLayout: (format) => pdf.save(),
        );
        break;
      case 2:
        await Printing.sharePdf(
          bytes: await pdf.save(),
          filename:
              'product_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
        );
        break;
      case 3:
        await _saveToFile(context, pdf);
        break;
    }
  }

  static Future<void> _saveToFile(BuildContext context, pw.Document pdf) async {
    try {
      final String? outputFile = await FilePicker.platform.saveFile(
        fileName: 'product_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
        allowedExtensions: ['pdf'],
      );

      if (outputFile != null) {
        final bytes = await pdf.save();
        // For mobile: Use path_provider to get directory and write file
        // For web: This will trigger download
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
