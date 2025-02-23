import 'dart:io';

import 'package:tv_flutter/models/DesktopFile.dart';

List<String> paths = [];

Future<List<Desktopfile>> getDesktopFiles() async {
  List<Desktopfile> desktopFiles = [];
  // Get the XDG_DATA_DIRS environment variable
  var xdgDataDirs = Platform.environment["XDG_DATA_DIRS"];
  if (xdgDataDirs == null) {
    throw Exception("XDG_DATA_DIRS not set");
  }

  // Get the list of directories
  var dirs = xdgDataDirs.split(":");
  // make sure to add $HOME/.local/share
  dirs.add("${Platform.environment["HOME"]}/.local/share/");

  for (var dir in dirs) {
    var desktopFilePath =
        dir.endsWith("/") ? "${dir}applications" : "$dir/applications";
    // check if the dir exists
    var exists = await Directory(desktopFilePath).exists();
    if (!exists) {
      continue;
    }

    paths.add(dir);

    // get a list of all *.desktop files
    var files =
        await Directory(desktopFilePath).list().where((file) {
          return file.path.endsWith(".desktop");
        }).toList();

    for (var file in files) {
      var desktopFile = await Desktopfile.fromFile(file.path);

      // We want to skip those that should be hidden or don't have a exec command

      if (desktopFile.noDisplay != null && desktopFile.noDisplay!) {
        continue;
      }

      if (desktopFile.hidden != null && desktopFile.hidden!) {
        continue;
      }

      if (desktopFile.notShowIn != null &&
          !desktopFile.notShowIn!.contains("GNOME")) {
        continue;
      }

      if (desktopFile.exec == null || desktopFile.exec!.isEmpty) {
        continue;
      }

      desktopFiles.add(await Desktopfile.fromFile(file.path));
    }
  }

  return desktopFiles;
}

Future<String?> getIconPath(String? iconValue) async {
  if (iconValue == null) {
    return null;
  }

  // Sometimes you have a hard coded path
  if (iconValue.contains("/")) {
    return iconValue;
  }

  // loop through each path we know exists
  for (var path in paths) {
    var iconFilePath = path.endsWith("/") ? "${path}icons/" : "$path/icons/";
    // check if the dir exists
    var exists = await Directory(iconFilePath).exists();
    if (!exists) {
      continue;
    }

    // get a list of all subfolders
    var subFolders =
        await Directory(iconFilePath).list().where((file) {
          return file is Directory;
        }).toList();

    // try hicolor folder first
    var iconPath = await searchFolder("${iconFilePath}hicolor", iconValue);
    if (iconPath != null) {
      return iconPath;
    }

    // try the other folders
    for (var folder in subFolders) {
      if (folder.path.contains("hicolor")) {
        continue;
      }

      iconPath = await searchFolder(folder.path, iconValue);
      if (iconPath != null) {
        return iconPath;
      }
    }
  }

  return null;
}

Future<String?> searchFolder(String path, String iconName) async {
  // get a list of all subfolders
  var subFolders =
      await Directory(path).list().where((file) {
        return file is Directory;
      }).toList();

  // remove any non-Directory files
  subFolders.removeWhere((element) => element is! Directory);

  // sort the folders in descending order
  subFolders.sort((a, b) {
    // some may be a #x#, so we'll want to sort by the first number
    var aParts = a.path.split("/");
    var bParts = b.path.split("/");
    var aSize = aParts[aParts.length - 1].split("x")[0];
    var bSize = bParts[bParts.length - 1].split("x")[0];

    // make sure you don't try to parse a non-number
    if (int.tryParse(aSize) == null) {
      return 1;
    }

    if (int.tryParse(bSize) == null) {
      return -1;
    }

    return int.parse(bSize).compareTo(int.parse(aSize));

    // return b.path.compareTo(a.path);
  });

  for (var folder in subFolders) {
    // make sure this folder has the apps folder in it
    var path = "${folder.path}/apps";
    var exists = await Directory(path).exists();
    if (!exists) {
      continue;
    }

    var iconPath = await Directory(path).list().firstWhere((file) {
      return (file.path.endsWith(".png") ||
              file.path.endsWith(".svg") ||
              file.path.endsWith(".jp")) &&
          file.path.contains(iconName);
    }, orElse: () => File(""));

    if (await iconPath.exists()) {
      return iconPath.path;
    }
  }

  return null;
}
