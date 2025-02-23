import 'dart:io';

enum DesktopfileType { application, link, directory, unknown }

extension DesktopfileTypeExtension on DesktopfileType {
  static DesktopfileType fromString(String name) {
    try {
      return DesktopfileType.values.firstWhere(
        (e) => e.toString().toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return DesktopfileType.unknown;
    }
  }
}

class Desktopfile {
  DesktopfileType type;
  String? version;
  String name;
  String? genericName;
  bool? noDisplay;
  String? comment;
  String? icon;
  bool? hidden;
  List<String>? onlyShowIn;
  List<String>? notShowIn;
  bool? dbusActivatable;
  String? tryExec;
  String? exec;
  String? path;
  bool? terminal;
  List<String>? actions;
  List<String>? mimeTypes;
  List<String>? categories;
  List<String>? implements;
  List<String>? keywords;
  bool? startupNotify;
  String? startupWMClass;
  String url;
  bool? prefersNonDefaultGPU;
  bool? singleMainWindow;

  Desktopfile({
    required this.type,
    required this.name,
    required this.url,
    this.version,
    this.genericName,
    this.noDisplay,
    this.comment,
    this.icon,
    this.hidden,
    this.onlyShowIn,
    this.notShowIn,
    this.dbusActivatable,
    this.tryExec,
    this.exec,
    this.path,
    this.terminal,
    this.actions,
    this.mimeTypes,
    this.categories,
    this.implements,
    this.keywords,
    this.startupNotify,
    this.startupWMClass,
    this.prefersNonDefaultGPU,
    this.singleMainWindow,
  });

  static Future<Desktopfile> fromFile(String path) async {
    var file = File(path);

    var contents = await file.readAsString();

    var lines = contents.split("\n");
    var items = <String, String>{};
    var skip = false;
    for (var line in lines) {
      if (line.isEmpty) {
        continue;
      }

      if (line.startsWith("[Desktop Entry]")) {
        skip = false;
        continue;
      }

      if (skip) {
        continue;
      }

      if (line.startsWith("[Desktop Action")) {
        skip = true;
        continue;
      }

      var parts = line.split("=");
      if (parts.length < 2) {
        continue;
      } else if (parts.length > 2) {
        parts[1] = parts.sublist(1).join("=");
      }

      if (parts[0].startsWith("Name[en")) {
        items["Name"] = parts[1];
        continue;
      } else if (parts[0].startsWith("Name[")) {
        continue;
      }

      if (parts[0].startsWith("Keywords[en")) {
        items["Keywords"] = parts[1];
        continue;
      } else if (parts[0].startsWith("Keywords")) {
        continue;
      }

      if (parts[0].startsWith("Comment[en")) {
        items["Comment"] = parts[1];
        continue;
      } else if (parts[0].startsWith("Comment[")) {
        continue;
      }

      if (parts[0].startsWith("GenericName[en")) {
        items["GenericName"] = parts[1];
        continue;
      } else if (parts[0].startsWith("GenericName[")) {
        continue;
      }

      items[parts[0]] = parts[1];
    }

    var df = Desktopfile(
      type: DesktopfileType.values.firstWhere(
        (e) => e.toString().toLowerCase() == items["Type"]?.toLowerCase(),
        orElse: () => DesktopfileType.unknown,
      ),
      name: items["Name"] ?? "Unknown",
      url: items["Uri"] ?? "",
    );

    for (var key in items.keys) {
      switch (key) {
        case "Version":
          df.version = items[key];
          break;
        case "GenericName":
          df.genericName = items[key];
          break;
        case "NoDisplay":
          df.noDisplay = items[key] == "true";
          break;
        case "Comment":
          df.comment = items[key];
          break;
        case "Icon":
          df.icon = items[key];
          break;
        case "Hidden":
          df.hidden = items[key] == "true";
          break;
        case "OnlyShowIn":
          df.onlyShowIn = items[key]?.split(";") ?? [];
          df.onlyShowIn?.removeWhere((element) => element.isEmpty);
          break;
        case "NotShowIn":
          df.notShowIn = items[key]?.split(";") ?? [];
          df.notShowIn?.removeWhere((element) => element.isEmpty);
          break;
        case "DBusActivatable":
          df.dbusActivatable = items[key] == "true";
          break;
        case "TryExec":
          df.tryExec = items[key];
          break;
        case "Exec":
          df.exec = items[key];
          // strip out the %U, %F, etc
          df.exec = df.exec?.replaceAll(RegExp(r"%[a-zA-Z]"), "");
          // also strip out any @@\s that might be there
          df.exec = df.exec!.replaceAll("@@", "");
          df.exec = df.exec!.trim();
          break;
        case "Path":
          df.path = items[key];
          break;
        case "Terminal":
          df.terminal = items[key] == "true";
          break;
        case "Actions":
          df.actions = items[key]?.split(";") ?? [];
          df.actions?.removeWhere((element) => element.isEmpty);
          break;
        case "MimeTypes":
          df.mimeTypes = items[key]?.split(";") ?? [];
          df.mimeTypes?.removeWhere((element) => element.isEmpty);
          break;
        case "Categories":
          df.categories = items[key]?.split(";") ?? [];
          df.categories?.removeWhere((element) => element.isEmpty);
          break;
        case "Implements":
          df.implements = items[key]?.split(";") ?? [];
          df.implements?.removeWhere((element) => element.isEmpty);
          break;
        case "Keywords":
          df.keywords = items[key]?.split(";") ?? [];
          df.keywords?.removeWhere((element) => element.isEmpty);
          break;
        case "StartupNotify":
          df.startupNotify = items[key] == "true";
          break;
        case "StartupWMClass":
          df.startupWMClass = items[key];
          break;
        case "PrefersNonDefaultGPU":
          df.prefersNonDefaultGPU = items[key] == "true";
          break;
        case "SingleMainWindow":
          df.singleMainWindow = items[key] == "true";
          break;
      }
    }

    return df;
  }
}
