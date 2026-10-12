@echo off
setlocal
cd /d "%~dp0"
set PSX_OVERLAY_AUTOCOMPILE_OFF=1
"EvilZone_Recompiled.exe" --game "game.toml" --disc "disc\Evil Zone.cue" --memcard-dir "saves"
endlocal
