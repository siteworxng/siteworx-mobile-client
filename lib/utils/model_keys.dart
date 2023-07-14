class CommonKeys {
  static String id = 'id';
  static String address = 'address';
  static String serviceId = 'service_id';
  static String customerId = 'customer_id';
  static String handymanId = 'handyman_id';
  static String providerId = 'provider_id';
  static String bookingId = 'booking_id';
  static String date = 'date';
  static String status = 'status';
  static String dateTime = 'datetime';
  static String txnId = "txn_id";
  static String paymentStatus = "payment_status";
  static String paymentMethod = "payment_type";
  static String advancePaidAmount = "advance_paid_amount";
}

class UserKeys {
  static String firstName = 'first_name';
  static String lastName = 'last_name';
  static String userName = 'username';
  static String email = 'email';
  static String password = 'password';
  static String userType = 'user_type';
  static String contactNumber = 'contact_number';
  static String countryId = 'country_id';
  static String stateId = 'state_id';
  static String cityId = 'city_id';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String profileImage = 'profile_image';
  static String playerId = 'player_id';
  static String uid = 'uid';
  static String id = 'id';
  static String loginType = 'login_type';
  static String displayName = 'display_name';
}

class BookingServiceKeys {
  static String description = 'description';
  static String couponId = 'coupon_id';
  static String date = 'date';
  static String totalAmount = 'total_amount';
  static String userPostJob = 'user_post_job';
  static String type = 'type';
  static String bookingPackage = 'booking_package';
}

class CouponKeys {
  static String code = 'code';
  static String discount = 'discount';
  static String discountType = 'discount_type';
  static String expireDate = 'expire_date';
}

class BookService {
  static String amount = 'amount';
  static String totalAmount = 'total_amount';
  static String quantity = 'quantity';
  static String bookingAddressId = 'booking_address_id';
}

class BookingStatusKeys {
  static String pending = 'pending';
  static String accept = 'accept';
  static String onGoing = 'on_going';
  static String inProgress = 'in_progress';
  static String hold = 'hold';
  static String rejected = 'rejected';
  static String failed = 'failed';
  static String complete = 'completed';
  static String cancelled = 'cancelled';
  static String pendingApproval = "pending_approval";
  static String waitingAdvancedPayment = "waiting";
}

class BookingUpdateKeys {
  static String reason = 'reason';
  static String startAt = 'start_at';
  static String endAt = 'end_at';
  static String date = 'date';

  static String durationDiff = 'duration_diff';
  static String paymentStatus = 'payment_status';
}

class NotificationKey {
  static String type = 'type';
  static String page = 'page';
}

class CurrentLocationKey {
  static String latitude = 'latitude';
  static String longitude = 'longitude';
}

class CreateService {
  static String id = 'id';
  static String name = 'name';
  static String description = 'description';
  static String type = "type";
  static String price = "price";
  static String images = "images";
  static String attachmentCount = "attachment_count";
  static String serviceAttachment = 'service_attachment_';
  static String addedBy = 'added_by';
  static String providerId = 'provider_id';
  static String categoryId = 'category_id';
  static String status = 'status';
  static String duration = 'duration';
  static String attchments = 'attchments';
}

class PostJob {
  static String postRequestId = 'post_request_id';
  static String postTitle = 'title';
  static String description = 'description';
  static String serviceId = 'service_id';
  static String price = 'price';
  static String jobPrice = 'job_price';
  static String status = 'status';
  static String providerId = 'provider_id';
}

class PackageKey {
  static String packageId = "id";
  static String categoryId = 'category_id';
  static String name = "name";
  static String price = 'price';
  static String serviceId = 'service_id';
  static String startDate = "start_date";
  static String endDate = "end_date";
  static String isFeatured = 'is_featured';
  static String packageType = 'package_type';
}

class BlogKey {
  static String attachmentCount = 'attachment_count';
  static String blogAttachment = 'blog_attachment_';
  static String id = 'id';
  static String title = 'title';
  static String description = 'description';
  static String isFeatured = 'is_featured';
  static String status = 'status';
  static String providerId = 'provider_id';
  static String authorId = 'author_id';
  static String blogId = 'blog_id';
}

class AdvancePaymentKey {
  static String advancePaymentAmount = "advance_payment_amount"; // double value
  static String isEnableAdvancePayment = 'is_enable_advance_payment'; // 0/1
  static String advancePaidAmount = 'advance_paid_amount';
}
