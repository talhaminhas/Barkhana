import 'package:flutterrestaurant/db/common/ps_dao.dart' show PsDao;
import 'package:flutterrestaurant/viewobject/delivery_boy_rating.dart';
import 'package:sembast/sembast.dart';

class DeliveryBoyRatingDao extends PsDao<DeliveryBoyRating> {
  DeliveryBoyRatingDao._() {
    init(DeliveryBoyRating());
  }
  static const String STORE_NAME = 'DeliveryBoyRating';
  final String _primaryKey = 'id';

  // Singleton instance
  static final DeliveryBoyRatingDao _singleton = DeliveryBoyRatingDao._();

  // Singleton accessor
  static DeliveryBoyRatingDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(DeliveryBoyRating object) {
    return object.id;
  }

  @override
  Filter getFilter(DeliveryBoyRating object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
