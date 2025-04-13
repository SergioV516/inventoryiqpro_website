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

  // Add this method to convert Claim to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policy_number': policyNumber,
      'client_name': clientName,
      'claim_type': claimType,
      'status': status,
      'date_submitted': dateSubmitted.toIso8601String(),
      'total_value': totalValue,
      'items': items.map((item) => item.toJson()).toList(),
      'description': description,
      'attachments': attachments,
    };
  }

  // Add a fromJson method if you need to deserialize JSON into a Claim object
  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'] ?? '',
      policyNumber: json['policy_number'] ?? '',
      clientName: json['client_name'] ?? '',
      claimType: json['claim_type'] ?? '',
      status: json['status'] ?? '',
      dateSubmitted:
          json['date_submitted'] != null
              ? DateTime.parse(json['date_submitted'])
              : DateTime.now(),
      totalValue: json['total_value']?.toDouble() ?? 0.0,
      items:
          json['items'] != null
              ? List<ClaimedItem>.from(
                json['items'].map((x) => ClaimedItem.fromJson(x)),
              )
              : [],
      description: json['description'] ?? '',
      attachments:
          json['attachments'] != null
              ? List<String>.from(json['attachments'])
              : [],
    );
  }
}

class ClaimedItem {
  final String name;
  final double value;
  final String category;

  ClaimedItem({
    required this.name,
    required this.value,
    required this.category,
  });

  // Add this method to convert ClaimedItem to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value, 'category': category};
  }

  // Add a fromJson method if you need to deserialize JSON into a ClaimedItem object
  factory ClaimedItem.fromJson(Map<String, dynamic> json) {
    return ClaimedItem(
      name: json['name'] ?? '',
      value: json['value']?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
    );
  }
}
