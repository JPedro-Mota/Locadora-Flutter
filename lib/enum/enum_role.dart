enum EnumRole {
  ADMIN,
  USER;

  @override
  String toString() {
    return name.toUpperCase();
  }

  static EnumRole fromString(String role) {
    return EnumRole.values.firstWhere(
        (e) => e.name.toUpperCase() == role.toUpperCase(),
        orElse: () => throw ArgumentError('Invalid role: $role'));
  }
}
