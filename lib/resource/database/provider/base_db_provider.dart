import 'package:sqflite/sqflite.dart';

const ThoiGianBD = 'ThoiGianBD';
const ThoiGianKT = 'ThoiGianKT';

abstract class BaseDBProvider<T> {
  Future init();
  Future onCreateTable(Database db);
  Future update(T value, String id);
  Future<List<int>> insert(List<T> value, String createdAt);
  Future delete(int id);
  Future<List<Map>> selectAll();
  Future<Map> selectOne(int id);
  Future deletedTable(Database db);
}
