---
name: control-helium
description: Use when asked to control Helium browser, whether attaching to a running session or launching a new one.
---

# Control Helium

Control the Helium browser only through the Chrome DevTools MCP server. Choose whether MCP should attach to Helium or launch it, then confirm the browser before changing any page. This skill does not cover general Linux process or desktop control.

## Choose a mode

- Attach when the user refers to their open browser, existing tabs, or logged-in session.
- Launch when the user asks for a new or isolated browser, or no Helium process is running.
- If the request is ambiguous and Helium is already running, attach to it.

## Attach to running Helium

1. Check the local CDP shim:

   ```bash
   curl --fail --silent http://127.0.0.1:9223/json/version
   ```

   The response must contain a `webSocketDebuggerUrl`. Helium stores its live endpoint in `$HOME/.config/net.imput.helium/DevToolsActivePort`. `$HOME/.local/bin/helium-cdp-shim.mjs` exposes that endpoint on port `9223`.

2. Inspect the effective Chrome DevTools MCP definition. Keep other servers and unrelated fields intact. Configure this server with:

   ```json
   {
     "command": "npx",
     "args": [
       "-y",
       "chrome-devtools-mcp@1.6.0",
       "--browserUrl",
       "http://127.0.0.1:9223"
     ]
   }
   ```

3. Connect to the `chrome-devtools` MCP server and call `list_pages` first. Proceed only when the pages match the visible Helium session. A lone `about:blank` page usually means MCP launched a separate browser.

4. If the shim is unavailable while Helium is running, inspect the Helium and `helium-cdp-shim` processes instead of launching another browser.

## Launch new Helium

1. Inspect the effective Chrome DevTools MCP definition. Keep other servers and unrelated fields intact. Configure Chrome DevTools MCP to launch Helium itself rather than starting Helium with a shell command:

   ```json
   {
     "command": "npx",
     "args": [
       "-y",
       "chrome-devtools-mcp@1.6.0",
       "--executablePath",
       "/opt/helium/helium",
       "--isolated"
     ]
   }
   ```

   `--isolated` gives the new browser a temporary profile and avoids interfering with the user's normal Helium profile. Omit it only when the user explicitly wants a persistent profile, then agree on a `--userDataDir` first.

2. Connect to the `chrome-devtools` MCP server and call `list_pages`. This starts Helium. Confirm that the returned page belongs to a new Helium instance before continuing.

## Finish the request

If the MCP definition changed after the Pi session started, reload Pi's extensions before connecting. Then perform the requested action with Chrome DevTools MCP tools. Verify the result directly or call `list_pages` again. Finish only when the requested page or state appears in the selected Helium instance.
