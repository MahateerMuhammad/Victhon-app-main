class ApiList {
  static const baseUrl = "http://10.135.133.255:3000";
  static const String socketUrl = "http://10.135.133.255:3000";

  static const login = "$baseUrl/auth/user/login?role=";
  static const customerGoogleAuth = "$baseUrl/auth/google/mobile/customer";
  static const serviceProviderGoogleAuth =
      "$baseUrl/auth/google/mobile/provider";

  static const signUp = "$baseUrl/auth/user/signup/initiate?role=";
  static const signIn = "$baseUrl/auth/user/login?role=";
  static const googleAuth = "$baseUrl/auth/google/";

  static const forgotPassword = "$baseUrl/auth/ResetPassword/initiate";
  static const resetPassword = "$baseUrl/auth/ResetPassword/validate";

  static const verifyOtp = "$baseUrl/auth/VerifyOTP";
  static const validateUserSignUp = "$baseUrl/auth/user/signup/validate?role=";

  static const uploadMedia = "$baseUrl/upload/image";

  //Profile ApiList
  static const profile = "$baseUrl/auth/profile/";
  static const profileImage = "$baseUrl/upload/profile-image?role=";

  //Notification
  static const sendOneSignalPlayerId =
      "$baseUrl/notifications/update/player-id";
  static const notifications = "$baseUrl/notifications";
  static const createNotifiPreference =
      "$baseUrl/notification-preferences/create";
  static const updateNotifiPreference =
      "$baseUrl/notification-preferences/update";
  static const getNotifiPreference = "$baseUrl/notification-preferences/get";

  //Services ApiList
  static const getAllServices = "$baseUrl/booking/top-services";
  static const searchServices = "$baseUrl/booking/services/";
  static const providerServices = "$baseUrl/services/provider";

  static const getTopCategories = "$baseUrl/booking/top-categories";
  static const createServices = "$baseUrl/services/create";
  static const updateServices = "$baseUrl/services/update/";
  static const deleteServices = "$baseUrl/services/";

  static const getAllCategories = "$baseUrl/booking/category/find";

  //bookings
  static const getAllBookings = "$baseUrl/booking/";
  //Customer bookings
  static const createBooking = "$baseUrl/booking/create";
  static const cancelBooking = "$baseUrl/booking/cancel/";
  static const confirmBookingCompletion = "$baseUrl/booking/verify/";

  //Service Provider bookings
  static const acceptBooking = "$baseUrl/booking/confirm/";
  static const startBooking = "$baseUrl/booking/start/";
  static const completeBooking = "$baseUrl/booking/complete/";
  static const declineBooking = "$baseUrl/booking/decline/";

  //Chat
  static const getConversation = "$baseUrl/conversations";
  static const sendMessage = "$baseUrl/sendMessage";
  static const getConversationMessages = "$baseUrl/conversations/";
  static const createConversation = "$baseUrl/conversations/create";
  static const getMessageHistory = "$baseUrl/history/{userId}";

  //Earnings/Wallet
  static const payForService = "$baseUrl/payments/initialize/";
  static const getTransaction = "$baseUrl/payments/transactions";
  static const walletWithdrawal = "$baseUrl/payments/withdraw";
  static const setTransactionPin = "$baseUrl/wallets/pin/create";

  //Banks
  static const getAllBanks = "$baseUrl/banks/paystack/all";
  static const getBankAccount = "$baseUrl/banks/account/all";
  static const addBankAccount = "$baseUrl/banks/acount/add";
  static const deleteBankAccount = "$baseUrl/banks/account/";

  //ratings and review
  static const getRatingsAndReviews = "$baseUrl/ratings/serviceProvider";
  static const ratingAndReviewService = "$baseUrl/ratings/booking/";
  static const reportService = "$baseUrl/booking/report";
}
