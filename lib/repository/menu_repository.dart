import 'package:machine_test/models/menuList.dart';
import 'package:machine_test/repository/menu_provider.dart';

class MenuRepository{

  MenuProvider _menuProvider = MenuProvider();

  Future<Menu> getMenuDetails() =>
      _menuProvider.getMenuDetails();

}