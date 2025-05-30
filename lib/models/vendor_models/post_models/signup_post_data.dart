class VendorSignUpPostData {
  String? name;
  String? email;
  String? gender;
  String? password;
  String? confirmPassword;
  String? companyName;
  String? companySlug;
  String? companyMobileNumber;

  VendorSignUpPostData({
    this.name,
    this.email,
    this.gender,
    this.password,
    this.confirmPassword,
    this.companyName,
    this.companySlug,
    this.companyMobileNumber,
  });

  // Convert object to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": confirmPassword,
      "gender": gender,
      "shop_name": companyName,
      "shop_url": companySlug,
      "shop_phone": companyMobileNumber,
      "is_vendor": 1,
    };

    /*{"name":"Amanpal",
    "email":"seller@yopmial.com",
    "password":"Test@12345",
    "password_confirmation":"Test@12345",
    "gender":"male",
    "shop_name":"Seller company",
    "shop_url":"seller-company",
    "shop_phone":"987789879",
    "is_vendor":1,}*/
  }
}
