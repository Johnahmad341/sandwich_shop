import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileService {
  String filename = "";

  FileService(this.filename);

  Future<String> get _localPath async {
    final directory = await getApplicationCacheDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  //the order of sadnwiches are; 1st Footlong, 2nd Six-Inch

  Future<int> readNomSandwich(String sandwichType) async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();
      final contentsSeperate = contents.split('\n');

      if (contents == "") {
        file.writeAsString("0\n0");
        return 0;
      } else if (sandwichType == "footlong") {
        return int.parse(contentsSeperate[0]);
      } else if (sandwichType == "six-inch") {
        return int.parse(contentsSeperate[1]);
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<String> writeNomSandwich(String orderDetails) async {
    final file = await _localFile;

    final contents = await file.readAsString();
    final contentsSeperate = contents.split('\n');

    final order_detailsSplit = orderDetails.split(' ');

    String sandwichType = order_detailsSplit[1];
    int crementBy = int.parse(order_detailsSplit[0]); 
    

    if (sandwichType == "footlong") {
      contentsSeperate[0] = (int.parse(contentsSeperate[0]) + crementBy)
          .toString();
      await file.writeAsString(contentsSeperate.join("\n"));
      return contentsSeperate.join("\n");
    } else if (sandwichType == "six-inch") {
      contentsSeperate[1] = (int.parse(contentsSeperate[1]) + crementBy)
          .toString();
      return contentsSeperate.join("\n");
    } else {
      return "";
    }
  }
}
