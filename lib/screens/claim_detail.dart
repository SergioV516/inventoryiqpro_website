import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClaimDetailPage extends StatefulWidget {
  final String claimId;

  const ClaimDetailPage({Key? key, required this.claimId}) : super(key: key);

  @override
  _ClaimDetailPageState createState() => _ClaimDetailPageState();
}

class _ClaimDetailPageState extends State<ClaimDetailPage> {
  late ClaimDetail _claimDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // In a real app, you would fetch data from your API
    _loadClaimDetails();
  }

  void _loadClaimDetails() {
    // Simulate loading from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _claimDetail = _getSampleClaimDetail();
        _isLoading = false;
      });
    });
  }

  ClaimDetail _getSampleClaimDetail() {
    // Return a sample claim detail object
    return ClaimDetail(
      id: widget.claimId,
      policyNumber: 'POL-123456',
      policyHolder: 'John Smith',
      contact: 'john.smith@email.com',
      phone: '555-123-4567',
      status: 'Submitted',
      dateSubmitted: DateTime.now().subtract(const Duration(days: 5)),
      dateOfLoss: DateTime.now().subtract(const Duration(days: 7)),
      description:
          'Home break-in while on vacation. Multiple items stolen from living room and home office.',
      location: '123 Main Street, Apt 4B, New York, NY 10001',
      claimType: 'Theft',
      items: [
        ClaimItem(
          id: 'ITEM001',
          name: 'Samsung 65" QLED TV',
          category: 'Electronics',
          purchaseDate: DateTime(2023, 3, 15),
          purchasePrice: 1299.99,
          description: 'Samsung 65" QLED 4K Smart TV Model QN65Q70A',
          room: 'Living Room',
          condition: 'Excellent',
          hasPhotos: true,
          photos: ['tv_front.jpg', 'tv_side.jpg', 'receipt.jpg'],
        ),
        ClaimItem(
          id: 'ITEM002',
          name: 'MacBook Pro 16"',
          category: 'Electronics',
          purchaseDate: DateTime(2022, 8, 10),
          purchasePrice: 2499.99,
          description:
              'Apple MacBook Pro 16" with M1 Pro chip, 16GB RAM, 512GB SSD',
          room: 'Home Office',
          condition: 'Good',
          hasPhotos: true,
          photos: ['macbook1.jpg', 'macbook2.jpg', 'apple_receipt.jpg'],
        ),
        ClaimItem(
          id: 'ITEM003',
          name: 'Leather Sectional Sofa',
          category: 'Furniture',
          purchaseDate: DateTime(2021, 5, 22),
          purchasePrice: 1899.99,
          description:
              'Genuine leather sectional sofa with chaise and recliner',
          room: 'Living Room',
          condition: 'Good',
          hasPhotos: true,
          photos: ['sofa1.jpg', 'sofa2.jpg', 'sofa_damage.jpg'],
        ),
      ],
      activities: [
        Activity(
          type: 'Claim Created',
          timestamp: DateTime.now().subtract(const Duration(days: 5)),
          user: 'John Smith',
          description: 'Claim submitted through My Personal Valuables app',
        ),
        Activity(
          type: 'Claim Assigned',
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
          user: 'System',
          description: 'Claim assigned to Jane Operator',
        ),
        Activity(
          type: 'Documentation Request',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          user: 'Jane Operator',
          description: 'Requested additional photos of the living room damage',
        ),
        Activity(
          type: 'Document Uploaded',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          user: 'John Smith',
          description: 'Uploaded 3 additional photos through the app',
        ),
        Activity(
          type: 'Claim Reviewed',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          user: 'Jane Operator',
          description: 'Initial review completed, pending manager approval',
        ),
      ],
      notes: [
        Note(
          author: 'Jane Operator',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          content:
              'Called customer to request additional documentation for the living room items.',
          isInternal: true,
        ),
        Note(
          author: 'Manager',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          content:
              'The sofa claim amount seems high. Please check if we have the purchase receipt.',
          isInternal: true,
        ),
      ],
      financialDetails: FinancialDetails(
        totalClaimAmount: 5699.97,
        reserveAmount: 5000.00,
        approvedAmount: 0.00,
        paymentsMade: 0.00,
        remainingBalance: 5000.00,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim #${widget.claimId}'),
        backgroundColor: const Color(0xFF1E2A3A),
        actions: [
          TextButton.icon(
            onPressed: () {
              // Add export to PDF functionality
            },
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text(
              'Export PDF',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildClaimHeader(),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildClaimItems(),
                              const SizedBox(height: 24),
                              _buildClaimDetails(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              _buildFinancialSummary(),
                              const SizedBox(height: 24),
                              _buildActivityTimeline(),
                              const SizedBox(height: 24),
                              _buildNotes(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showQuickActionMenu();
        },
        backgroundColor: const Color(0xFF1E2A3A),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build claim header section
  Widget _buildClaimHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Claim #${_claimDetail.id}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildStatusBadge(_claimDetail.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Policy #${_claimDetail.policyNumber}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        _showUpdateStatusDialog();
                      },
                      icon: const Icon(Icons.update),
                      label: const Text('Update Status'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showProcessPaymentDialog();
                      },
                      icon: const Icon(Icons.payments),
                      label: const Text('Process Payment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2A3A),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _claimDetail.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoField('Policy Holder', _claimDetail.policyHolder),
                _buildInfoField('Contact', _claimDetail.contact),
                _buildInfoField('Phone', _claimDetail.phone),
                _buildInfoField(
                  'Date Submitted',
                  DateFormat('MM/dd/yyyy').format(_claimDetail.dateSubmitted),
                ),
                _buildInfoField(
                  'Date of Loss',
                  DateFormat('MM/dd/yyyy').format(_claimDetail.dateOfLoss),
                ),
                _buildInfoField('Type', _claimDetail.claimType),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build a status badge
  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Submitted':
        color = Colors.blue;
        break;
      case 'Reviewed':
        color = Colors.orange;
        break;
      case 'Approved':
        color = Colors.green;
        break;
      case 'Released':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Build info field
  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Build claimed items section
  Widget _buildClaimItems() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Claimed Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_claimDetail.items.length} items • \$${_claimDetail.financialDetails.totalClaimAmount.toStringAsFixed(2)} total',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _claimDetail.items.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = _claimDetail.items[index];
                return ExpansionTile(
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${item.category} • ${item.room} • \$${item.purchasePrice.toStringAsFixed(2)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.hasPhotos)
                        const Icon(
                          Icons.photo_library,
                          color: Colors.blue,
                          size: 20,
                        ),
                      const SizedBox(width: 8),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(item.description),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Purchase Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat(
                                        'MM/dd/yyyy',
                                      ).format(item.purchaseDate),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Purchase Price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.purchasePrice.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Condition',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(item.condition),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (item.hasPhotos) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Photos',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: item.photos.length,
                                itemBuilder: (context, photoIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.photo,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  // View more details or gallery
                                },
                                icon: const Icon(Icons.visibility),
                                label: const Text('View Details'),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Adjust valuation
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Adjust Valuation'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build claim details section
  Widget _buildClaimDetails() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Claim Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Loss Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_claimDetail.location),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Type of Loss',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_claimDetail.claimType),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Loss Description',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_claimDetail.description),
          ],
        ),
      ),
    );
  }

  // Build financial summary section
  Widget _buildFinancialSummary() {
    final financials = _claimDetail.financialDetails;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildFinancialItem(
              'Total Claim Amount',
              '\$${financials.totalClaimAmount.toStringAsFixed(2)}',
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildFinancialItem(
              'Reserve Amount',
              '\$${financials.reserveAmount.toStringAsFixed(2)}',
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildFinancialItem(
              'Approved Amount',
              '\$${financials.approvedAmount.toStringAsFixed(2)}',
              Colors.green,
            ),
            const SizedBox(height: 16),
            _buildFinancialItem(
              'Payments Made',
              '\$${financials.paymentsMade.toStringAsFixed(2)}',
              Colors.purple,
            ),
            const SizedBox(height: 16),
            _buildFinancialItem(
              'Remaining Balance',
              '\$${financials.remainingBalance.toStringAsFixed(2)}',
              Colors.blueGrey,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showProcessPaymentDialog();
                },
                icon: const Icon(Icons.payments),
                label: const Text('Process Payment'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build financial item
  Widget _buildFinancialItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  // Build activity timeline section
  Widget _buildActivityTimeline() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Activity Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _claimDetail.activities.length,
              itemBuilder: (context, index) {
                final activity = _claimDetail.activities[index];
                final isFirst = index == 0;
                final isLast = index == _claimDetail.activities.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1E2A3A),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 60,
                            color: Colors.grey[300],
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.type,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${activity.user} • ${DateFormat('MM/dd/yyyy hh:mm a').format(activity.timestamp)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(activity.description),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Build notes section
  Widget _buildNotes() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    _showAddNoteDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Note'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _claimDetail.notes.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final note = _claimDetail.notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            note.author,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              if (note.isInternal)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Internal',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat(
                                  'MM/dd/yyyy hh:mm a',
                                ).format(note.timestamp),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(note.content),
                    ],
                  ),
                );
              },
            ),
            if (_claimDetail.notes.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notes yet',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Show quick action menu
  void _showQuickActionMenu() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Quick Actions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.note_add),
                  title: const Text('Add Note'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddNoteDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Claimant'),
                  onTap: () {
                    Navigator.pop(context);
                    // Email functionality
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: const Text('Update Status'),
                  onTap: () {
                    Navigator.pop(context);
                    _showUpdateStatusDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payments),
                  title: const Text('Process Payment'),
                  onTap: () {
                    Navigator.pop(context);
                    _showProcessPaymentDialog();
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Show add note dialog
  // Show add note dialog
  void _showAddNoteDialog() {
    final TextEditingController noteController = TextEditingController();
    bool isInternal = true;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add Note'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          labelText: 'Note Content',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: isInternal,
                            onChanged: (value) {
                              setState(() {
                                isInternal = value ?? true;
                              });
                            },
                          ),
                          const Text('Internal Note (not visible to claimant)'),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (noteController.text.isNotEmpty) {
                          setState(() {
                            _claimDetail.notes.add(
                              Note(
                                author: 'Current User',
                                timestamp: DateTime.now(),
                                content: noteController.text,
                                isInternal: isInternal,
                              ),
                            );
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Note added successfully'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2A3A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Note'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Show update status dialog
  void _showUpdateStatusDialog() {
    String selectedStatus = _claimDetail.status;
    final statusOptions = ['Submitted', 'Reviewed', 'Approved', 'Released'];

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Update Claim Status'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Status:'),
                      const SizedBox(height: 8),
                      Text(
                        _claimDetail.status,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('New Status:'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedStatus = value!;
                          });
                        },
                        items:
                            statusOptions
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Status Update Reason (Optional)',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final oldStatus = _claimDetail.status;
                          _claimDetail.status = selectedStatus;
                          _claimDetail.activities.insert(
                            0,
                            Activity(
                              type: 'Status Updated',
                              timestamp: DateTime.now(),
                              user: 'Current User',
                              description:
                                  'Status changed from $oldStatus to $selectedStatus',
                            ),
                          );
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Status updated to $selectedStatus'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2A3A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Update Status'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Show process payment dialog
  void _showProcessPaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    String paymentMethod = 'Check';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Process Payment'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Payment Amount:'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: amountController,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixText: '\$',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Payment Method:'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: paymentMethod,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            paymentMethod = value!;
                          });
                        },
                        items:
                            [
                                  'Check',
                                  'Direct Deposit',
                                  'Wire Transfer',
                                  'Credit Card',
                                ]
                                .map(
                                  (method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(method),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: noteController,
                        decoration: const InputDecoration(
                          labelText: 'Payment Note',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (amountController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a payment amount'),
                            ),
                          );
                          return;
                        }

                        final paymentAmount =
                            double.tryParse(amountController.text) ?? 0.0;
                        if (paymentAmount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter a valid payment amount',
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          final financials = _claimDetail.financialDetails;
                          financials.paymentsMade += paymentAmount;
                          financials.remainingBalance -= paymentAmount;

                          _claimDetail.activities.insert(
                            0,
                            Activity(
                              type: 'Payment Processed',
                              timestamp: DateTime.now(),
                              user: 'Current User',
                              description:
                                  'Payment of \$${paymentAmount.toStringAsFixed(2)} processed via $paymentMethod',
                            ),
                          );
                        });

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Payment of \$${paymentAmount.toStringAsFixed(2)} processed',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2A3A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Process Payment'),
                    ),
                  ],
                ),
          ),
    );
  }
}

// Data models for claim detail
class ClaimDetail {
  final String id;
  final String policyNumber;
  final String policyHolder;
  final String contact;
  final String phone;
  String status;
  final DateTime dateSubmitted;
  final DateTime dateOfLoss;
  final String description;
  final String location;
  final String claimType;
  final List<ClaimItem> items;
  final List<Activity> activities;
  final List<Note> notes;
  final FinancialDetails financialDetails;

  ClaimDetail({
    required this.id,
    required this.policyNumber,
    required this.policyHolder,
    required this.contact,
    required this.phone,
    required this.status,
    required this.dateSubmitted,
    required this.dateOfLoss,
    required this.description,
    required this.location,
    required this.claimType,
    required this.items,
    required this.activities,
    required this.notes,
    required this.financialDetails,
  });
}

class ClaimItem {
  final String id;
  final String name;
  final String category;
  final DateTime purchaseDate;
  final double purchasePrice;
  final String description;
  final String room;
  final String condition;
  final bool hasPhotos;
  final List<String> photos;

  ClaimItem({
    required this.id,
    required this.name,
    required this.category,
    required this.purchaseDate,
    required this.purchasePrice,
    required this.description,
    required this.room,
    required this.condition,
    required this.hasPhotos,
    required this.photos,
  });
}

class Activity {
  final String type;
  final DateTime timestamp;
  final String user;
  final String description;

  Activity({
    required this.type,
    required this.timestamp,
    required this.user,
    required this.description,
  });
}

class Note {
  final String author;
  final DateTime timestamp;
  final String content;
  final bool isInternal;

  Note({
    required this.author,
    required this.timestamp,
    required this.content,
    required this.isInternal,
  });
}

class FinancialDetails {
  final double totalClaimAmount;
  double reserveAmount;
  double approvedAmount;
  double paymentsMade;
  double remainingBalance;

  FinancialDetails({
    required this.totalClaimAmount,
    required this.reserveAmount,
    required this.approvedAmount,
    required this.paymentsMade,
    required this.remainingBalance,
  });
}
