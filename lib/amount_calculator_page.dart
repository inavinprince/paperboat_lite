import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:file_picker/file_picker.dart';

class AmountCalculatorPage extends StatefulWidget {
  const AmountCalculatorPage({super.key});

  @override
  State<AmountCalculatorPage> createState() => _AmountCalculatorPageState();
}

class _AmountCalculatorPageState extends State<AmountCalculatorPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _gradientAnimation;
  final List<Product> _products = [
    Product(name: 'Product 1', balance: 200, rate: 50),
    Product(name: 'Product 2', balance: 150, rate: 50),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _gradientAnimation = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.purpleAccent,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get totalAmount {
    return _products.fold(0, (sum, product) => sum + product.amount);
  }

  void _addProduct() {
    setState(() {
      _products.add(Product(
          name: 'Product ${_products.length + 1}', balance: 0, rate: 0));
    });
  }

  void _removeProduct(int index) {
    if (_products.length > 1) {
      setState(() {
        _products.removeAt(index);
      });
    }
  }

  void _updateProduct(int index, Product updatedProduct) {
    setState(() {
      _products[index] = updatedProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _gradientAnimation.value!.withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: child,
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Paperboat Calculator',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.indigo[900],
                          ),
                        ),
                        Text(
                          'Calculate your total amount effortlessly',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.purpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calculate_rounded, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Total: \$${totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Table Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Product Name',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[800],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Balance',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[800],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Rate (%)',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[800],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Amount',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Space for delete button
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Products List
                Expanded(
                  child: ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: _ProductRow(
                          product: _products[index],
                          onChanged: (updatedProduct) =>
                              _updateProduct(index, updatedProduct),
                          onDelete: () => _removeProduct(index),
                          canDelete: _products.length > 1,
                        ),
                      );
                    },
                  ),
                ),

                // Add Product Button
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton.icon(
                      onPressed: _addProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.indigo,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.indigo.shade200),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      label: Text(
                        'Add Product',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // Total Amount Card
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[50]!, Colors.blue[50]!],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount:',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[900],
                        ),
                      ),
                      Text(
                        '\$${totalAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed: () =>
                      PDFExportService.generateAndExportPDF(_products, context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text(
                    'Export PDF Report',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductRow extends StatefulWidget {
  final Product product;
  final Function(Product) onChanged;
  final VoidCallback onDelete;
  final bool canDelete;

  const _ProductRow({
    required this.product,
    required this.onChanged,
    required this.onDelete,
    required this.canDelete,
  });

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _balanceController =
        TextEditingController(text: widget.product.balance.toString());
    _rateController =
        TextEditingController(text: widget.product.rate.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _updateProduct() {
    final updatedProduct = Product(
      name: _nameController.text,
      balance: double.tryParse(_balanceController.text) ?? 0,
      rate: double.tryParse(_rateController.text) ?? 0,
    );
    widget.onChanged(updatedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Product name',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.poppins(),
              onChanged: (value) => _updateProduct(),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _balanceController,
              decoration: InputDecoration(
                hintText: '0',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.poppins(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onChanged: (value) => _updateProduct(),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _rateController,
              decoration: InputDecoration(
                hintText: '0',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixText: '%',
              ),
              style: GoogleFonts.poppins(),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onChanged: (value) => _updateProduct(),
            ),
          ),
          Expanded(
            child: Text(
              '\$${widget.product.amount.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: widget.canDelete ? 1.0 : 0.0,
            child: IconButton(
              onPressed: widget.canDelete ? widget.onDelete : null,
              icon: Icon(Icons.delete_outline_rounded,
                  color: Colors.red.shade300),
              splashRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}

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
      List<Product> products, BuildContext context) async {
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

  static pw.Widget _buildProductsTable(List<Product> products) {
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

  static pw.Widget _buildTotalAmount(List<Product> products) {
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
      BuildContext context, pw.Document pdf, List<Product> products) async {
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
