class RemoteUrls {
  static const String rootUrl = "https://everisamting.com/";
  // static const String rootUrl = "http://192.168.203.60:8000/";
  static const String baseUrl = "${rootUrl}api/";


  // static const String rootUrl2 = "http://192.168.203.62:8000/";
  static const String rootUrl2 = "https://www.ekayzone.com/";
  static const String baseUrl2 = "${rootUrl2}api/";

  static String homeUrl(countryCode) => "${baseUrl2}home?country_code=$countryCode";
  static const String userRegister = '${baseUrl2}auth/register';
  static const String socialLogin = '${baseUrl2}auth/social-login';
  static const String userLogin = '${baseUrl2}auth/login';

  static const String postAdCreate = '${baseUrl2}ads';
  static String adUpdate(String id) => '${baseUrl2}ads/$id/update';
  static const String pricingPlan = '${baseUrl}pricing-plans';
  static const String myPlanBilling = '${baseUrl2}customer/recent-invoices';
  static const String paymentGateways = '${baseUrl2}pamentgetways';
  static const String paymentConfirmation = '${baseUrl2}payment-success';
  static const String editProfile = '${baseUrl2}auth/profile';
  static const String changePassword = '${baseUrl2}auth/password';
  static const String socialUpdate = '${baseUrl}social';
  static const String deleteAccount = '${baseUrl}customer/account-delete';

  //.......... Directory .............
  static const String createDirectory = '${baseUrl}store/bussiness/directory';
  static const String getDirectoryCategory = '${baseUrl}business/directories/category';
  static String claimBusiness(String id) => '${baseUrl}business/claim/$id';
  static const String contactAuthor = '${baseUrl}contact/author';

  //........... E V E N T S ..............
  static const String getEvents = "${baseUrl}events?";
  static const String getUserEvents = "${baseUrl}user/event?";
  static const String createEvent = "${baseUrl}store/event";
  static const String eventParams = "${baseUrl}events/params";
  static String getEventDetails(String slug) => "${baseUrl}events/$slug";

  static String userLogOut() =>
      '${baseUrl}auth/logout';
  static const String sendForgetPassword = '${baseUrl2}auth/password/email';
  static const String resendRegisterCode = '${baseUrl}resend-register-code';
  static String storeResetPassword = '${baseUrl2}auth/password/reset';

  static String userVerification(String code) =>
      '${baseUrl}user-verification/$code';
  static String userProfile = '${baseUrl2}auth/me';
  static String publicProfile(String username, String sortBy) =>
      '${baseUrl2}seller/$username?sort_by=$sortBy';
  static String dashboardOverview = '${baseUrl2}customer/dashboard-overview';
  static String updateProfile(String token) =>
      '${baseUrl}user/update-profile?token=$token';
  static String passwordChange = '${baseUrl2}auth/password';
  static String stateByCountryId(String countryId, String token) =>
      '${baseUrl}user/state-by-country/$countryId?token=$token';
  static String citiesByStateId(String stateId, String token) =>
      '${baseUrl}user/city-by-state/$stateId?token=$token';
  static String getChatUsers(String username) =>
      '${baseUrl2}message/$username';
  static String postSellerReview(String seller) =>
      '${baseUrl2}seller/review/$seller';
  static String orderList(String token) => '${baseUrl}user/order?token=$token';
  static String trackOrder(String orderId) => '${baseUrl}track-order-response/$orderId';
  static const String aboutUs = '${baseUrl}about-content';
  static const String accDeletion = '${baseUrl}account-deletion-request';
  static const String accDeletion2 = '${baseUrl}customer/account-delete';
  static const String faq = '${baseUrl}faqscategories';
  static const String termsAndConditions = '${baseUrl}terms-conditions';
  static const String privacyPolicy = '${baseUrl}privacy-policy';
  static const String postingRules = '${baseUrl}postingrules-content';
  static const String contactUs = '${baseUrl}contact-us';
  static const String sendContactMessage = '${baseUrl}contacts/send';
  static const String websiteSetup = '${baseUrl2}settings';
  static const String getCountry = '${baseUrl2}countries';
  static const String getLanguages = '${baseUrl}lenguage/sync';
  static String getSingleLanguage(String code) => '${baseUrl}lenguage/$code';
  static String productDetail(String slug, String countryCode) =>
      '${baseUrl2}ads/$slug?country_code=$countryCode';
  static String deleteMyAd(int id) =>
      '${baseUrl2}customer/ads/$id/delete';
  static String address(String token) =>
      '${baseUrl}user/address?token=$token';
  static String billingAddress(String token) =>
      '${baseUrl}user/update-billing-address?token=$token';
  static String shippingAddress(String token) =>
      '${baseUrl}user/update-shipping-address?token=$token';
  static String wishList = '${baseUrl2}customer/favourite-list';
  static String removeWish(int id, String token) =>
      '${baseUrl}user/remove-wishlist/$id?token=$token';
  static String addWish(int id,) =>
      '${baseUrl2}ads/$id/favourite';
  static const String searchAds = '${baseUrl2}ads?';
  static const String customerAds = '${baseUrl2}customer/ads';
  static const String sellerList = '${baseUrl}seller/list';
  static const String bannerProduct = '${baseUrl}product';

  static const String searchDirectory = '${baseUrl}business/directories';
  static const String getMyDirectory = '${baseUrl}user/directories';
  static String getDirectoryDetails(int id, String slug) => '${baseUrl}business/details/$id/$slug';

  ///............ Store ................
  static const String storeProduct = '${baseUrl}seller-detail?';
  static String cartProduct(String token) => "${baseUrl}cart?token=$token";

  static String submitReviewUrl(String token) =>
      '${baseUrl}user/store-product-review?token=$token';

  static String cartCheckout(String token) =>
      "${baseUrl}user/checkout?token=$token";
  static String cartPaymentInfo() =>
      "${baseUrl}user/checkout/payment";
  static String incrementQuantity(String id, String token) =>
      "${baseUrl}cart-update/$id?token=$token";
  static String decrementQuantity(String id, String token) =>
      "${baseUrl}cart-decrement/$id?token=$token";
  static String applyCoupon(String coupon, String token) =>
      "${baseUrl}apply-coupon?coupon=$coupon&token=$token";
  static String removeCartItem(String id, String token) =>
      "${baseUrl}cart-item-remove/$id?token=$token";
  static const String addToCart = '${baseUrl}add-to-cart?';
  static const String cashOnDelivery =
      '${baseUrl}user/checkout/cash-on-delivery?';
  static String payWithStripe(String token) =>
      '${baseUrl}user/checkout/pay-with-stripe?token=$token';
  static String payWithPaypal(String token, String shippingId) =>
      '${baseUrl}user/checkout/pay-with-paypal?token=$token&shipping_method=$shippingId&agree_terms_condition=1';

  static imageUrl(String imageUrl) => rootUrl2 + imageUrl;

  static const String donateUrl = "https://www.paypal.com/donate?token=M9OD2mJFkklUjO1gQVpEIEPLZG5oNuAhnqyTUSl3v3JbVMv0Y-GU0mOLdf-VDyPETrcwHxI01PFqZkm_";
  static const String alikaTrainingUrl = "https://www.alikatraining.co.za/";
  static const String alikaGuesthouseUrl = "https://www.alikaguesthouse.co.za";

}
