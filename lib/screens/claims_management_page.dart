import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_iq_pro/services/report_service.dart';
import 'claim_detail.dart';

class ClaimsManagementPage extends StatefulWidget {
  const ClaimsManagementPage({Key? key}) : super(key: key);

  @override
  _ClaimsManagementPageState createState() => _ClaimsManagementPageState();
}

class _ClaimsManagementPageState extends State<ClaimsManagementPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  List<Claim> _claims = [];
  String _searchQuery = '';
  String _filterStatus = 'All';
  String _sortBy = 'Date: Newest';
  String _selectedMetric = 'Claims'; // Add this variable declaration

  // Filter dates
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadClaims();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadClaims() {
    // Simulate loading from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _claims = [
          Claim(
            id: 'C001',
            policyNumber: 'POL-123456',
            clientName: 'John Smith',
            claimType: 'Theft',
            status: 'Submitted',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 5)),
            totalValue: 8500.00,
            items: [
              ClaimedItem(
                name: 'Laptop',
                value: 1200.00,
                category: 'Electronics',
              ),
              ClaimedItem(
                name: 'Camera',
                value: 800.00,
                category: 'Electronics',
              ),
              ClaimedItem(name: 'Watch', value: 500.00, category: 'Jewelry'),
            ],
            description: 'Items stolen from apartment during break-in.',
            attachments: ['police_report.pdf', 'receipt1.jpg', 'receipt2.jpg'],
          ),
          Claim(
            id: 'C002',
            policyNumber: 'POL-789012',
            clientName: 'Sarah Johnson',
            claimType: 'Water Damage',
            status: 'Reviewed',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 10)),
            totalValue: 4200.00,
            items: [
              ClaimedItem(name: 'Sofa', value: 1200.00, category: 'Furniture'),
              ClaimedItem(name: 'Rug', value: 800.00, category: 'Home Decor'),
              ClaimedItem(
                name: 'Books',
                value: 300.00,
                category: 'Personal Items',
              ),
            ],
            description: 'Water damage from upstairs neighbor\'s leaking pipe.',
            attachments: ['damage_photos.zip', 'plumber_report.pdf'],
          ),
          Claim(
            id: 'C003',
            policyNumber: 'POL-345678',
            clientName: 'Michael Brown',
            claimType: 'Fire',
            status: 'Approved',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 15)),
            totalValue: 12500.00,
            items: [
              ClaimedItem(name: 'TV', value: 1500.00, category: 'Electronics'),
              ClaimedItem(
                name: 'Dining Table',
                value: 1200.00,
                category: 'Furniture',
              ),
              ClaimedItem(
                name: 'Kitchenware',
                value: 800.00,
                category: 'Kitchen',
              ),
            ],
            description: 'Kitchen fire damaged several items in apartment.',
            attachments: ['fire_report.pdf', 'photos.zip'],
          ),
          Claim(
            id: 'C004',
            policyNumber: 'POL-901234',
            clientName: 'Jennifer Davis',
            claimType: 'Theft',
            status: 'Released',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 20)),
            totalValue: 3300.00,
            items: [
              ClaimedItem(name: 'Bicycle', value: 800.00, category: 'Sports'),
              ClaimedItem(
                name: 'Smartphone',
                value: 900.00,
                category: 'Electronics',
              ),
              ClaimedItem(
                name: 'Headphones',
                value: 200.00,
                category: 'Electronics',
              ),
            ],
            description: 'Items stolen from garage.',
            attachments: ['police_report.pdf', 'receipt_bike.pdf'],
          ),
          Claim(
            id: 'C005',
            policyNumber: 'POL-567890',
            clientName: 'Robert Wilson',
            claimType: 'Natural Disaster',
            status: 'Denied',
            dateSubmitted: DateTime.now().subtract(const Duration(days: 30)),
            totalValue: 22000.00,
            items: [
              ClaimedItem(
                name: 'Roof Damage',
                value: 15000.00,
                category: 'Structure',
              ),
              ClaimedItem(
                name: 'Furniture',
                value: 5000.00,
                category: 'Furniture',
              ),
              ClaimedItem(
                name: 'Electronics',
                value: 2000.00,
                category: 'Electronics',
              ),
            ],
            description: 'Damage caused by hurricane.',
            attachments: ['damage_photos.zip', 'contractor_estimate.pdf'],
          ),
        ];
        _isLoading = false;
      });
    });
  }

  // Get filtered and sorted claims
  List<Claim> get _filteredClaims {
    return _claims.where((claim) {
        // Filter by search query
        final matchesSearch =
            claim.clientName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            claim.policyNumber.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            claim.id.toLowerCase().contains(_searchQuery.toLowerCase());

        // Filter by status
        final matchesStatus =
            _filterStatus == 'All' || claim.status == _filterStatus;

        // Filter by date range
        bool matchesDateRange = true;
        if (_startDate != null) {
          matchesDateRange =
              matchesDateRange && !claim.dateSubmitted.isBefore(_startDate!);
        }
        if (_endDate != null) {
          // Add 1 day to include the end date fully
          final endDatePlusOne = _endDate!.add(const Duration(days: 1));
          matchesDateRange =
              matchesDateRange && claim.dateSubmitted.isBefore(endDatePlusOne);
        }

        return matchesSearch && matchesStatus && matchesDateRange;
      }).toList()
      ..sort((a, b) {
        // Sort based on selected option
        switch (_sortBy) {
          case 'Date: Newest':
            return b.dateSubmitted.compareTo(a.dateSubmitted);
          case 'Date: Oldest':
            return a.dateSubmitted.compareTo(b.dateSubmitted);
          case 'Value: Highest':
            return b.totalValue.compareTo(a.totalValue);
          case 'Value: Lowest':
            return a.totalValue.compareTo(b.totalValue);
          case 'Status':
            return a.status.compareTo(b.status);
          default:
            return b.dateSubmitted.compareTo(a.dateSubmitted);
        }
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
                    _buildHeader(),

                    const SizedBox(height: 24),

                    // Status cards
                    _buildStatusCards(),

                    const SizedBox(height: 24),

                    // Tab bar
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        tabs: const [
                          Tab(icon: Icon(Icons.list), text: 'Claims List'),
                          Tab(
                            icon: Icon(Icons.pie_chart),
                            text: 'Claims Overview',
                          ),
                        ],
                        labelColor: const Color(0xFF1E2A3A),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF1E2A3A),
                      ),
                    ),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Claims list tab
                          _buildClaimsListTab(),

                          // Claims overview tab
                          _buildClaimsOverviewTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewClaimDialog,
        backgroundColor: const Color(0xFF1E2A3A),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build header with search and filters
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Claims Management',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            // Search box
            SizedBox(
              width: 250,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search claims...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),

            // Date range filter
            OutlinedButton.icon(
              onPressed: _showDateRangeDialog,
              icon: const Icon(Icons.date_range),
              label: Text(
                _getDateRangeText(),
                style: const TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(width: 16),

            // Export buttons
            OutlinedButton.icon(
              onPressed: () {
                ReportService.exportClaimsToCsv(_claims);
              },
              icon: const Icon(Icons.download),
              label: const Text('Export CSV'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                ReportService.generateClaimsPdfReport(_claims, context);
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export PDF'),
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

  // Build status summary cards
  Widget _buildStatusCards() {
    final submitted = _claims.where((c) => c.status == 'Submitted').length;
    final reviewed = _claims.where((c) => c.status == 'Reviewed').length;
    final approved = _claims.where((c) => c.status == 'Approved').length;
    final released = _claims.where((c) => c.status == 'Released').length;
    final denied = _claims.where((c) => c.status == 'Denied').length;

    final totalValue = _claims.fold(
      0.0,
      (sum, claim) => sum + claim.totalValue,
    );
    final itemCount = _claims.fold(0, (sum, claim) => sum + claim.items.length);

    return Row(
      children: [
        _buildStatusCard(
          'Total Claims',
          _claims.length.toString(),
          Colors.blue,
          Icons.assignment,
        ),
        const SizedBox(width: 16),
        _buildStatusCard(
          'Submitted',
          submitted.toString(),
          Colors.orange,
          Icons.inventory,
        ),
        const SizedBox(width: 16),
        _buildStatusCard(
          'Reviewed',
          reviewed.toString(),
          Colors.purple,
          Icons.rate_review,
        ),
        const SizedBox(width: 16),
        _buildStatusCard(
          'Approved',
          approved.toString(),
          Colors.green,
          Icons.check_circle,
        ),
        const SizedBox(width: 16),
        _buildStatusCard(
          'Total Value',
          '\$${NumberFormat('#,###').format(totalValue)}',
          Colors.indigo,
          Icons.attach_money,
        ),
        const SizedBox(width: 16),
        _buildStatusCard(
          'Items Claimed',
          itemCount.toString(),
          Colors.teal,
          Icons.category,
        ),
      ],
    );
  }

  // Build a single status card
  Widget _buildStatusCard(
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
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

  // Build claims list tab
  Widget _buildClaimsListTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Filter and sort controls
        Row(
          children: [
            // Status filter
            DropdownButton<String>(
              value: _filterStatus,
              items: [
                const DropdownMenuItem(value: 'All', child: Text('All Status')),
                const DropdownMenuItem(
                  value: 'Submitted',
                  child: Text('Submitted'),
                ),
                const DropdownMenuItem(
                  value: 'Reviewed',
                  child: Text('Reviewed'),
                ),
                const DropdownMenuItem(
                  value: 'Approved',
                  child: Text('Approved'),
                ),
                const DropdownMenuItem(
                  value: 'Released',
                  child: Text('Released'),
                ),
                const DropdownMenuItem(value: 'Denied', child: Text('Denied')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _filterStatus = value;
                  });
                }
              },
              hint: const Text('Filter by Status'),
            ),
            const SizedBox(width: 24),

            // Sort dropdown
            DropdownButton<String>(
              value: _sortBy,
              items: [
                const DropdownMenuItem(
                  value: 'Date: Newest',
                  child: Text('Date: Newest'),
                ),
                const DropdownMenuItem(
                  value: 'Date: Oldest',
                  child: Text('Date: Oldest'),
                ),
                const DropdownMenuItem(
                  value: 'Value: Highest',
                  child: Text('Value: Highest'),
                ),
                const DropdownMenuItem(
                  value: 'Value: Lowest',
                  child: Text('Value: Lowest'),
                ),
                const DropdownMenuItem(value: 'Status', child: Text('Status')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _sortBy = value;
                  });
                }
              },
              hint: const Text('Sort by'),
            ),
            const Spacer(),

            // Showing results count
            Text(
              'Showing ${_filteredClaims.length} of ${_claims.length} claims',
              style: TextStyle(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Claims table
        Expanded(
          child:
              _filteredClaims.isEmpty
                  ? _buildEmptyState()
                  : _buildClaimsTable(),
        ),
      ],
    );
  }

  // Build empty state for no claims found
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No claims found',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterStatus = 'All';
                _startDate = null;
                _endDate = null;
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  // Build claims table
  Widget _buildClaimsTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
            dataRowHeight: 68,
            columns: const [
              DataColumn(label: Text('Claim ID')),
              DataColumn(label: Text('Policy Number')),
              DataColumn(label: Text('Client Name')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Date Submitted')),
              DataColumn(label: Text('Items'), numeric: true),
              DataColumn(label: Text('Total Value'), numeric: true),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ],
            rows:
                _filteredClaims.map((claim) {
                  return DataRow(
                    cells: [
                      DataCell(Text(claim.id)),
                      DataCell(Text(claim.policyNumber)),
                      DataCell(Text(claim.clientName)),
                      DataCell(Text(claim.claimType)),
                      DataCell(
                        Text(
                          DateFormat('MM/dd/yyyy').format(claim.dateSubmitted),
                        ),
                      ),
                      DataCell(Text(claim.items.length.toString())),
                      DataCell(
                        Text(
                          '\$${NumberFormat('#,##0.00').format(claim.totalValue)}',
                        ),
                      ),
                      DataCell(_buildStatusBadge(claim.status)),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 20),
                              onPressed: () => _viewClaimDetails(claim),
                              tooltip: 'View Details',
                              color: Colors.blue,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _editClaim(claim),
                              tooltip: 'Edit Claim',
                              color: Colors.orange,
                            ),
                            if (claim.status == 'Submitted' ||
                                claim.status == 'Reviewed')
                              IconButton(
                                icon: const Icon(Icons.check_circle, size: 20),
                                onPressed: () => _updateClaimStatus(claim),
                                tooltip: 'Change Status',
                                color: Colors.green,
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
    );
  }

  // Build claims overview tab
  Widget _buildClaimsOverviewTab() {
    // Calculate some statistics
    final claimsByType = <String, int>{};
    final valueByType = <String, double>{};

    for (final claim in _claims) {
      claimsByType[claim.claimType] = (claimsByType[claim.claimType] ?? 0) + 1;
      valueByType[claim.claimType] =
          (valueByType[claim.claimType] ?? 0) + claim.totalValue;
    }

    // Calculate monthly trends
    final monthlyData = <String, Map<String, dynamic>>{};

    for (final claim in _claims) {
      final month = DateFormat('MMM yyyy').format(claim.dateSubmitted);

      if (!monthlyData.containsKey(month)) {
        monthlyData[month] = {'count': 0, 'value': 0.0};
      }

      monthlyData[month]!['count'] = monthlyData[month]!['count'] + 1;
      monthlyData[month]!['value'] =
          monthlyData[month]!['value'] + claim.totalValue;
    }

    // Sort months chronologically
    final sortedMonths =
        monthlyData.keys.toList()..sort((a, b) {
          final aDate = DateFormat('MMM yyyy').parse(a);
          final bDate = DateFormat('MMM yyyy').parse(b);
          return aDate.compareTo(bDate);
        });

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column (charts)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTrendsCard(monthlyData, sortedMonths),
                const SizedBox(height: 24),
                _buildTopClaimsCard(),
              ],
            ),
          ),

          const SizedBox(width: 24),

          // Right column (statistics)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClaimsByTypeCard(claimsByType, valueByType),
                const SizedBox(height: 24),
                _buildClaimsByStatusCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build trends chart card
  Widget _buildTrendsCard(
    Map<String, Map<String, dynamic>> monthlyData,
    List<String> sortedMonths,
  ) {
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
                  'Claims Trend',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Add metric selection dropdown
                DropdownButton<String>(
                  value: _selectedMetric,
                  items: const [
                    DropdownMenuItem(value: 'Claims', child: Text('Count')),
                    DropdownMenuItem(value: 'Value', child: Text('Value')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedMetric = value;
                      });
                    }
                  },
                  underline: Container(height: 1, color: Colors.grey[300]),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Simple bar chart
            SizedBox(
              height: 250,
              child:
                  sortedMonths.isEmpty
                      ? const Center(child: Text('No data available'))
                      : _buildMonthlyTrendBars(monthlyData, sortedMonths),
            ),
          ],
        ),
      ),
    );
  }

  // Build monthly trend bars
  Widget _buildMonthlyTrendBars(
    Map<String, Map<String, dynamic>> monthlyData,
    List<String> sortedMonths,
  ) {
    // Find the max value for scaling
    double maxValue = 0;
    for (final month in sortedMonths) {
      final value =
          _selectedMetric == 'Claims'
              ? (monthlyData[month]!['count'] as num)
                  .toDouble() // Convert to double
              : (monthlyData[month]!['value'] as num)
                  .toDouble(); // Convert to double

      if (value > maxValue) {
        maxValue = value;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:
          sortedMonths.map((month) {
            final value =
                _selectedMetric == 'Claims'
                    ? (monthlyData[month]!['count'] as num)
                        .toDouble() // Convert to double
                    : (monthlyData[month]!['value'] as num)
                        .toDouble(); // Convert to double

            final percentage = value / maxValue;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 40,
                  height: 180 * percentage,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A3A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(month, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  _selectedMetric == 'Claims'
                      ? value.toInt().toString()
                      : '\$${NumberFormat('#,##0').format(value)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
    );
  }

  // Build top claims card
  Widget _buildTopClaimsCard() {
    // Sort claims by value (descending)
    final topClaims = List<Claim>.from(_claims)
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));

    // Take top 5
    final displayClaims = topClaims.take(5).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Claims by Value',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Data table
            displayClaims.isEmpty
                ? const Center(child: Text('No data available'))
                : DataTable(
                  headingRowHeight: 40,
                  dataRowHeight: 56,
                  columns: const [
                    DataColumn(label: Text('Client')),
                    DataColumn(label: Text('Claim Type')),
                    DataColumn(label: Text('Value'), numeric: true),
                    DataColumn(label: Text('Status')),
                  ],
                  rows:
                      displayClaims.map((claim) {
                        return DataRow(
                          cells: [
                            DataCell(Text(claim.clientName)),
                            DataCell(Text(claim.claimType)),
                            DataCell(
                              Text(
                                '\$${NumberFormat('#,##0.00').format(claim.totalValue)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(_buildStatusBadge(claim.status)),
                          ],
                        );
                      }).toList(),
                ),
          ],
        ),
      ),
    );
  }

  // Build claims by type card
  Widget _buildClaimsByTypeCard(
    Map<String, int> claimsByType,
    Map<String, double> valueByType,
  ) {
    // Sort types by count (descending)
    final sortedTypes =
        claimsByType.keys.toList()
          ..sort((a, b) => claimsByType[b]!.compareTo(claimsByType[a]!));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Claims by Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            sortedTypes.isEmpty
                ? const Center(child: Text('No data available'))
                : Column(
                  children:
                      sortedTypes.map((type) {
                        final count = claimsByType[type]!;
                        final value = valueByType[type]!;
                        final percentage = count / _claims.length * 100;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    type,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '$count claims (${percentage.toStringAsFixed(1)}%)',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getColorForClaimType(type),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total Value: \$${NumberFormat('#,##0.00').format(value)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
          ],
        ),
      ),
    );
  }

  // Build claims by status card
  Widget _buildClaimsByStatusCard() {
    // Count claims by status
    final statusCounts = <String, int>{};
    for (final claim in _claims) {
      statusCounts[claim.status] = (statusCounts[claim.status] ?? 0) + 1;
    }

    final statusOrder = [
      'Submitted',
      'Reviewed',
      'Approved',
      'Released',
      'Denied',
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Claims by Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Simple "pie chart" (just colored circles with legends)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'Placeholder\nFor Pie Chart',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        statusOrder.map((status) {
                          final count = statusCounts[status] ?? 0;
                          final percentage =
                              _claims.isNotEmpty
                                  ? count / _claims.length * 100
                                  : 0;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: _getColorForStatus(status),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(status),
                                const Spacer(),
                                Text(
                                  '${count.toString()} (${percentage.toStringAsFixed(1)}%)',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Status changes over time (placeholder)
            const Text(
              'Status Changes (Last 30 Days)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Status Change'),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Count'),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Avg. Time'),
                    ),
                  ],
                ),
                _buildStatusChangeRow('Submitted → Reviewed', 12, '2.3 days'),
                _buildStatusChangeRow('Reviewed → Approved', 10, '1.5 days'),
                _buildStatusChangeRow('Approved → Released', 8, '3.2 days'),
                _buildStatusChangeRow('Reviewed → Denied', 2, '4.1 days'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build status change table row
  TableRow _buildStatusChangeRow(String change, int count, String avgTime) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(change)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(count.toString()),
        ),
        Padding(padding: const EdgeInsets.all(8.0), child: Text(avgTime)),
      ],
    );
  }

  // Build status badge
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getColorForStatus(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getColorForStatus(status)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getColorForStatus(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // Get color for status
  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Submitted':
        return Colors.blue;
      case 'Reviewed':
        return Colors.orange;
      case 'Approved':
        return Colors.green;
      case 'Released':
        return Colors.purple;
      case 'Denied':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get color for claim type
  Color _getColorForClaimType(String type) {
    switch (type) {
      case 'Theft':
        return Colors.red;
      case 'Fire':
        return Colors.orange;
      case 'Water Damage':
        return Colors.blue;
      case 'Natural Disaster':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  // Format date range text
  String _getDateRangeText() {
    if (_startDate == null && _endDate == null) {
      return 'All Dates';
    } else if (_startDate != null && _endDate == null) {
      return 'From ${DateFormat('MM/dd/yyyy').format(_startDate!)}';
    } else if (_startDate == null && _endDate != null) {
      return 'Until ${DateFormat('MM/dd/yyyy').format(_endDate!)}';
    } else {
      return '${DateFormat('MM/dd/yyyy').format(_startDate!)} - ${DateFormat('MM/dd/yyyy').format(_endDate!)}';
    }
  }

  // Show date range dialog
  void _showDateRangeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Date Range'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Predefined ranges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('All Time'),
                      selected: _startDate == null && _endDate == null,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _startDate = null;
                            _endDate = null;
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Last 30 Days'),
                      selected: false, // Simplified
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _endDate = DateTime.now();
                            _startDate = _endDate!.subtract(
                              const Duration(days: 30),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Last 90 Days'),
                      selected: false, // Simplified
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _endDate = DateTime.now();
                            _startDate = _endDate!.subtract(
                              const Duration(days: 90),
                            );
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Year to Date'),
                      selected: false, // Simplified
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _endDate = DateTime.now();
                            _startDate = DateTime(_endDate!.year, 1, 1);
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Custom date range
                const Text(
                  'Custom Date Range',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Start date
                Row(
                  children: [
                    const Text('Start Date: '),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                      child: Text(
                        _startDate == null
                            ? 'Select Date'
                            : DateFormat('MM/dd/yyyy').format(_startDate!),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        setState(() {
                          _startDate = null;
                        });
                      },
                    ),
                  ],
                ),

                // End date
                Row(
                  children: [
                    const Text('End Date: '),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                          });
                        }
                      },
                      child: Text(
                        _endDate == null
                            ? 'Select Date'
                            : DateFormat('MM/dd/yyyy').format(_endDate!),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        setState(() {
                          _endDate = null;
                        });
                      },
                    ),
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
                  Navigator.pop(context);
                  // The state is already updated when selecting dates
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply'),
              ),
            ],
          ),
    );
  }

  // View claim details
  void _viewClaimDetails(Claim claim) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClaimDetailPage(claimId: claim.id),
      ),
    );
  }

  // Edit claim
  void _editClaim(Claim claim) {
    // In a real app, this would open a form to edit the claim
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Claim ${claim.id}'),
            content: const Text('Claim editing form would appear here'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  // Update claim status
  void _updateClaimStatus(Claim claim) {
    String newStatus;

    // Determine next logical status
    if (claim.status == 'Submitted') {
      newStatus = 'Reviewed';
    } else if (claim.status == 'Reviewed') {
      newStatus = 'Approved';
    } else {
      newStatus = claim.status;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Update Status for Claim ${claim.id}'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Status:'),
                const SizedBox(height: 8),
                _buildStatusBadge(claim.status),
                const SizedBox(height: 16),
                const Text('Select New Status:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: newStatus,
                  items: [
                    const DropdownMenuItem(
                      value: 'Submitted',
                      child: Text('Submitted'),
                    ),
                    const DropdownMenuItem(
                      value: 'Reviewed',
                      child: Text('Reviewed'),
                    ),
                    const DropdownMenuItem(
                      value: 'Approved',
                      child: Text('Approved'),
                    ),
                    const DropdownMenuItem(
                      value: 'Released',
                      child: Text('Released'),
                    ),
                    const DropdownMenuItem(
                      value: 'Denied',
                      child: Text('Denied'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      newStatus = value;
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes field for status change
                const Text('Notes (Optional):'),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter notes about this status change...',
                  ),
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
                  // Update claim status in state
                  setState(() {
                    final index = _claims.indexWhere((c) => c.id == claim.id);
                    if (index != -1) {
                      // In a real app, you'd create a new claim object or update the existing one
                      // Here we're simplifying by directly setting the status
                      // This is not ideal for immutable state management
                      _claims[index] = Claim(
                        id: claim.id,
                        policyNumber: claim.policyNumber,
                        clientName: claim.clientName,
                        claimType: claim.claimType,
                        status: newStatus,
                        dateSubmitted: claim.dateSubmitted,
                        totalValue: claim.totalValue,
                        items: claim.items,
                        description: claim.description,
                        attachments: claim.attachments,
                      );
                    }
                  });

                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Claim ${claim.id} status updated to $newStatus',
                      ),
                      backgroundColor: Colors.green,
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
    );
  }

  // Show new claim dialog
  void _showNewClaimDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create New Claim'),
            content: const SingleChildScrollView(
              child: Text(
                'In a real app, this would display a form to create a new claim',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This would create a new claim in a real app',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Create Claim'),
              ),
            ],
          ),
    );
  }
}

// Claim model class
class Claim {
  final String id;
  final String policyNumber;
  final String clientName;
  final String claimType;
  final String status;
  final DateTime dateSubmitted;
  final double totalValue;
  final List<ClaimedItem> items;
  final String description;
  final List<String> attachments;

  Claim({
    required this.id,
    required this.policyNumber,
    required this.clientName,
    required this.claimType,
    required this.status,
    required this.dateSubmitted,
    required this.totalValue,
    required this.items,
    required this.description,
    required this.attachments,
  });
}

// Claimed item model class
class ClaimedItem {
  final String name;
  final double value;
  final String category;

  ClaimedItem({
    required this.name,
    required this.value,
    required this.category,
  });
}
