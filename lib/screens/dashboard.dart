import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:inventory_iq_pro/services/report_service.dart';
import 'claim_detail.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  List<Claim> claims = [];
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Simulate loading from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        claims = [
          Claim(
            id: 'C001',
            policyNumber: 'POL-123456',
            userName: 'John Smith',
            contact: 'john.smith@email.com',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 5)),
            status: 'Submitted',
            items: 12,
            value: 8500.00,
          ),
          Claim(
            id: 'C002',
            policyNumber: 'POL-789012',
            userName: 'Sarah Johnson',
            contact: '555-123-4567',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 10)),
            status: 'Reviewed',
            items: 8,
            value: 4200.00,
          ),
          Claim(
            id: 'C003',
            policyNumber: 'POL-345678',
            userName: 'Michael Brown',
            contact: 'michael.b@email.com',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 15)),
            status: 'Approved',
            items: 5,
            value: 3100.00,
          ),
          Claim(
            id: 'C004',
            policyNumber: 'POL-901234',
            userName: 'Jennifer Davis',
            contact: '555-987-6543',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 20)),
            status: 'Released',
            items: 17,
            value: 12500.00,
          ),
        ];
        _isLoading = false;
      });
    });
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
                    // Header section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Claims Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                ReportService.exportClaimsToCsv(claims);
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Export CSV'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                ReportService.generateClaimsPdfReport(
                                  claims,
                                  context,
                                );
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('Export PDF'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Add new policy holder functionality
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
                    ),

                    const SizedBox(height: 24),

                    // Summary Cards
                    _buildSummaryCards(),

                    const SizedBox(height: 24),

                    // Two-column layout for table and charts
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Claims table (left column)
                          Expanded(flex: 3, child: _buildClaimsTable()),
                          const SizedBox(width: 24),
                          // Right column with pie chart and activity feed
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                _buildStatusPieChart(),
                                const SizedBox(height: 24),
                                Expanded(child: _buildRecentActivity()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  // Build summary cards widget
  Widget _buildSummaryCards() {
    final pendingReview = claims.where((c) => c.status == 'Submitted').length;
    final approved = claims.where((c) => c.status == 'Approved').length;
    final totalValue = claims.fold(0.0, (sum, claim) => sum + claim.value);

    return Row(
      children: [
        _buildSummaryCard(
          'Total Claims',
          claims.length.toString(),
          Colors.blue,
          Icons.insert_drive_file,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Pending Review',
          pendingReview.toString(),
          Colors.orange,
          Icons.pending_actions,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Approved',
          approved.toString(),
          Colors.green,
          Icons.check_circle,
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          'Total Value',
          '\$${totalValue.toStringAsFixed(2)}',
          Colors.purple,
          Icons.attach_money,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build claims table widget
  Widget _buildClaimsTable() {
    // Filtered claims based on selected status
    final filteredClaims =
        _filterStatus == 'All'
            ? claims
            : claims.where((claim) => claim.status == _filterStatus).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with filter dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Claims',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _filterStatus,
                  items:
                      ['All', 'Submitted', 'Reviewed', 'Approved', 'Released']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _filterStatus = value!;
                    });
                  },
                  hint: const Text('Filter by Status'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  filteredClaims.isEmpty
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
                              'No claims found matching "$_filterStatus" filter',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _filterStatus = 'All';
                                });
                              },
                              child: const Text('Clear Filter'),
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
                              DataColumn(label: Text('Policy Number')),
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Contact')),
                              DataColumn(label: Text('Submission Date')),
                              DataColumn(label: Text('Items'), numeric: true),
                              DataColumn(label: Text('Value'), numeric: true),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows:
                                filteredClaims.map((claim) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(claim.policyNumber)),
                                      DataCell(Text(claim.userName)),
                                      DataCell(Text(claim.contact)),
                                      DataCell(
                                        Text(
                                          DateFormat(
                                            'MM/dd/yyyy',
                                          ).format(claim.dateSubmitted),
                                        ),
                                      ),
                                      DataCell(Text(claim.items.toString())),
                                      DataCell(
                                        Text(
                                          '\$${claim.value.toStringAsFixed(2)}',
                                        ),
                                      ),
                                      DataCell(_buildStatusBadge(claim.status)),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.visibility,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                // Navigate to claim details
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            ClaimDetailPage(
                                                              claimId: claim.id,
                                                            ),
                                                  ),
                                                );
                                              },
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
                                              onPressed: () {
                                                // Edit functionality
                                              },
                                              tooltip: 'Edit',
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

  // Build status pie chart widget
  Widget _buildStatusPieChart() {
    // Count claims by status
    final Map<String, int> statusCounts = {};
    for (final claim in claims) {
      statusCounts[claim.status] = (statusCounts[claim.status] ?? 0) + 1;
    }

    final List<String> statusNames = [
      'Submitted',
      'Reviewed',
      'Approved',
      'Released',
    ];
    final List<Color> statusColors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Claims by Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Pie Chart',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...statusNames.map((status) {
              final count = statusCounts[status] ?? 0;
              final index = statusNames.indexOf(status);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: statusColors[index],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$status ($count)',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Build recent activity widget
  Widget _buildRecentActivity() {
    final activities = [
      {
        'message': 'Claim POL-123456 reviewed',
        'user': 'Jane Operator',
        'time': '1h ago',
      },
      {
        'message': 'New policy holder registered',
        'user': 'System',
        'time': '3h ago',
      },
      {
        'message': 'Claim POL-901234 payment released',
        'user': 'John Manager',
        'time': '5h ago',
      },
      {
        'message': 'Access code generated for new policy',
        'user': 'Jane Operator',
        'time': '6h ago',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6, right: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['message']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    activity['user']!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '• ${activity['time']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  // View all activity
                },
                child: const Text('View All Activity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Claim model class
class Claim {
  final String id;
  final String policyNumber;
  final String userName;
  final String contact;
  final DateTime dateSubmitted;
  final String status;
  final int items;
  final double value;

  Claim({
    required this.id,
    required this.policyNumber,
    required this.userName,
    required this.contact,
    required this.dateSubmitted,
    required this.status,
    required this.items,
    required this.value,
  });
}
