{
  stdenvNoCC,
  unzip,
  imagemagick,
}:

stdenvNoCC.mkDerivation {
  pname = "rebelle-thumbnailer";
  version = "1.0";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ${./rebelle-thumbnailer.sh} \
      "$out/bin/rebelle-thumbnailer"
    install -Dm644 ${./rebelle.xml} \
      "$out/share/mime/packages/rebelle.xml"
    install -Dm644 ${./rebelle.thumbnailer} \
      "$out/share/thumbnailers/rebelle.thumbnailer"

    # Replace placeholders with store paths
    substituteInPlace "$out/bin/rebelle-thumbnailer" \
      --replace-fail '@UNZIP@' '${unzip}/bin/unzip' \
      --replace-fail '@MAGICK@' '${imagemagick}/bin/magick'

    # Set thumbnailer script path
    substituteInPlace "$out/share/thumbnailers/rebelle.thumbnailer" \
      --replace-fail '@THUMBNAILER@' "$out/bin/rebelle-thumbnailer"

    runHook postInstall
  '';
}
