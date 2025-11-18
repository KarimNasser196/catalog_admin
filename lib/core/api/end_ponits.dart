class EndPoint {
  static String baseUrl = "https://backend.catalog-eg.shop/api/v1/";

  static String login = "auth/login";
  static String forgotPassword = "auth/forgot-password";
  static String logout = "auth/logout";
  static String refreshToken = "auth/refresh";

  // User Profile
  static String userProfile = "auth/profile";
  //dashboard
  static String dashboardStats = "admin/dashboard";
  //users
  static String adminUsers = "admin/users";
  //promo code
  static String adminCoupons = "admin/coupons";
  // Pricing
  static String pricing = "pricing";
}

class ApiKey {
  static String status = "status";
  static String errorMessage = "message";
  static String email = "login";
  static String password = "password";
  static String firstName = "firstName";
  static String lastName = "lastName";
  static String otp = "otp";
  static String newPassword = "newPassword";

  static String accessToken = "accessToken";
  static String refreshToken = "refreshToken";
  static String expiresAtUtc = "expiresAtUtc";

  static String userId = "userId";
  static String fullName = "fullName";
  static String profilePicture = "profilePicture";

  static String message = "message";
  static String id = "id";
  static String name = "name";
  static String username = "user_name";
  static String phone = "phone";
  static String dateOfBirth = "dateOfBirth";

  // Social Auth Keys
  static String idToken = "idToken";
  static String token = "token";
  static String facebookAccessToken = "accessToken";
}
