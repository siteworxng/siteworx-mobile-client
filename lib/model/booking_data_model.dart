import 'package:client/model/booking_list_model.dart';
import 'package:client/model/extra_charges_model.dart';
import 'package:client/model/package_data_model.dart';
import 'package:client/model/service_detail_response.dart';
import 'package:client/utils/constant.dart';
import 'package:client/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingData {
  int? id;
  String? address;
  int? customerId;
  String? customerName;
  int? serviceId;
  int? providerId;
  int? quantity;
  num? price;
  String? type;
  num? discount;
  String? statusLabel;
  String? description;
  String? providerName;
  String? serviceName;
  String? paymentStatus;
  String? paymentMethod;
  String? date;
  String? durationDiff;
  int? paymentId;
  int? bookingAddressId;
  String? durationDiffHour;
  String? bookingSlot;
  num? totalAmount;
  num? amount;
  num? paidAmount;

  CouponData? couponData;
  List<Handyman>? handyman;
  List<String>? serviceAttachments;
  String? status;
  List<TaxData>? taxes;

  String? reason;
  int? totalReview;
  num? totalRating;
  String? startAt;
  String? endAt;
  String? bookingType;

  List<ExtraChargesModel>? extraCharges;
  BookingPackage? bookingPackage;

  //Local
  double get totalAmountWithExtraCharges => totalAmount.validate() + extraCharges.validate().sumByDouble((e) => e.total.validate());

  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;

  bool get isSlotBooking => bookingSlot != null;

  bool get isProviderAndHandymanSame => handyman.validate().isNotEmpty ? handyman.validate().first.handymanId.validate() == providerId.validate() : false;

  bool get isFreeService => price.validate() == 0;

  bool get isPostJob => bookingType == BOOKING_TYPE_USER_POST_JOB;

  bool get isPackageBooking => bookingPackage != null ? true : false;

  bool get canCustomerContact => status != BookingStatusKeys.pending && status != BookingStatusKeys.cancelled && status != BookingStatusKeys.failed && status != BookingStatusKeys.rejected && status != BookingStatusKeys.waitingAdvancedPayment;

  bool get isAdvancePaymentDone => paidAmount.validate() != 0;

  BookingData({
    this.address,
    this.bookingAddressId,
    this.couponData,
    this.amount,
    this.customerId,
    this.customerName,
    this.date,
    this.description,
    this.discount,
    this.durationDiff,
    this.bookingSlot,
    this.durationDiffHour,
    this.handyman,
    this.id,
    this.paymentId,
    this.paymentMethod,
    this.paymentStatus,
    this.price,
    this.providerId,
    this.providerName,
    this.quantity,
    this.serviceAttachments,
    this.serviceId,
    this.serviceName,
    this.status,
    this.statusLabel,
    this.taxes,
    this.totalAmount,
    this.type,
    this.reason,
    this.totalReview,
    this.totalRating,
    this.startAt,
    this.endAt,
    this.extraCharges,
    this.bookingType,
    this.bookingPackage,
    this.paidAmount,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      address: json['address'],
      bookingSlot: json['booking_slot'],
      amount: json['amount'],
      totalAmount: json['total_amount'],
      bookingAddressId: json['booking_address_id'],
      couponData: json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null,
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      date: json['date'],
      description: json['description'],
      discount: json['discount'],
      durationDiff: json['duration_diff'],
      durationDiffHour: json['duration_diff_hour'],
      handyman: json['handyman'] != null ? (json['handyman'] as List).map((i) => Handyman.fromJson(i)).toList() : null,
      id: json['id'],
      paymentId: json['payment_id'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      price: json['price'],
      providerId: json['provider_id'],
      providerName: json['provider_name'],
      quantity: json['quantity'],
      serviceAttachments: json['service_attchments'] != null ? new List<String>.from(json['service_attchments']) : null,
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      status: json['status'],
      statusLabel: json['status_label'],
      taxes: json['taxes'] != null ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList() : null,
      type: json['type'],
      reason: json['reason'],
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      extraCharges: json['extra_charges'] != null ? (json['extra_charges'] as List).map((i) => ExtraChargesModel.fromJson(i)).toList() : null,
      bookingType: json['booking_type'],
      bookingPackage: json['booking_package'] != null ? BookingPackage.fromJson(json['booking_package']) : null,
      paidAmount: json[AdvancePaymentKey.advancePaidAmount],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['booking_address_id'] = this.bookingAddressId;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['total_amount'] = this.totalAmount;
    data['booking_slot'] = this.bookingSlot;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['duration_diff'] = this.durationDiff;
    data['duration_diff_hour'] = this.durationDiffHour;
    data['id'] = this.id;
    data['payment_id'] = this.paymentId;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['price'] = this.price;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    data['quantity'] = this.quantity;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['type'] = this.type;
    data['reason'] = this.reason;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['booking_type'] = this.bookingType;
    data[AdvancePaymentKey.advancePaidAmount] = this.amount;

    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.map((v) => v.toJson()).toList();
    }
    if (this.serviceAttachments != null) {
      data['service_attchments'] = this.serviceAttachments;
    }
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    if (this.extraCharges != null) {
      data['extra_charges'] = this.extraCharges!.map((v) => v.toJson()).toList();
    }
    if (bookingPackage != null) {
      data['booking_package'] = this.bookingPackage!.toJson();
    }
    return data;
  }
}
