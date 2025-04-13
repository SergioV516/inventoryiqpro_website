import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_iq_pro/services/report_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key? key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedDateRange = 'Last 30 Days';
  String _selectedMetric = 'Claims';
  bool _isLoading = true;

  // Sample data for analytics
  late List<Map<String, dynamic>> _monthlyClaimData;
  late Map<String, double> _claimsByType;
  late Map<String, double> _claimsByStatus;
  late List<Map<String, dynamic>> _topItems;
  late Map<String, dynamic> _keyMetrics;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  void _loadAnalyticsData() {
    // In a real app, this would come from your backend
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        // Monthly claims data for line chart
        _monthlyClaimData = [
          {'month': 'Jan', 'claims': 12, 'value': 8500},
          {'month': 'Feb', 'claims': 8, 'value': 5400},
          {'month': 'Mar', 'claims': 15, 'value': 12300},
          {'month': 'Apr', 'claims': 10, 'value': 7200},
          {'month': 'May', 'claims': 13, 'value': 9800},
          {'month': 'Jun', 'claims': 9, 'value': 6700},
        ];

        // Claims by type for pie chart
        _claimsByType = {
          'Theft': 28.0,
          'Fire': 12.0,
          'Water Damage': 22.0,
          'Natural Disaster': 8.0,
          'Other': 30.0,
        };

        // Claims by status for pie chart
        _claimsByStatus = {
          'Submitted': 40.0,
          'Reviewed': 25.0,
          'Approved': 20.0,
          'Released': 15.0,
        };

        // Top claimed items
        _topItems = [
          {'name': 'Television', 'count': 24, 'value': 32500},
          {'name': 'Laptop', 'count': 18, 'value': 27800},
          {'name': 'Jewelry', 'count': 15, 'value': 45200},
          {'name': 'Furniture', 'count': 12, 'value': 18400},
          {'name': 'Smartphone', 'count': 10, 'value': 12000},
        ];

        // Key metrics
        _keyMetrics = {
          'totalClaims': 67,
          'totalValue': 49800.0,
          'avgClaimValue': 743.3,
          'avgProcessingTime': 5.2, // days
          'approvalRate': 82.5, // percentage
        };

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
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with filters
                      _buildHeader(),

                      const SizedBox(height: 24),

                      // Key metrics cards
                      _buildKeyMetricsCards(),

                      const SizedBox(height: 24),

                      // Charts and tables
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height -
                            300, // Adjust height as needed
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left column
                            Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildSimpleTrendChart(),
                                    const SizedBox(height: 24),
                                    _buildTopItemsTable(),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 24),

                            // Right column
                            Expanded(
                              flex: 2,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildSimplePieChart(
                                      'Claims by Type',
                                      _claimsByType,
                                    ),
                                    const SizedBox(height: 24),
                                    _buildSimplePieChart(
                                      'Claims by Status',
                                      _claimsByStatus,
                                    ),
                                  ],
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

  // Build header with filters and export options
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Analytics & Reporting',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            // Date range filter
            DropdownButton<String>(
              value: _selectedDateRange,
              items:
                  [
                        'Last 30 Days',
                        'Last 90 Days',
                        'Last 6 Months',
                        'Last Year',
                        'All Time',
                      ]
                      .map(
                        (range) =>
                            DropdownMenuItem(value: range, child: Text(range)),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDateRange = value!;
                });
              },
              hint: const Text('Date Range'),
            ),
            const SizedBox(width: 16),

            // Metric selector
            DropdownButton<String>(
              value: _selectedMetric,
              items:
                  ['Claims', 'Value']
                      .map(
                        (metric) => DropdownMenuItem(
                          value: metric,
                          child: Text(metric),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMetric = value!;
                });
              },
              hint: const Text('Metric'),
            ),
            const SizedBox(width: 16),

            // Export buttons
            OutlinedButton.icon(
              onPressed: () {
                // Export CSV analytics data
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exporting analytics data to CSV...'),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Export CSV'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Generate analytics PDF report
                ReportService.generateAnalyticsPdfReport(
                  _keyMetrics,
                  _monthlyClaimData,
                  _claimsByType,
                  _topItems,
                  _selectedDateRange,
                  context,
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Generate Report'),
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

  // Build key metrics cards
  Widget _buildKeyMetricsCards() {
    return Row(
      children: [
        _buildMetricCard(
          'Total Claims',
          _keyMetrics['totalClaims'].toString(),
          Colors.blue,
          Icons.insert_drive_file,
        ),
        const SizedBox(width: 16),
        _buildMetricCard(
          'Total Value',
          '\$${NumberFormat('#,###').format(_keyMetrics['totalValue'])}',
          Colors.green,
          Icons.attach_money,
        ),
        const SizedBox(width: 16),
        _buildMetricCard(
          'Avg. Claim Value',
          '\$${_keyMetrics['avgClaimValue'].toStringAsFixed(2)}',
          Colors.orange,
          Icons.calculate,
        ),
        const SizedBox(width: 16),
        _buildMetricCard(
          'Avg. Processing Time',
          '${_keyMetrics['avgProcessingTime']} days',
          Colors.purple,
          Icons.timer,
        ),
        const SizedBox(width: 16),
        _buildMetricCard(
          'Approval Rate',
          '${_keyMetrics['approvalRate']}%',
          Colors.teal,
          Icons.check_circle,
        ),
      ],
    );
  }

  // Build a single metric card
  Widget _buildMetricCard(
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

  // Build a simplified trend chart
  Widget _buildSimpleTrendChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedMetric == 'Claims'
                  ? 'Claims Trend'
                  : 'Claims Value Trend',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: 600,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _buildMonthlyTrendBars(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build monthly trend bars
  Widget _buildMonthlyTrendBars() {
    // Find the max value for scaling
    double maxValue = 0;
    for (var month in _monthlyClaimData) {
      final value =
          _selectedMetric == 'Claims'
              ? month['claims'].toDouble()
              : month['value'].toDouble();
      if (value > maxValue) {
        maxValue = value;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children:
          _monthlyClaimData.map((month) {
            final value =
                _selectedMetric == 'Claims'
                    ? double.parse(month['claims'].toString())
                    : double.parse(month['value'].toString());
            final percentage = value / maxValue;

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 30,
                  height: 160 * percentage,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A3A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Text(month['month'], style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
    );
  }

  // Build a simplified pie chart
  Widget _buildSimplePieChart(String title, Map<String, double> data) {
    // Determine colors for the pie chart
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Pie Chart',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        data.entries.map((entry) {
                          final index = data.keys.toList().indexOf(entry.key);
                          final color = colors[index % colors.length];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${entry.value.toStringAsFixed(1)}%',
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
          ],
        ),
      ),
    );
  }

  // Build top items table
  Widget _buildTopItemsTable() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Claimed Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Item')),
                  DataColumn(label: Text('Count'), numeric: true),
                  DataColumn(label: Text('Total Value'), numeric: true),
                  DataColumn(label: Text('Avg. Value'), numeric: true),
                ],
                rows:
                    _topItems.map((item) {
                      final avgValue = item['value'] / item['count'];
                      return DataRow(
                        cells: [
                          DataCell(Text(item['name'])),
                          DataCell(Text(item['count'].toString())),
                          DataCell(
                            Text(
                              '\$${NumberFormat('#,###').format(item['value'])}',
                            ),
                          ),
                          DataCell(Text('\$${avgValue.toStringAsFixed(2)}')),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
