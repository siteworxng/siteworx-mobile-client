import 'package:mobx/mobx.dart';

part 'filter_store.g.dart';

class FilterStore = FilterStoreBase with _$FilterStore;

abstract class FilterStoreBase with Store {
  @observable
  List<int> providerId = ObservableList();

  @observable
  List<int> handymanId = ObservableList();

  @observable
  List<int> ratingId = ObservableList();

  @observable
  List<int> categoryId = ObservableList();

  @observable
  int selectedSubCategoryId = 0;

  @observable
  String isPriceMax = '';

  @observable
  String isPriceMin = '';

  @observable
  String search = '';

  @observable
  String latitude = '';

  @observable
  String longitude = '';

  @action
  Future<void> addToProviderList({required int prodId}) async {
    providerId.add(prodId);
  }

  @action
  Future<void> removeFromProviderList({required int prodId}) async {
    providerId.removeWhere((element) => element == prodId);
  }

  @action
  Future<void> addToCategoryIdList({required int prodId}) async {
    categoryId.add(prodId);
  }

  @action
  Future<void> setSelectedSubCategory({required int catId}) async {
    selectedSubCategoryId = catId;
  }

  @action
  Future<void> removeFromCategoryIdList({required int prodId}) async {
    categoryId.removeWhere((element) => element == prodId);
  }

  @action
  Future<void> addToHandymanList({required int prodId}) async {
    handymanId.add(prodId);
  }

  @action
  Future<void> removeFromHandymanList({required int prodId}) async {
    handymanId.removeWhere((element) => element == prodId);
  }

  @action
  Future<void> addToRatingId({required int prodId}) async {
    ratingId.add(prodId);
  }

  @action
  Future<void> removeFromRatingId({required int prodId}) async {
    ratingId.removeWhere((element) => element == prodId);
  }

  @action
  Future<void> clearFilters() async {
    providerId.clear();
    handymanId.clear();
    ratingId.clear();
    categoryId.clear();
    isPriceMax = "";
    isPriceMin = "";
  }

  @action
  void setMaxPrice(String val) => isPriceMax = val;

  @action
  void setMinPrice(String val) => isPriceMin = val;

  @action
  void setSearch(String val) => search = val;

  @action
  void setLatitude(String val) => latitude = val;

  @action
  void setLongitude(String val) => longitude = val;
}
