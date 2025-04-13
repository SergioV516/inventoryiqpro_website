import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:inventory_iq_pro/services/report_service.dart';

class PolicyHolderPage extends StatefulWidget {
  const PolicyHolderPage({Key? key}) : super(key: key);

  @override
  _PolicyHolderPageState createState() => _PolicyHolderPageState();
}

class _PolicyHolderPageState extends State<PolicyHolderPage> {
  bool _isLoading = true;
  List<PolicyHolder> _policyHolders = [];
  String _searchQuery = '';
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _loadPolicyHolders();
  }

  void _loadPolicyHolders() {
    // Simulate loading from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _policyHolders = _getSamplePolicyHolders();
        _isLoading = false;
      });
    });
  }

  List<PolicyHolder> _getSamplePolicyHolders() {
    return [
      PolicyHolder(
        id: 'PH001',
        name: 'John Smith',
        email: 'john.smith@email.com',
        phone: '555-123-4567',
        address: '123 Main St, Apt 4B, New York, NY 10001',
        policyNumber: 'POL-123456',
        policyType: 'Homeowners',
        startDate: DateTime(2023, 1, 15),
        endDate: DateTime(2024, 1, 15),
        premium: 1200.00,
        status: 'Active',
        hasApp: true,
        lastLogin: DateTime.now().subtract(const Duration(days: 5)),
        totalClaims: 1,
        openClaims: 1,
      ),
      PolicyHolder(
        id: 'PH002',
        name: 'Sarah Johnson',
        email: 'sarah.johnson@email.com',
        phone: '555-234-5678',
        address: '456 Park Ave, Brooklyn, NY 11201',
        policyNumber: 'POL-789012',
        policyType: 'Renters',
        startDate: DateTime(2022, 11, 10),
        endDate: DateTime(2023, 11, 10),
        premium: 450.00,
        status: 'Active',
        hasApp: true,
        lastLogin: DateTime.now().subtract(const Duration(days: 12)),
        totalClaims: 0,
        openClaims: 0,
      ),
      PolicyHolder(
        id: 'PH003',
        name: 'Michael Brown',
        email: 'michael.brown@email.com',
        phone: '555-345-6789',
        address: '789 Broadway, Queens, NY 11106',
        policyNumber: 'POL-345678',
        policyType: 'Homeowners',
        startDate: DateTime(2022, 6, 20),
        endDate: DateTime(2023, 6, 20),
        premium: 1050.00,
        status: 'Expired',
        hasApp: false,
        lastLogin: null,
        totalClaims: 2,
        openClaims: 0,
      ),
      PolicyHolder(
        id: 'PH004',
        name: 'Jennifer Davis',
        email: 'jennifer.davis@email.com',
        phone: '555-456-7890',
        address: '321 5th Ave, New York, NY 10016',
        policyNumber: 'POL-901234',
        policyType: 'Condo',
        startDate: DateTime(2023, 3, 5),
        endDate: DateTime(2024, 3, 5),
        premium: 950.00,
        status: 'Active',
        hasApp: true,
        lastLogin: DateTime.now().subtract(const Duration(days: 3)),
        totalClaims: 0,
        openClaims: 0,
      ),
      PolicyHolder(
        id: 'PH005',
        name: 'Robert Wilson',
        email: 'robert.wilson@email.com',
        phone: '555-567-8901',
        address: '987 Hudson St, Hoboken, NJ 07030',
        policyNumber: 'POL-567890',
        policyType: 'Homeowners',
        startDate: DateTime(2022, 9, 12),
        endDate: DateTime(2023, 9, 12),
        premium: 1350.00,
        status: 'Pending Renewal',
        hasApp: true,
        lastLogin: DateTime.now().subtract(const Duration(days: 20)),
        totalClaims: 1,
        openClaims: 0,
      ),
    ];
  }

  // Filter policy holders based on search and filter
  List<PolicyHolder> get _filteredPolicyHolders {
    return _policyHolders.where((holder) {
      final matchesSearch =
          holder.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          holder.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          holder.policyNumber.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesFilter =
          _filter == 'All' ||
          (_filter == 'Active' && holder.status == 'Active') ||
          (_filter == 'Inactive' && holder.status != 'Active') ||
          (_filter == 'Has Claims' && holder.totalClaims > 0) ||
          (_filter == 'No App' && !holder.hasApp);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section with search and actions
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Summary stats
                    _buildSummaryCards(),

                    const SizedBox(height: 24),

                    // Policy holders table
                    Expanded(child: _buildPolicyHoldersTable()),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPolicyHolderDialog();
        },
        backgroundColor: const Color(0xFF1E2A3A),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build header with search and actions
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Policy Holders',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search policy holders...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: () {
                ReportService.exportPolicyHoldersToCsv(_policyHolders);
              },
              icon: const Icon(Icons.download),
              label: const Text('Export CSV'),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {
                ReportService.generatePolicyHoldersPdfReport(
                  _policyHolders,
                  context,
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                _showAddPolicyHolderDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text('New Policy Holder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E2A3A),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Build summary stats cards
  Widget _buildSummaryCards() {
    final totalPolicyHolders = _policyHolders.length;
    final activePolicyHolders =
        _policyHolders.where((h) => h.status == 'Active').length;
    final pendingRenewal =
        _policyHolders.where((h) => h.status == 'Pending Renewal').length;
    final hasApp = _policyHolders.where((h) => h.hasApp).length;
    final appPercentage =
        totalPolicyHolders > 0
            ? (hasApp / totalPolicyHolders * 100).toStringAsFixed(0)
            : '0';

    return Row(
      children: [
        _buildSummaryCard(
          'Total Policy Holders',
          totalPolicyHolders.toString(),
          Colors.blue,
          Icons.people,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Active Policies',
          activePolicyHolders.toString(),
          Colors.green,
          Icons.check_circle,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Pending Renewal',
          pendingRenewal.toString(),
          Colors.orange,
          Icons.update,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'App Adoption',
          '$appPercentage%',
          Colors.purple,
          Icons.phone_android,
        ),
      ],
    );
  }

  // Build summary card widget
  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build policy holders table
  Widget _buildPolicyHoldersTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Policy Holders List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _filter,
                  items:
                      ['All', 'Active', 'Inactive', 'Has Claims', 'No App']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _filter = value!;
                    });
                  },
                  hint: const Text('Filter'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _filteredPolicyHolders.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No policy holders found',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _filter = 'All';
                                });
                              },
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ),
                      )
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                              Colors.grey[50],
                            ),
                            dataRowHeight: 60,
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Policy Number')),
                              DataColumn(label: Text('Policy Type')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Start Date')),
                              DataColumn(label: Text('End Date')),
                              DataColumn(label: Text('Premium'), numeric: true),
                              DataColumn(label: Text('App')),
                              DataColumn(label: Text('Claims'), numeric: true),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows:
                                _filteredPolicyHolders.map((holder) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              holder.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              holder.email,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        Text(holder.policyNumber),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        Text(holder.policyType),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        _buildStatusBadge(holder.status),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        Text(
                                          DateFormat(
                                            'MM/dd/yyyy',
                                          ).format(holder.startDate),
                                        ),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        Text(
                                          DateFormat(
                                            'MM/dd/yyyy',
                                          ).format(holder.endDate),
                                        ),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        Text(
                                          '\$${holder.premium.toStringAsFixed(2)}',
                                        ),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        holder.hasApp
                                            ? Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  holder.lastLogin != null
                                                      ? _formatTimeAgo(
                                                        holder.lastLogin!,
                                                      )
                                                      : 'Never',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            )
                                            : InkWell(
                                              onTap:
                                                  () => _sendAppInvitation(
                                                    holder,
                                                  ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.send,
                                                    color: Colors.blue,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  const Text(
                                                    'Invite',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        Text(
                                          holder.totalClaims.toString(),
                                          style: TextStyle(
                                            color:
                                                holder.openClaims > 0
                                                    ? Colors.orange
                                                    : null,
                                            fontWeight:
                                                holder.openClaims > 0
                                                    ? FontWeight.bold
                                                    : null,
                                          ),
                                        ),
                                        onTap:
                                            () => _showPolicyHolderDetails(
                                              holder,
                                            ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () =>
                                                      _showPolicyHolderDetails(
                                                        holder,
                                                      ),
                                              tooltip: 'View Details',
                                              constraints:
                                                  const BoxConstraints(),
                                              padding: const EdgeInsets.all(8),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () =>
                                                      _showEditPolicyHolderDialog(
                                                        holder,
                                                      ),
                                              tooltip: 'Edit',
                                              constraints:
                                                  const BoxConstraints(),
                                              padding: const EdgeInsets.all(8),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.key,
                                                size: 20,
                                              ),
                                              onPressed:
                                                  () => _generateAccessCode(
                                                    holder,
                                                  ),
                                              tooltip: 'Generate Access Code',
                                              constraints:
                                                  const BoxConstraints(),
                                              padding: const EdgeInsets.all(8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  // Build status badge
  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Active':
        color = Colors.green;
        break;
      case 'Pending Renewal':
        color = Colors.orange;
        break;
      case 'Expired':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Format time ago helper
  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Show policy holder details dialog
  void _showPolicyHolderDetails(PolicyHolder holder) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${holder.name} Details'),
            content: SizedBox(
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildInfoRow('Policy Number', holder.policyNumber),
                            const SizedBox(height: 8),
                            _buildInfoRow('Email', holder.email),
                            const SizedBox(height: 8),
                            _buildInfoRow('Phone', holder.phone),
                            const SizedBox(height: 8),
                            _buildInfoRow('Address', holder.address),
                            const SizedBox(height: 8),
                            _buildInfoRow('Policy Type', holder.policyType),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Premium',
                              '\$${holder.premium.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Status', holder.status),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Policy Period',
                              '${DateFormat('MM/dd/yyyy').format(holder.startDate)} - ${DateFormat('MM/dd/yyyy').format(holder.endDate)}',
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'App Registered',
                              holder.hasApp ? 'Yes' : 'No',
                            ),
                            if (holder.hasApp && holder.lastLogin != null) ...[
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                'Last App Login',
                                DateFormat(
                                  'MM/dd/yyyy hh:mm a',
                                ).format(holder.lastLogin!),
                              ),
                            ],
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Total Claims',
                              holder.totalClaims.toString(),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Open Claims',
                              holder.openClaims.toString(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!holder.hasApp)
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _sendAppInvitation(holder);
                          },
                          icon: const Icon(Icons.send),
                          label: const Text('Send App Invitation'),
                        ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _generateAccessCode(holder);
                        },
                        icon: const Icon(Icons.key),
                        label: const Text('Generate Access Code'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showEditPolicyHolderDialog(holder);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E2A3A),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  // Build info row helper
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Show add policy holder dialog
  void _showAddPolicyHolderDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final policyNumberController = TextEditingController();
    String policyType = 'Homeowners';
    final startDateController = TextEditingController(
      text: DateFormat('MM/dd/yyyy').format(DateTime.now()),
    );
    final endDateController = TextEditingController(
      text: DateFormat(
        'MM/dd/yyyy',
      ).format(DateTime.now().add(const Duration(days: 365))),
    );
    final premiumController = TextEditingController();
    String status = 'Active';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Add New Policy Holder'),
                  content: SizedBox(
                    width: 800,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Full Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: policyNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'Policy Number',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: policyType,
                                  decoration: const InputDecoration(
                                    labelText: 'Policy Type',
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      [
                                            'Homeowners',
                                            'Renters',
                                            'Condo',
                                            'Auto',
                                            'Umbrella',
                                          ]
                                          .map(
                                            (type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      policyType = value!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: status,
                                  decoration: const InputDecoration(
                                    labelText: 'Status',
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      [
                                            'Active',
                                            'Pending',
                                            'Expired',
                                            'Cancelled',
                                          ]
                                          .map(
                                            (status) => DropdownMenuItem(
                                              value: status,
                                              child: Text(status),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      status = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: startDateController,
                                  decoration: const InputDecoration(
                                    labelText: 'Start Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        startDateController.text = DateFormat(
                                          'MM/dd/yyyy',
                                        ).format(date);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: endDateController,
                                  decoration: const InputDecoration(
                                    labelText: 'End Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                    if (date != null) {
                                      setState(() {
                                        endDateController.text = DateFormat(
                                          'MM/dd/yyyy',
                                        ).format(date);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: premiumController,
                                  decoration: const InputDecoration(
                                    labelText: 'Annual Premium',
                                    border: OutlineInputBorder(),
                                    prefixText: '\$',
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Validate inputs
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            phoneController.text.isEmpty ||
                            addressController.text.isEmpty ||
                            policyNumberController.text.isEmpty ||
                            premiumController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all required fields'),
                            ),
                          );
                          return;
                        }

                        // Create new policy holder object
                        final newPolicyHolder = PolicyHolder(
                          id: 'PH${_policyHolders.length + 1}',
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          address: addressController.text,
                          policyNumber: policyNumberController.text,
                          policyType: policyType,
                          startDate: DateFormat(
                            'MM/dd/yyyy',
                          ).parse(startDateController.text),
                          endDate: DateFormat(
                            'MM/dd/yyyy',
                          ).parse(endDateController.text),
                          premium: double.parse(premiumController.text),
                          status: status,
                          hasApp: false,
                          lastLogin: null,
                          totalClaims: 0,
                          openClaims: 0,
                        );

                        // Add to the list
                        setState(() {
                          _policyHolders.add(newPolicyHolder);
                        });

                        Navigator.pop(context);

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Policy holder added successfully'),
                          ),
                        );

                        // Generate access code automatically for the new policy holder
                        _generateAccessCode(newPolicyHolder);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E2A3A),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Policy Holder'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Edit policy holder dialog goes here - similar to add dialog but pre-populated

  void _showEditPolicyHolderDialog(PolicyHolder holder) {
    // Implementation similar to add dialog but pre-populated with holder data
  }

  // Generate access code for policy holder
  void _generateAccessCode(PolicyHolder holder) {
    // Generate a random 8-character alphanumeric code
    final random = StringBuffer();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    for (var i = 0; i < 8; i++) {
      random.write(chars[DateTime.now().microsecondsSinceEpoch % chars.length]);
    }
    final code = random.toString();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Access Code Generated'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('An access code has been generated for ${holder.name}:'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        code,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Access code copied to clipboard'),
                            ),
                          );
                        },
                        tooltip: 'Copy to Clipboard',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This code can be used to activate the My Personal Valuables app.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Send email with code
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Access code sent to ${holder.email}'),
                    ),
                  );
                },
                icon: const Icon(Icons.email),
                label: const Text('Email Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
    );
  }

  // Send app invitation
  void _sendAppInvitation(PolicyHolder holder) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Send App Invitation'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'An invitation to download the My Personal Valuables app will be sent to:',
                ),
                const SizedBox(height: 16),
                Text(
                  holder.email,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'The invitation will include instructions and an access code to activate the app.',
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
                  Navigator.pop(context);
                  // Send email with invitation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('App invitation sent to ${holder.email}'),
                    ),
                  );

                  // Generate access code automatically
                  _generateAccessCode(holder);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Send Invitation'),
              ),
            ],
          ),
    );
  }
}

// Policy holder model
class PolicyHolder {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String policyNumber;
  final String policyType;
  final DateTime startDate;
  final DateTime endDate;
  final double premium;
  final String status;
  final bool hasApp;
  final DateTime? lastLogin;
  final int totalClaims;
  final int openClaims;

  PolicyHolder({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.policyNumber,
    required this.policyType,
    required this.startDate,
    required this.endDate,
    required this.premium,
    required this.status,
    required this.hasApp,
    this.lastLogin,
    required this.totalClaims,
    required this.openClaims,
  });
}
