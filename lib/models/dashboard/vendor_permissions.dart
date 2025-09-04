class VendorPermissions {
  final bool allowProducts;
  final bool allowPackages;

  const VendorPermissions({
    this.allowProducts = false,
    this.allowPackages = false,
  });

  factory VendorPermissions.fromJson(json) {
    if (json is Map) {
      return VendorPermissions(
        allowProducts: json['allow-products'] == true,
        allowPackages: json['allow-packages'] == true,
      );
    }
    return const VendorPermissions();
  }
}
