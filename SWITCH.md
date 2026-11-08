# Nintendo Switch 1 fork

This modified Kristal fork starts from `eaf9e0ef4472f2a8090a76fc8b6194230c3e30f7`
(0.11.0-dev) for LÖVE 11.5. The Switch platform adapter is
`src/engine/switch.lua`; it activates only when `love.system.getOS()` is `NX`.

- Fullscreen 1280×720, vsync and the existing 640×480 game canvas/aspect ratio.
- Preserve gameplay timing and visual effects.
- Plus opens the existing developer menu; Minus opens the developer console.
- Right stick moves the pointer, stick press sends a left click, L a right click.
  R remains available for mod-specific actions. Button labels follow SDL's mapping.
- Pointer movement uses frame time, a deadzone and screen bounds; disconnecting
  a controller releases any synthetic mouse buttons.
- Mouse releases use the same window-to-game conversion as presses.
- Skip desktop Discord/HTTPS shared-library loading on Switch (including threads).

The save identity is `kristal-ch67`. With the companion love-nx fork and a fused
RomFS game, saves/settings live at `sdmc:/switch/kristal-ch67`.

Build a `.love` from this engine and your own mod, and embed it as `game.love` in
the runtime NRO's RomFS. Mod code/assets are not part of this public engine fork.
Use hbmenu application mode on Switch 1. No title installation or emuMMC changes
are required.

Desktop regression and OpenGL ES shader tests have been executed, and the runtime
cross-compiles. Switch hardware parity/performance is still unverified.
