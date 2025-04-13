import 'package:flutter/material.dart';

class UserManagementWidget extends StatefulWidget {
  const UserManagementWidget({Key? key}) : super(key: key);

  @override
  _UserManagementWidgetState createState() => _UserManagementWidgetState();
}

class _UserManagementWidgetState extends State<UserManagementWidget> {
  List<AppUser> _usersList = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _filterRole = 'All';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    // Simulate loading from an API
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _usersList = [
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
        _isLoading = false;
      });
    });
  }

  // Filtered users based on search and role filter
  List<AppUser> get _filteredUsers {
    return _usersList.where((user) {
      final matchesSearch =
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesRole = _filterRole == 'All' || user.role == _filterRole;

      return matchesSearch && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search and filter
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // Search box
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
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
                // Role filter
                DropdownButton<String>(
                  value: _filterRole,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Roles')),
                    DropdownMenuItem(
                      value: 'Administrator',
                      child: Text('Administrators'),
                    ),
                    DropdownMenuItem(value: 'Manager', child: Text('Managers')),
                    DropdownMenuItem(
                      value: 'Operator',
                      child: Text('Operators'),
                    ),
                    DropdownMenuItem(value: 'Viewer', child: Text('Viewers')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _filterRole = value;
                      });
                    }
                  },
                  underline: Container(height: 1, color: Colors.grey[300]),
                ),
                const SizedBox(width: 16),
                // Add user button
                ElevatedButton.icon(
                  onPressed: _showAddUserDialog,
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

            // Stats row
            Row(
              children: [
                _buildStatCard(
                  'Total Users',
                  _usersList.length.toString(),
                  Icons.people,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Administrators',
                  _usersList
                      .where((u) => u.role == 'Administrator')
                      .length
                      .toString(),
                  Icons.admin_panel_settings,
                  Colors.red,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Managers',
                  _usersList
                      .where((u) => u.role == 'Manager')
                      .length
                      .toString(),
                  Icons.manage_accounts,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Active',
                  _usersList.where((u) => u.isActive).length.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Users table
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredUsers.isEmpty
                      ? _buildEmptyState()
                      : _buildUsersTable(),
            ),

            // Bottom actions
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // Export users
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User list exported successfully'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Export Users'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Show role permissions dialog
                    _showRolePermissionsDialog();
                  },
                  icon: const Icon(Icons.security),
                  label: const Text('Manage Role Permissions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build stat card
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _filterRole = 'All';
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  // Build users table
  Widget _buildUsersTable() {
    return Column(
      children: [
        // Table header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              SizedBox(width: 48), // Avatar space
              Expanded(
                flex: 3,
                child: Text(
                  'User',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Role',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Last Login',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 120), // Actions
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Table content
        Expanded(
          child: ListView.separated(
            itemCount: _filteredUsers.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = _filteredUsers[index];
              return _buildUserRow(user);
            },
          ),
        ),
      ],
    );
  }

  // Build user row
  Widget _buildUserRow(AppUser user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            backgroundColor: const Color(0xFF1E2A3A),
            child: Text(
              user.name.substring(0, 1),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),

          // User info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),

          // Role
          Expanded(flex: 2, child: _buildRoleBadge(user.role)),

          // Status
          Expanded(
            flex: 2,
            child: Text(
              user.isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                color: user.isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Last login
          Expanded(
            flex: 2,
            child: Text(
              user.lastLogin != null
                  ? _formatTimeAgo(user.lastLogin!)
                  : 'Never',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),

          // Actions
          SizedBox(
            width: 120,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: () => _showEditUserDialog(user),
                  tooltip: 'Edit User',
                  color: Colors.blue,
                ),
                IconButton(
                  icon: const Icon(Icons.key, size: 18),
                  onPressed: () => _showResetPasswordDialog(user),
                  tooltip: 'Reset Password',
                  color: Colors.orange,
                ),
                IconButton(
                  icon: Icon(
                    user.isActive ? Icons.block : Icons.check_circle,
                    size: 18,
                    color: user.isActive ? Colors.red : Colors.green,
                  ),
                  onPressed: () => _toggleUserStatus(user),
                  tooltip: user.isActive ? 'Deactivate User' : 'Activate User',
                ),
              ],
            ),
          ),
        ],
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
                      id: 'U00${_usersList.length + 1}',
                      name: nameController.text,
                      email: emailController.text,
                      role: selectedRole,
                      lastLogin: null,
                      isActive: true,
                    );

                    setState(() {
                      _usersList.add(newUser);
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
                    final index = _usersList.indexWhere((u) => u.id == user.id);
                    if (index != -1) {
                      _usersList[index] = AppUser(
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
                    final index = _usersList.indexWhere((u) => u.id == user.id);
                    if (index != -1) {
                      _usersList[index] = AppUser(
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
                                  value: entry.value[role],
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
