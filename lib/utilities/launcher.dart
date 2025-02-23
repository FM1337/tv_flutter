import 'dart:io';

Future<void> launchWebsite(String url) async {
  // Launches the website in the default browser
  await Process.run('flatpak', [
    "run",
    "org.chromium.Chromium",
    url,
    "--start-fullscreen",
  ]);
  print('done');
}

Future<void> launchApplication(String command, bool launchInWeston) async {
  var commandParts = command.split(' ');
  var commandName = commandParts[0];
  if (commandParts.length > 1) {
    commandParts = commandParts.sublist(1);
  } else {
    commandParts = [];
  }

  if (launchInWeston) {
    await Process.run('weston', [
      '--shell=kiosk-shell.so',
      '--fullscreen',
      '--',
      commandName,
      ...commandParts,
    ]);
  } else {
    print("Running $commandName with args $commandParts");
    await Process.run(commandName, commandParts);
  }
  print('done');
}

Future<void> launchFlatpakApp(String command, bool launchInWeston) async {
  if (launchInWeston) {
    await Process.run('weston', [
      '--shell=kiosk-shell.so',
      '--fullscreen',
      '--',
      'flatpak',
      'run',
      command,
    ]);
  } else {
    await Process.run('flatpak', ['run', command]);
  }
  print('done');
}
