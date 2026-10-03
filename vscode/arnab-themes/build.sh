#!/usr/bin/env bash
# Packages the theme as a .vsix and installs it. VS Code ignores extension
# folders that are not registered in ~/.vscode/extensions/extensions.json,
# so the theme has to go through a real install rather than a symlink.
set -euo pipefail

cd "$(dirname "$0")"
name=$(python3 -c 'import json;m=json.load(open("package.json"));print(m["publisher"]+"."+m["name"]+"-"+m["version"])')
out="${TMPDIR:-/tmp}/$name.vsix"

python3 - "$out" <<'PY'
import json, sys, zipfile, pathlib

out = sys.argv[1]
m = json.load(open("package.json"))

manifest = f"""<?xml version="1.0" encoding="utf-8"?>
<PackageManifest Version="2.0.0" xmlns="http://schemas.microsoft.com/developer/vsx-schema/2011">
  <Metadata>
    <Identity Language="en-US" Id="{m['name']}" Version="{m['version']}" Publisher="{m['publisher']}" />
    <DisplayName>{m['displayName']}</DisplayName>
    <Description xml:space="preserve">{m['description']}</Description>
    <Categories>Themes</Categories>
  </Metadata>
  <Installation>
    <InstallationTarget Id="Microsoft.VisualStudio.Code" />
  </Installation>
  <Dependencies/>
  <Assets>
    <Asset Type="Microsoft.VisualStudio.Code.Manifest" Path="extension/package.json" Addressable="true" />
  </Assets>
</PackageManifest>
"""

content_types = """<?xml version="1.0" encoding="utf-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="json" ContentType="application/json"/>
  <Default Extension="vsixmanifest" ContentType="text/xml"/>
</Types>
"""

with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
    z.writestr("extension.vsixmanifest", manifest)
    z.writestr("[Content_Types].xml", content_types)
    z.write("package.json", "extension/package.json")
    for p in sorted(pathlib.Path("themes").rglob("*.json")):
        z.write(p, f"extension/{p}")
PY

code --install-extension "$out" --force
rm -f "$out"
