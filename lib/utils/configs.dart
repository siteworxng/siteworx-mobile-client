import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

const APP_NAME = 'Siteworx';
const APP_NAME_TAG_LINE = 'Construction Skills and Services Marketplace for Construction Artisans, Building Materials, Master Buiulders and Real Estate Services';
var defaultPrimaryColor = Color(0xff8d161a);

const DOMAIN_URL = 'https://siteworx.diidol.com.ng';
const BASE_URL = '$DOMAIN_URL/api/';

const DEFAULT_LANGUAGE = 'en';

/// You can change this to your Provider App package name
/// This will be used in Registered As Partner in Sign In Screen where your users can redirect to the Play/App Store for Provider App
/// You can specify in Admin Panel, These will be used if you don't specify in Admin Panel
const PROVIDER_PACKAGE_NAME = 'ng.siteworx.client';
const IOS_LINK_FOR_PARTNER = "";

const IOS_LINK_FOR_USER = '';

const DASHBOARD_AUTO_SLIDER_SECOND = 5;

const TERMS_CONDITION_URL = 'https://siteworx.ng/home/terms_and_conditions';
const PRIVACY_POLICY_URL = 'https://siteworx.ng/home/privacy_policy';
const INQUIRY_SUPPORT_EMAIL = 'siteworxsocials@gmail.com';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+2349018671421';

/// STRIPE PAYMENT DETAIL
const STRIPE_MERCHANT_COUNTRY_CODE = 'IN';
const STRIPE_CURRENCY_CODE = 'INR';
DateTime todayDate = DateTime(2022, 8, 24);

/// SADAD PAYMENT DETAIL
const SADAD_API_URL = 'https://api-s.sadad.qa';
const SADAD_PAY_URL = "https://d.sadad.qa";

Country defaultCountry() {
  return Country(
    phoneCode: '234',
    countryCode: 'NG',
    e164Sc: 234,
    geographic: true,
    level: 1,
    name: 'Nigeria',
    example: '8034477604',
    displayName: 'Nigeria (NG) [+234]',
    displayNameNoCountryCode: 'Nigeria (NG)',
    e164Key: '234-NG-0',
    fullExampleWithPlusSign: '+2349018671421',
  );
}
