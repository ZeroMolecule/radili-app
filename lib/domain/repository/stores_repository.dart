import 'package:radili/domain/data/store.dart';
import 'package:radili/domain/local/stores_box.dart';
import 'package:radili/domain/remote/stores_api.dart';

class StoresRepository {
  final StoresApi _storesApi;
  final StoresBox _storesBox;

  StoresRepository(
    this._storesApi,
    this._storesBox,
  );

  Future<List<Store>> findAll() async {
    final stores = await _storesApi.getStores();
    await _storesBox.save(stores);
    return stores;
  }

  Stream<List<Store>> watchAll() async* {
    final stored = await _storesBox.getAll();
    if (stored.isNotEmpty) yield stored;

    yield await findAll();
  }
}
