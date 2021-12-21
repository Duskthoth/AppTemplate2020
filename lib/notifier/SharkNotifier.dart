import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shark_stuff/models/sharks.dart';

class SharkNotifier with ChangeNotifier{
  List<Shark> _sharkList = [];
  Shark _currentShark;

  UnmodifiableListView<Shark> get sharkList => UnmodifiableListView(_sharkList);

  Shark get currentShark => _currentShark;

  

  set sharkList(List<Shark> sharkList){
    _sharkList = sharkList;
    notifyListeners();
  }

   set currentShark(Shark shark){
    _currentShark = shark;
    notifyListeners();
  }


  addShark(Shark shark) {
    _sharkList.insert(0, shark);
    notifyListeners();
  }

  deleteShark(Shark shark) {
    _sharkList.removeWhere((_shark) => _shark.id == shark.id);
    notifyListeners();
  }

}