import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Model/DataModel.dart';
import 'ApiEndPoints.dart';

class CallApi with ChangeNotifier {
  late DataModel model;

  TextEditingController controller = TextEditingController();

  bool isLoading = false;
  checkLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  getData(String value, endPoint) async {
    checkLoading(true);
    var url = Uri.parse('$baseApi$endPoint$value&per_page=20');
    var response = await http.get(url, headers: {
      'Authorization':
          '64iiywbxQCihP21AbBeuu4jWmHAVH6FG4VhoDf3BrdtiZUkItVGkHwXQ',
    });
    final dataBody = json.decode(response.body);

    if (response.statusCode == 200) {
      print(response.body.toString());
      checkLoading(false);

      model = DataModel.fromJson(dataBody);
    } else {
      print(response.body.toString());
      checkLoading(false);
    }
    checkLoading(false);
    notifyListeners();
  }

  int page = 1;
  morePage() {
    page = page + 1;
    print('--------------------------------------------------$page');

    notifyListeners();
  }

  loadMore(String value, endPoint) async {
    morePage();
    // String url = 'https://api.pexels.com/v1/curated?per_page=1&page=$page';
    await http.get(Uri.parse('$baseApi$endPoint$value?per_page=20&page=$page'),
        headers: {
          'Authorization':
              '64iiywbxQCihP21AbBeuu4jWmHAVH6FG4VhoDf3BrdtiZUkItVGkHwXQ'
        }).then((value) {
      Map result = jsonDecode(value.body);
      model = DataModel.fromJson(result);
    });
    notifyListeners();
  }

  backPage() {
    if (page == 1) {
      print('--------------------------------------------------$page');
    } else {
      page = page - 1;
      print('--------------------------------------------------$page');
      notifyListeners();
    }
    notifyListeners();
  }

  backMore(String value, endPoint) async {
    backPage();
    // String url = 'https://api.pexels.com/v1/curated?per_page=1&page=$page';
    await http.get(Uri.parse('$baseApi$endPoint$value?per_page=20&page=$page'),
        headers: {
          'Authorization':
              '64iiywbxQCihP21AbBeuu4jWmHAVH6FG4VhoDf3BrdtiZUkItVGkHwXQ'
        }).then((value) {
      Map result = jsonDecode(value.body);
      model = DataModel.fromJson(result);
    });
    notifyListeners();
  }
}
