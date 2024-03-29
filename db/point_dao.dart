
import 'package:sembast/sembast.dart';

import '../viewobject/main_point.dart';
import 'common/ps_dao.dart';

class PointDao extends PsDao<MainPoint> {
  PointDao._() {
    init(MainPoint());
  }
  static const String STORE_NAME = 'Point';
  final String _primaryKey = 'id';

  // Singleton instance
  static final PointDao _singleton = PointDao._();

  // Singleton accessor
  static PointDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String ?getPrimaryKey(MainPoint object) {
    return object.id;
  }

  @override
  Filter getFilter(MainPoint object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
