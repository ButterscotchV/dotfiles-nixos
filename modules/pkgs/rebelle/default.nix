{
  lib,
  libErosanix,
  wine,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
  xwintab,
  sourceVersion,
  hash,
}:

libErosanix.mkWindowsAppNoCC rec {
  inherit wine;

  pname = "rebelle";
  version = with sourceVersion; "${major}.${minor}.${patch}${suffix}";

  src = fetchurl {
    url = "https://escapemotions1.b-cdn.net/products/rebelle/update/downloads/Rebelle_v${version}_Windows_64bit.exe";
    inherit hash;
  };

  # By default, when a Wine prefix is first created Wine will produce a warning prompt if Mono is not installed.
  # This doesn't happen with the Wine "full" packages, but it does happen with the "base" packages.
  # When this option is set to 'false', DLL overrides are used when the Wine prefix is created, to bypass the prompt.
  enableMonoBootPrompt = false;
  dontUnpack = true;
  wineArch = "win64";

  # `fileMap` can be used to set up automatic symlinks to files which need to be persisted.
  # The attribute name is the source path and the value is the path within the $WINEPREFIX.
  # But note that you must ommit $WINEPREFIX from the path.
  # To figure out what needs to be persisted, take at look at $(dirname $WINEPREFIX)/upper,
  # while the app is running.
  fileMap = with sourceVersion; {
    "$HOME/.config/${pname}${major}" =
      "drive_c/users/$USER/AppData/Local/Escape Motions/Rebelle ${major}";
  };

  nativeBuildInputs = [
    copyDesktopItems
    libErosanix.copyDesktopIcons
  ];

  # This code will become part of the launcher script.
  # It will execute if the application needs to be installed,
  # which would happen either if the needed app layer doesn't exist,
  # or for some reason the needed Windows layer is missing, which would
  # invalidate the app layer.
  # WINEPREFIX, WINEARCH, AND WINEDLLOVERRIDES are set
  # and wine, winetricks, and cabextract are in the environment.
  winAppInstall = ''
    $WINE ${src} /VERYSILENT /SUPPRESSMSGBOXES

    # Symlink XWinTab DLLs to system32
    # TODO Don't symlink DLLs, but provide them in an env var if possible
    SYS_DIR="$WINEPREFIX/drive_c/windows/system32"
    mkdir -p "$SYS_DIR"
    ln -sf "${xwintab}/wintab32.dll" "$SYS_DIR/"
    ln -sf "${xwintab}/XWinTabHelper.dll.so" "$SYS_DIR/"
  '';

  # This code runs before winAppRun, but only for the first instance.
  # Therefore, if the app is already running, winAppRun will not execute.
  # Use this to do any setup prior to running the app.
  winAppPreRun = "";

  # This code will become part of the launcher script.
  # It will execute after winAppInstall and winAppPreRun (if needed),
  # to run the application.
  # WINEPREFIX, WINEARCH, AND WINEDLLOVERRIDES are set
  # and wine, winetricks, and cabextract are in the environment.
  # Command line arguments are in $ARGS, not $@
  # DO NOT BLOCK. For example, don't run: wineserver -w
  winAppRun = with sourceVersion; ''
    export WINEDLLOVERRIDES="wintab32=n,b;$WINEDLLOVERRIDES"
    $WINE "$WINEPREFIX/drive_c/Program Files/Rebelle ${major}/Rebelle ${major}.exe" "$ARGS"
  '';

  # This code will run after winAppRun, but only for the first instance.
  # Therefore, if the app was already running, winAppPostRun will not execute.
  # In other words, winAppPostRun is only executed if winAppPreRun is executed.
  # Use this to do any cleanup after the app has terminated
  winAppPostRun = "";

  # This is a normal mkDerivation installPhase, with some caveats.
  # The launcher script will be installed at $out/bin/.launcher
  # DO NOT DELETE OR RENAME the launcher. Instead, link to it as shown.
  installPhase = with sourceVersion; ''
    runHook preInstall
    OLD_LAUNCHER=$out/bin/.launcher
    NEW_LAUNCHER=$out/bin/${pname}${major}
    # Correct `MY_PATH` in launcher script
    substituteInPlace $OLD_LAUNCHER \
      --replace-fail $OLD_LAUNCHER $NEW_LAUNCHER
    mv $OLD_LAUNCHER $NEW_LAUNCHER
    runHook postInstall
  '';

  desktopItems = with sourceVersion; [
    (makeDesktopItem {
      name = "${pname}${major}";
      exec = "${pname}${major}";
      icon = "${pname}${major}";
      desktopName = "Rebelle ${major}";
      genericName = "Digital Painting";
      categories = [ "Graphics" ];
    })
  ];

  desktopIcon =
    with sourceVersion;
    libErosanix.makeDesktopIcon {
      name = "${pname}${major}";
      src = ./Rebelle.png;
    };

  meta = with lib; {
    description = "Real media paint software for digital painting, with simulation of real-world color mixing, blending, wet-diffusion and drying.";
    homepage = "https://www.escapemotions.com/products/rebelle";
    license = licenses.unfree;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
