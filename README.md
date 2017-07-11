# LuaMiSoWiDo
A LuaForWindows distribution of Lua 5.1 5.2 and 5.3 including luarocks on each and a switching mechanism.

The switch is used in the commandline via "lua 5? %*" see the [batch files](src/lua.bat).
This also applies to [luarocks](src/luarocks.bat)

You could add your own profile if you wish to. Just add a folder and put the lua.exe inside. DONE! eay as that!
Add whatever you like. Only problem is the LUA_PATH/LUA_CPATH as you here need a little trickery. Once the installer is done, I will look into this.

Luarocks is configured as follows:
```batch
install /P "%LUA_ROOT%\lua\rocks\%profile_name%" /TREE "%LUA_ROOT%\lua\rocks\%profile_name%\systree" /LUA "%LUA_ROOT%\%profile_name%\" /MW /CMOD "%LUA_ROOT%\%profile_name%\clibs" /LUAMOD "%LUA_ROOT%\%profile_name%\lua"
```

