// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FilterStore on FilterStoreBase, Store {
  late final _$providerIdAtom = Atom(name: 'FilterStoreBase.providerId', context: context);

  @override
  List<int> get providerId {
    _$providerIdAtom.reportRead();
    return super.providerId;
  }

  @override
  set providerId(List<int> value) {
    _$providerIdAtom.reportWrite(value, super.providerId, () {
      super.providerId = value;
    });
  }

  late final _$handymanIdAtom = Atom(name: 'FilterStoreBase.handymanId', context: context);

  @override
  List<int> get handymanId {
    _$handymanIdAtom.reportRead();
    return super.handymanId;
  }

  @override
  set handymanId(List<int> value) {
    _$handymanIdAtom.reportWrite(value, super.handymanId, () {
      super.handymanId = value;
    });
  }

  late final _$ratingIdAtom = Atom(name: 'FilterStoreBase.ratingId', context: context);

  @override
  List<int> get ratingId {
    _$ratingIdAtom.reportRead();
    return super.ratingId;
  }

  @override
  set ratingId(List<int> value) {
    _$ratingIdAtom.reportWrite(value, super.ratingId, () {
      super.ratingId = value;
    });
  }

  late final _$categoryIdAtom = Atom(name: 'FilterStoreBase.categoryId', context: context);

  @override
  List<int> get categoryId {
    _$categoryIdAtom.reportRead();
    return super.categoryId;
  }

  @override
  set categoryId(List<int> value) {
    _$categoryIdAtom.reportWrite(value, super.categoryId, () {
      super.categoryId = value;
    });
  }

  late final _$selectedSubCategoryIdAtom = Atom(name: 'FilterStoreBase.selectedSubCategoryId', context: context);

  @override
  int get selectedSubCategoryId {
    _$selectedSubCategoryIdAtom.reportRead();
    return super.selectedSubCategoryId;
  }

  @override
  set selectedSubCategoryId(int value) {
    _$selectedSubCategoryIdAtom.reportWrite(value, super.selectedSubCategoryId, () {
      super.selectedSubCategoryId = value;
    });
  }

  late final _$isPriceMaxAtom = Atom(name: 'FilterStoreBase.isPriceMax', context: context);

  @override
  String get isPriceMax {
    _$isPriceMaxAtom.reportRead();
    return super.isPriceMax;
  }

  @override
  set isPriceMax(String value) {
    _$isPriceMaxAtom.reportWrite(value, super.isPriceMax, () {
      super.isPriceMax = value;
    });
  }

  late final _$isPriceMinAtom = Atom(name: 'FilterStoreBase.isPriceMin', context: context);

  @override
  String get isPriceMin {
    _$isPriceMinAtom.reportRead();
    return super.isPriceMin;
  }

  @override
  set isPriceMin(String value) {
    _$isPriceMinAtom.reportWrite(value, super.isPriceMin, () {
      super.isPriceMin = value;
    });
  }

  late final _$searchAtom = Atom(name: 'FilterStoreBase.search', context: context);

  @override
  String get search {
    _$searchAtom.reportRead();
    return super.search;
  }

  @override
  set search(String value) {
    _$searchAtom.reportWrite(value, super.search, () {
      super.search = value;
    });
  }

  late final _$latitudeAtom = Atom(name: 'FilterStoreBase.latitude', context: context);

  @override
  String get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(String value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  late final _$longitudeAtom = Atom(name: 'FilterStoreBase.longitude', context: context);

  @override
  String get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(String value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  late final _$addToProviderListAsyncAction = AsyncAction('FilterStoreBase.addToProviderList', context: context);

  @override
  Future<void> addToProviderList({required int prodId}) {
    return _$addToProviderListAsyncAction.run(() => super.addToProviderList(prodId: prodId));
  }

  late final _$removeFromProviderListAsyncAction = AsyncAction('FilterStoreBase.removeFromProviderList', context: context);

  @override
  Future<void> removeFromProviderList({required int prodId}) {
    return _$removeFromProviderListAsyncAction.run(() => super.removeFromProviderList(prodId: prodId));
  }

  late final _$addToCategoryIdListAsyncAction = AsyncAction('FilterStoreBase.addToCategoryIdList', context: context);

  @override
  Future<void> addToCategoryIdList({required int prodId}) {
    return _$addToCategoryIdListAsyncAction.run(() => super.addToCategoryIdList(prodId: prodId));
  }

  late final _$setSelectedSubCategoryAsyncAction = AsyncAction('FilterStoreBase.setSelectedSubCategory', context: context);

  @override
  Future<void> setSelectedSubCategory({required int catId}) {
    return _$setSelectedSubCategoryAsyncAction.run(() => super.setSelectedSubCategory(catId: catId));
  }

  late final _$removeFromCategoryIdListAsyncAction = AsyncAction('FilterStoreBase.removeFromCategoryIdList', context: context);

  @override
  Future<void> removeFromCategoryIdList({required int prodId}) {
    return _$removeFromCategoryIdListAsyncAction.run(() => super.removeFromCategoryIdList(prodId: prodId));
  }

  late final _$addToHandymanListAsyncAction = AsyncAction('FilterStoreBase.addToHandymanList', context: context);

  @override
  Future<void> addToHandymanList({required int prodId}) {
    return _$addToHandymanListAsyncAction.run(() => super.addToHandymanList(prodId: prodId));
  }

  late final _$removeFromHandymanListAsyncAction = AsyncAction('FilterStoreBase.removeFromHandymanList', context: context);

  @override
  Future<void> removeFromHandymanList({required int prodId}) {
    return _$removeFromHandymanListAsyncAction.run(() => super.removeFromHandymanList(prodId: prodId));
  }

  late final _$addToRatingIdAsyncAction = AsyncAction('FilterStoreBase.addToRatingId', context: context);

  @override
  Future<void> addToRatingId({required int prodId}) {
    return _$addToRatingIdAsyncAction.run(() => super.addToRatingId(prodId: prodId));
  }

  late final _$removeFromRatingIdAsyncAction = AsyncAction('FilterStoreBase.removeFromRatingId', context: context);

  @override
  Future<void> removeFromRatingId({required int prodId}) {
    return _$removeFromRatingIdAsyncAction.run(() => super.removeFromRatingId(prodId: prodId));
  }

  late final _$clearFiltersAsyncAction = AsyncAction('FilterStoreBase.clearFilters', context: context);

  @override
  Future<void> clearFilters() {
    return _$clearFiltersAsyncAction.run(() => super.clearFilters());
  }

  late final _$FilterStoreBaseActionController = ActionController(name: 'FilterStoreBase', context: context);

  @override
  void setMaxPrice(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.setMaxPrice');
    try {
      return super.setMaxPrice(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMinPrice(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.setMinPrice');
    try {
      return super.setMinPrice(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearch(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.setSearch');
    try {
      return super.setSearch(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLatitude(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.setLatitude');
    try {
      return super.setLatitude(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLongitude(String val) {
    final _$actionInfo = _$FilterStoreBaseActionController.startAction(name: 'FilterStoreBase.setLongitude');
    try {
      return super.setLongitude(val);
    } finally {
      _$FilterStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
providerId: ${providerId},
handymanId: ${handymanId},
ratingId: ${ratingId},
categoryId: ${categoryId},
selectedSubCategoryId: ${selectedSubCategoryId},
isPriceMax: ${isPriceMax},
isPriceMin: ${isPriceMin},
search: ${search},
latitude: ${latitude},
longitude: ${longitude}
    ''';
  }
}
