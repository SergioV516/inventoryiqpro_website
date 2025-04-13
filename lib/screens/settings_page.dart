import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_iq_pro/widgets/user_management_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Company settings
  final _companyNameController = TextEditingController(text: 'InventoryIQ Pro');
  final _emailController = TextEditingController(
    text: 'support@inventoryiqpro.com',
  );
  final _phoneController = TextEditingController(text: '(555) 123-4567');
  final _addressController = TextEditingController(
    text: '123 Insurance Blvd, Suite 500, New York, NY 10001',
  );

  // App settings
  bool _enableNotifications = true;
  bool _enableDarkMode = false;
  bool _enableAutoBackup = true;
  String _defaultCurrency = 'USD';
  String _dateFormat = 'MM/DD/YYYY';

  // Email settings
  bool _sendWelcomeEmail = true;
  bool _sendClaimUpdateEmail = true;
  bool _sendPaymentNotifications = true;
  final _emailTemplateController = TextEditingController(
    text:
        'Dear {name},\n\nThank you for choosing InventoryIQ Pro for your property inventory management needs.\n\nBest regards,\nThe InventoryIQ Team',
  );

  // API settings
  final _apiKeyController = TextEditingController(
    text: 'sk_test_123456789abcdef',
  );
  bool _showApiKey = false;

  // User management
  List<AppUser> _users = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUsers();
  }

  void _loadUsers() {
    // Simulate loading from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _users = [
          AppUser(
            id: 'U001',
            name: 'John Admin',
            email: 'john.admin@example.com',
            role: 'Administrator',
            lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
            isActive: true,
          ),
          AppUser(
            id: 'U002',
            name: 'Sarah Manager',
            email: 'sarah.manager@example.com',
            role: 'Manager',
            lastLogin: DateTime.now().subtract(const Duration(days: 1)),
            isActive: true,
          ),
          AppUser(
            id: 'U003',
            name: 'Mike Operator',
            email: 'mike.operator@example.com',
            role: 'Operator',
            lastLogin: DateTime.now().subtract(const Duration(days: 3)),
            isActive: true,
          ),
          AppUser(
            id: 'U004',
            name: 'Lisa Viewer',
            email: 'lisa.viewer@example.com',
            role: 'Viewer',
            lastLogin: DateTime.now().subtract(const Duration(days: 5)),
            isActive: false,
          ),
        ];
      });
    });
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailTemplateController.dispose();
    _apiKeyController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call to save settings
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 16),
                Text('Settings saved successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                // Import settings
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Import Settings'),
                                        content: const Text(
                                          'Are you sure you want to import settings? This will overwrite your current settings.',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              // In a real app, you would import settings here
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Settings imported successfully',
                                                  ),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF1E2A3A,
                                              ),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Import'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Import Settings'),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                // Export settings
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Settings exported successfully',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Export Settings'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton.icon(
                              onPressed: _saveSettings,
                              icon: const Icon(Icons.save),
                              label: const Text('Save Changes'),
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

                  // Tab bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
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
                          Tab(
                            icon: Icon(Icons.settings),
                            text: 'Application Settings',
                          ),
                          Tab(
                            icon: Icon(Icons.people),
                            text: 'User Management',
                          ),
                        ],
                        labelColor: const Color(0xFF1E2A3A),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF1E2A3A),
                      ),
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Application Settings Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Settings sections in a two-column layout
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left column
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildCompanySettingsSection(),
                                          const SizedBox(height: 24),
                                          _buildAppSettingsSection(),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 24),

                                    // Right column
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildEmailSettingsSection(),
                                          const SizedBox(height: 24),
                                          _buildApiSettingsSection(),
                                          const SizedBox(height: 24),
                                          _buildBackupSection(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // User Management Tab
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildUserManagementSection()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  // Company settings section
  Widget _buildCompanySettingsSection() {
    return _buildSettingsCard(
      'Company Information',
      Icons.business,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _companyNameController,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter company name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Upload company logo
                },
                icon: const Icon(Icons.upload),
                label: const Text('Upload Logo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  // Preview on documents
                },
                icon: const Icon(Icons.visibility),
                label: const Text('Preview on Documents'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // App settings section
  Widget _buildAppSettingsSection() {
    return _buildSettingsCard(
      'Application Settings',
      Icons.settings,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Send app notifications for important events'),
            value: _enableNotifications,
            onChanged: (value) {
              setState(() {
                _enableNotifications = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme for the application'),
            value: _enableDarkMode,
            onChanged: (value) {
              setState(() {
                _enableDarkMode = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Automatic Backup'),
            subtitle: const Text('Auto backup data daily'),
            value: _enableAutoBackup,
            onChanged: (value) {
              setState(() {
                _enableAutoBackup = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Default Currency',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _defaultCurrency,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'USD',
                            child: Text('USD ()'),
                          ),
                          const DropdownMenuItem(
                            value: 'EUR',
                            child: Text('EUR (€)'),
                          ),
                          const DropdownMenuItem(
                            value: 'GBP',
                            child: Text('GBP (£)'),
                          ),
                          //
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _defaultCurrency = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Date Format', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _dateFormat,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: 'MM/DD/YYYY',
                            child: Text('MM/DD/YYYY'),
                          ),
                          const DropdownMenuItem(
                            value: 'DD/MM/YYYY',
                            child: Text('DD/MM/YYYY'),
                          ),
                          const DropdownMenuItem(
                            value: 'YYYY-MM-DD',
                            child: Text('YYYY-MM-DD'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _dateFormat = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Clear application cache
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Application cache cleared')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
            ),
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  // Email settings section
  Widget _buildEmailSettingsSection() {
    return _buildSettingsCard(
      'Email Notifications',
      Icons.email,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            title: const Text('Welcome Email'),
            subtitle: const Text('Send welcome email to new policy holders'),
            value: _sendWelcomeEmail,
            onChanged: (value) {
              setState(() {
                _sendWelcomeEmail = value!;
              });
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(),
          CheckboxListTile(
            title: const Text('Claim Updates'),
            subtitle: const Text('Send email when claim status changes'),
            value: _sendClaimUpdateEmail,
            onChanged: (value) {
              setState(() {
                _sendClaimUpdateEmail = value!;
              });
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(),
          CheckboxListTile(
            title: const Text('Payment Notifications'),
            subtitle: const Text('Send email when payments are processed'),
            value: _sendPaymentNotifications,
            onChanged: (value) {
              setState(() {
                _sendPaymentNotifications = value!;
              });
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 16),
          const Text(
            'Default Email Template',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailTemplateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter default email template...',
            ),
            maxLines: 6,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(
                label: const Text('{name}'),
                backgroundColor: Colors.blue[50],
                onDeleted: null,
              ),
              Chip(
                label: const Text('{policy_number}'),
                backgroundColor: Colors.blue[50],
                onDeleted: null,
              ),
              Chip(
                label: const Text('{date}'),
                backgroundColor: Colors.blue[50],
                onDeleted: null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Test email functionality
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Test email sent')));
            },
            icon: const Icon(Icons.send),
            label: const Text('Send Test Email'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // API settings section
  Widget _buildApiSettingsSection() {
    return _buildSettingsCard(
      'API Settings',
      Icons.api,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('API Key', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _apiKeyController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _showApiKey ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _showApiKey = !_showApiKey;
                      });
                    },
                    tooltip: _showApiKey ? 'Hide' : 'Show',
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: _apiKeyController.text),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('API key copied to clipboard'),
                        ),
                      );
                    },
                    tooltip: 'Copy',
                  ),
                ],
              ),
            ),
            obscureText: !_showApiKey,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Generate new API key
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Generate New API Key'),
                          content: const Text(
                            'Are you sure you want to generate a new API key? The current key will be invalidated.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _apiKeyController.text =
                                      'sk_live_' +
                                      DateTime.now().millisecondsSinceEpoch
                                          .toString()
                                          .substring(0, 10);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('New API key generated'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2A3A),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Generate'),
                            ),
                          ],
                        ),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Generate New Key'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  // Open API docs
                },
                icon: const Icon(Icons.article),
                label: const Text('View API Documentation'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Rate Limiting'),
            subtitle: const Text('100 requests per minute'),
            trailing: TextButton(
              onPressed: () {
                // Upgrade plan
              },
              child: const Text('Upgrade'),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Webhook URL'),
            subtitle: const Text('https://your-domain.com/api/webhook'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Edit webhook URL
              },
            ),
          ),
        ],
      ),
    );
  }

  // Backup & restore section
  Widget _buildBackupSection() {
    return _buildSettingsCard(
      'Backup & Restore',
      Icons.backup,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Last Backup'),
            subtitle: const Text('March 24, 2025 - 11:42 PM'),
            trailing: Text(
              'Manual',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Backup Schedule'),
            subtitle: const Text('Daily at 12:00 AM'),
            trailing: Switch(
              value: _enableAutoBackup,
              onChanged: (value) {
                setState(() {
                  _enableAutoBackup = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Create backup now
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Backup in Progress'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 24),
                                const Text('Creating backup file...'),
                              ],
                            ),
                          ),
                    );

                    // Simulate backup operation
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 16),
                              Text('Backup created successfully'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.backup),
                  label: const Text('Backup Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Restore from backup
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text('Restore'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Storage Location'),
            subtitle: const Text('Google Drive'),
            trailing: TextButton(
              onPressed: () {
                // Change storage location
              },
              child: const Text('Change'),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Retention Policy'),
            subtitle: const Text('Keep last 10 backups'),
            trailing: TextButton(
              onPressed: () {
                // Edit retention policy
              },
              child: const Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }

  // User management section
  Widget _buildUserManagementSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2A3A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.people, color: Color(0xFF1E2A3A)),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'User Management',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Instead of using our own implementation, we'll use the UserManagementWidget's method
                    // This is just a stub since we're using the dedicated widget now
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Use the User Management Widget for full functionality',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2A3A),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Replace the direct user management code with the UserManagementWidget
            const Expanded(child: UserManagementWidget()),
          ],
        ),
      ),
    );
  }

  // Helper method to build settings card
  Widget _buildSettingsCard(String title, IconData icon, Widget content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2A3A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: const Color(0xFF1E2A3A)),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            content,
          ],
        ),
      ),
    );
  }

  // Show add user dialog
  void _showAddUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'Operator';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New User'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ['Administrator', 'Manager', 'Operator', 'Viewer']
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedRole = value;
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate
                  if (nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty) {
                    // Add user
                    final newUser = AppUser(
                      id: 'U00${_users.length + 1}',
                      name: nameController.text,
                      email: emailController.text,
                      role: selectedRole,
                      lastLogin: null,
                      isActive: true,
                    );

                    setState(() {
                      _users.add(newUser);
                    });

                    Navigator.pop(context);

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User added successfully')),
                    );
                  } else {
                    // Show validation error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add User'),
              ),
            ],
          ),
    );
  }

  // Show edit user dialog
  void _showEditUserDialog(AppUser user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    String selectedRole = user.role;
    bool isActive = user.isActive;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit ${user.name}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: const InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ['Administrator', 'Manager', 'Operator', 'Viewer']
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedRole = value;
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Active Status'),
                    value: isActive,
                    onChanged: (value) {
                      isActive = value;
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Update user
                  setState(() {
                    final index = _users.indexWhere((u) => u.id == user.id);
                    if (index != -1) {
                      _users[index] = AppUser(
                        id: user.id,
                        name: nameController.text,
                        email: emailController.text,
                        role: selectedRole,
                        lastLogin: user.lastLogin,
                        isActive: isActive,
                      );
                    }
                  });

                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User updated successfully')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
    );
  }

  // Show reset password dialog
  void _showResetPasswordDialog(AppUser user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Reset Password for ${user.name}'),
            content: const Text(
              'Are you sure you want to reset the password for this user? They will receive an email with instructions to set a new password.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Simulate password reset
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Password reset email sent to ${user.email}',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset Password'),
              ),
            ],
          ),
    );
  }

  // Toggle user active status
  void _toggleUserStatus(AppUser user) {
    final newStatus = !user.isActive;
    final statusText = newStatus ? 'activate' : 'deactivate';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('${newStatus ? 'Activate' : 'Deactivate'} User'),
            content: Text('Are you sure you want to $statusText ${user.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final index = _users.indexWhere((u) => u.id == user.id);
                    if (index != -1) {
                      _users[index] = AppUser(
                        id: user.id,
                        name: user.name,
                        email: user.email,
                        role: user.role,
                        lastLogin: user.lastLogin,
                        isActive: newStatus,
                      );
                    }
                  });
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'User ${newStatus ? 'activated' : 'deactivated'} successfully',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: newStatus ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(newStatus ? 'Activate' : 'Deactivate'),
              ),
            ],
          ),
    );
  }

  // Show role permissions dialog
  void _showRolePermissionsDialog() {
    // Define permissions matrix
    final permissions = {
      'Dashboard': {
        'Administrator': true,
        'Manager': true,
        'Operator': true,
        'Viewer': true,
      },
      'Policy Holders - View': {
        'Administrator': true,
        'Manager': true,
        'Operator': true,
        'Viewer': true,
      },
      'Policy Holders - Edit': {
        'Administrator': true,
        'Manager': true,
        'Operator': true,
        'Viewer': false,
      },
      'Claims - View': {
        'Administrator': true,
        'Manager': true,
        'Operator': true,
        'Viewer': true,
      },
      'Claims - Edit': {
        'Administrator': true,
        'Manager': true,
        'Operator': true,
        'Viewer': false,
      },
      'Claims - Approve': {
        'Administrator': true,
        'Manager': true,
        'Operator': false,
        'Viewer': false,
      },
      'Analytics': {
        'Administrator': true,
        'Manager': true,
        'Operator': false,
        'Viewer': false,
      },
      'Settings': {
        'Administrator': true,
        'Manager': false,
        'Operator': false,
        'Viewer': false,
      },
      'User Management': {
        'Administrator': true,
        'Manager': false,
        'Operator': false,
        'Viewer': false,
      },
    };

    final roles = ['Administrator', 'Manager', 'Operator', 'Viewer'];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Role Permissions'),
            content: SizedBox(
              width: 600,
              height: 400,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    const DataColumn(label: Text('Permission')),
                    ...roles.map((role) => DataColumn(label: Text(role))),
                  ],
                  rows:
                      permissions.entries.map((entry) {
                        return DataRow(
                          cells: [
                            DataCell(Text(entry.key)),
                            ...roles.map(
                              (role) => DataCell(
                                Checkbox(
                                  value:
                                      entry.value[role]
                                          as bool, // Fix: Explicitly cast to bool
                                  onChanged:
                                      role == 'Administrator'
                                          ? null // Administrator always has all permissions
                                          : (value) {
                                            // In a real app, you would update the permissions
                                            // This is just a UI demonstration
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Permission settings would be saved in a real app',
                                                ),
                                              ),
                                            );
                                          },
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Save permissions (in a real app)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Role permissions saved successfully'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2A3A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
    );
  }

  // Build role badge helper
  Widget _buildRoleBadge(String role) {
    Color color;
    switch (role) {
      case 'Administrator':
        color = Colors.red;
        break;
      case 'Manager':
        color = Colors.orange;
        break;
      case 'Operator':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        role,
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
}

// User model
class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final DateTime? lastLogin;
  final bool isActive;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.lastLogin,
    required this.isActive,
  });
}
