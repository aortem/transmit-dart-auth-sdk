/// A model class representing metadata about an authentication token.
///
/// This class stores details about a token, including its type, expiration,
/// associated user ID, activation status, and assigned scopes.
class AortemTransmitTokenMetadata {
  /// The type of token (e.g., `Bearer`).
  final String tokenType;

  /// The expiration date and time of the token.
  final DateTime expiresAt;

  /// The unique identifier of the user associated with the token.
  final String userId;

  /// Indicates whether the token is currently active.
  final bool active;

  /// A list of scopes assigned to the token, determining its permissions.
  final List<String> scopes;

  /// Creates an instance of [AortemTransmitTokenMetadata].
  ///
  /// Requires:
  /// - [tokenType]: The type of token.
  /// - [expiresAt]: The expiration time of the token.
  /// - [userId]: The user ID associated with the token.
  /// - [active]: Whether the token is active.
  /// - [scopes]: The list of scopes assigned to the token.
  AortemTransmitTokenMetadata({
    required this.tokenType,
    required this.expiresAt,
    required this.userId,
    required this.active,
    required this.scopes,
  });

  /// Creates an instance of [AortemTransmitTokenMetadata] from a JSON object.
  ///
  /// - If `token_type` is missing, it defaults to `'unknown'`.
  /// - If `expires_at` is missing or invalid, it defaults to the current time.
  /// - If `user_id` is missing, it defaults to an empty string.
  /// - If `active` is missing, it defaults to `false`.
  /// - If `scopes` is missing, it defaults to an empty list.
  factory AortemTransmitTokenMetadata.fromJson(Map<String, dynamic> json) {
    return AortemTransmitTokenMetadata(
      tokenType: json['token_type'] ?? 'unknown',
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now(),
      userId: json['user_id'] ?? '',
      active: json['active'] ?? false,
      scopes: List<String>.from(json['scopes'] ?? []),
    );
  }

  /// Converts the token metadata into a JSON-compatible map.
  ///
  /// Returns a `Map<String, dynamic>` containing:
  /// - `token_type`
  /// - `expires_at` (formatted as ISO 8601 string)
  /// - `user_id`
  /// - `active`
  /// - `scopes`
  Map<String, dynamic> toJson() {
    return {
      'token_type': tokenType,
      'expires_at': expiresAt.toIso8601String(),
      'user_id': userId,
      'active': active,
      'scopes': scopes,
    };
  }

  /// Returns a human-readable string representation of the token metadata.
  @override
  String toString() {
    return 'TokenMetadata(tokenType: $tokenType, expiresAt: $expiresAt, userId: $userId, active: $active, scopes: $scopes)';
  }
}
