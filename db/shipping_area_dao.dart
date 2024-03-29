import 'package:flutterrestaurant/db/common/ps_dao.dart' show PsDao;
import 'package:flutterrestaurant/viewobject/shipping_area.dart';
import 'package:sembast/sembast.dart';

class ShippingAreaDao extends PsDao<ShippingArea> {
  ShippingAreaDao._() {
    init(ShippingArea());
  }
  static const String STORE_NAME = 'ShippingArea';
  final String _primaryKey = 'id';

  // Singleton instance
  static final ShippingAreaDao _singleton = ShippingAreaDao._();

  // Singleton accessor
  static ShippingAreaDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String ?getPrimaryKey(ShippingArea object) {
    return object.id;
  }

  @override
  Filter getFilter(ShippingArea object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
