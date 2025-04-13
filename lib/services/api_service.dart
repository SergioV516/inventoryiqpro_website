// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'https://app.inventoryiqpro.com/v1/api.php';

  // Get the token from local storage
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Save the token to local storage
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove the token from local storage (logout)
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Get headers for authenticated requests
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _saveToken(responseData['token']);
      return responseData;
    } else {
      throw Exception(responseData['error'] ?? 'Login failed');
    }
  }

  // Logout
  Future<void> logout() async {
    await _removeToken();
  }

  // Get claims
  Future<List<dynamic>> getClaims() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/claims'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['claims'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load claims');
    }
  }

  // Get claim details
  Future<Map<String, dynamic>> getClaimDetails(String claimId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/claims/$claimId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['claim'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load claim details');
    }
  }

  // Create claim
  Future<Map<String, dynamic>> createClaim(
    Map<String, dynamic> claimData,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/claims'),
      headers: headers,
      body: jsonEncode(claimData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to create claim');
    }
  }

  // Update claim status
  Future<void> updateClaimStatus(
    String claimId,
    String newStatus, {
    String? notes,
  }) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/claims/$claimId/status'),
      headers: headers,
      body: jsonEncode({'new_status': newStatus, 'notes': notes}),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to update claim status');
    }
  }

  // Process payment
  Future<Map<String, dynamic>> processPayment(
    String claimId,
    double amount,
    String paymentMethod,
    String paymentNote,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/claims/$claimId/payment'),
      headers: headers,
      body: jsonEncode({
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_note': paymentNote,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to process payment');
    }
  }

  // Get policy holders
  Future<List<dynamic>> getPolicyHolders() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/policy-holders'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['policy_holders'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load policy holders');
    }
  }

  // Create policy holder
  Future<Map<String, dynamic>> createPolicyHolder(
    Map<String, dynamic> policyData,
  ) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/policy-holders'),
      headers: headers,
      body: jsonEncode(policyData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to create policy holder');
    }
  }

  // Get analytics
  Future<Map<String, dynamic>> getAnalytics(String dateRange) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/analytics?date_range=$dateRange'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load analytics');
    }
  }

  // Get recent claims
  Future<List<Map<String, dynamic>>> getRecentClaims() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/claims/recent'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success' &&
          responseData['claims'] != null) {
        return List<Map<String, dynamic>>.from(responseData['claims']);
      }
      return [];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load recent claims');
    }
  }

  // Mark claims as read
  Future<bool> markClaimsAsRead() async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/claims/mark-read'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['status'] == 'success';
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to mark claims as read');
    }
  }

  // Get My Personal Valuables integration status
  Future<Map<String, dynamic>> getMPVIntegrationStatus() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/integrations/mpv/status'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
        errorData['error'] ?? 'Failed to get MPV integration status',
      );
    }
  }

  // Configure My Personal Valuables integration
  Future<bool> configureMPVIntegration(Map<String, dynamic> configData) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/integrations/mpv/configure'),
      headers: headers,
      body: jsonEncode(configData),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['status'] == 'success';
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
        errorData['error'] ?? 'Failed to configure MPV integration',
      );
    }
  }

  // Generate API key for My Personal Valuables integration
  Future<String> generateMPVApiKey() async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/integrations/mpv/generate-key'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success' &&
          responseData['api_key'] != null) {
        return responseData['api_key'];
      }
      throw Exception('Failed to generate API key');
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to generate API key');
    }
  }

  // Get claims from My Personal Valuables
  Future<List<dynamic>> getMPVClaims() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/claims/external/mpv'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success' &&
          responseData['claims'] != null) {
        return responseData['claims'];
      }
      return [];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'Failed to load MPV claims');
    }
  }
}
