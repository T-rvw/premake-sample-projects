local Root = path.getabsolute(".")

if (_ACTION == nil) then
	return
end

local LocationDir = path.join(Root, "../solution/project-01", _ACTION)

workspace "Project01"
	location(LocationDir)
	configurations {"Release"}

	objdir(path.join(LocationDir, "obj")) -- premake adds $(configName)/$(AppName)
	targetdir(path.join(LocationDir, "bin"))
  targetname("app")
	
project "app"
	kind "ConsoleApp"

	files {path.join(Root, "src/main.cpp")}

	forceincludes {path.join(Root, "src/force_header.h")}
	sysincludedirs {path.join(Root, "src/sysinclude")}
	includedirs {path.join(Root, "src/include")}

	defines "MACRO"
	defines {'COMPLEX_MACRO="void f() {}"'}
  filter "toolset:gcc or toolset:clang"
    buildoptions {'-DRETURN0="return 0;"'}
  filter "toolset:msc"
    buildoptions {'/DRETURN0="return 0;"'}