import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_iq_pro/models/claim.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClaimService {
  static const String baseUrl = 'https://app.inventoryiqpro.com/v1/api.php';

  // Get all claims
  static Future<List<Claim>> getAllClaims() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/claims'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success' && data['claims'] != null) {
        return List<Claim>.from(
          data['claims'].map((claim) => Claim.fromJson(claim)),
        );
      }

      return [];
    } else {
      throw Exception('Failed to load claims');
    }
  }

  // Get recent claims
  static Future<List<Map<String, dynamic>>> getRecentClaims() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/claims/recent'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success' && data['claims'] != null) {
        return List<Map<String, dynamic>>.from(data['claims']);
      }

      return [];
    } else {
      throw Exception('Failed to load recent claims');
    }
  }

  // Mark all claims as read
  static Future<bool> markClaimsAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/claims/mark-read'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['status'] == 'success';
    } else {
      throw Exception('Failed to mark claims as read');
    }
  }

  // Get a specific claim by ID
  static Future<Claim?> getClaimById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/claims/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success' && data['claim'] != null) {
        return Claim.fromJson(data['claim']);
      }

      return null;
    } else {
      throw Exception('Failed to load claim details');
    }
  }

  // Create a new claim
  static Future<String> createClaim(Claim claim) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/claims'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(claim.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['claim_id'] ?? '';
    } else {
      throw Exception('Failed to create claim');
    }
  }

  // Update an existing claim
  static Future<bool> updateClaim(Claim claim) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/claims/${claim.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(claim.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update claim');
    }
  }

  // Delete a claim
  static Future<bool> deleteClaim(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/claims/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete claim');
    }
  }

  // Update claim status
  static Future<bool> updateClaimStatus(
    String id,
    String newStatus, {
    String? notes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.put(
      Uri.parse('$baseUrl/claims/$id/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': newStatus, 'notes': notes}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update claim status');
    }
  }

  // Process payment for claim
  static Future<bool> processPayment(
    String claimId,
    double amount,
    String paymentMethod,
    String paymentNote,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/claims/$claimId/payments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'amount': amount,
        'payment_method': paymentMethod,
        'payment_note': paymentNote,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['status'] == 'success';
    } else {
      throw Exception('Failed to process payment');
    }
  }

  // Add a note to a claim
  static Future<bool> addClaimNote(
    String claimId,
    String content,
    bool isInternal,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/claims/$claimId/notes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'content': content, 'is_internal': isInternal}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['status'] == 'success';
    } else {
      throw Exception('Failed to add claim note');
    }
  }

  // Get claims by filter criteria
  static Future<List<Claim>> getClaimsByFilter({
    String? clientName,
    String? policyNumber,
    String? status,
    String? claimType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    // Build query parameters
    final queryParams = <String, String>{};
    if (clientName != null && clientName.isNotEmpty) {
      queryParams['client_name'] = clientName;
    }
    if (policyNumber != null && policyNumber.isNotEmpty) {
      queryParams['policy_number'] = policyNumber;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (claimType != null && claimType.isNotEmpty) {
      queryParams['claim_type'] = claimType;
    }
    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }

    final uri = Uri.parse(
      '$baseUrl/claims/filter',
    ).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success' && data['claims'] != null) {
        return List<Claim>.from(
          data['claims'].map((claim) => Claim.fromJson(claim)),
        );
      }

      return [];
    } else {
      throw Exception('Failed to load filtered claims');
    }
  }

  // Get claims received from My Personal Valuables app
  static Future<List<Claim>> getExternalClaims() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/claims/external'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success' && data['claims'] != null) {
        return List<Claim>.from(
          data['claims'].map((claim) => Claim.fromJson(claim)),
        );
      }

      return [];
    } else {
      throw Exception('Failed to load external claims');
    }
  }
}
