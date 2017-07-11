# LuaWiMix
A Lua distribution similar to LuaForWindows without anything but ilua, but with support for Lua 5.1 5.2 and 5.3 including optional luarocks and a switching mechanism.

The switch is used in the commandline via "lua 5? %*" see the [batch files](src/wimix/lua.cmd).
This also applies to [luarocks](src/wimix/arc/luarocks.cmd)

## Requirements
<strong style="color: red;">[MinGW](http://mingw.org/) IS REQUIRED</strong>  
LuaRocks is configured as follows:
```batch
install /P "$INSTDIR\wimix\rocks\${major}${minor}$\"
		/TREE "$INSTDIR\wimix\rocks\${major}${minor}\tree"
		/CMOD "$INSTDIR\${major}${minor}\clibs"
		/LUAMOD "$INSTDIR\${major}${minor}\lua" "
		/LV ${major}.${minor}
		/LUA "$INSTDIR\${major}${minor}\"
		/MW /NOREG /Q
```
Thus you need [MinGW](http://mingw.org/), the best would be to use [mingw-get](https://sourceforge.net/projects/mingw/files/Installer/).
