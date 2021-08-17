local Root = path.getabsolute(".")

if (_ACTION == nil) then
	return
end

local LocationDir = path.join(Root, "solution", _ACTION)

rule "myrule"
	display "My custom rule"
	fileextension ".in"

	buildmessage 'custom rule %{file.relpath} %{file.reldirectory}/%{file.basename}'
	--buildinputs { "%{file.relpath}" }
	buildoutputs { "%{file.reldirectory}/%{file.basename}" }
	buildcommands { "{COPYFILE} %{file.relpath} %{file.reldirectory}/%{file.basename}" }

workspace "Project"
	location(LocationDir)
	configurations {"Release"}

	objdir(path.join(LocationDir, "obj")) -- premake adds $(configName)/$(AppName)
	targetdir(path.join(LocationDir, "bin"))
	targetname("app")
	startproject "app"

project "app"
	kind "ConsoleApp"
	rules { "myrule" }

	files {path.join(Root, "src", "main.cpp"), path.join(Root, "src", "main.h.in")}
	includedirs {path.join(Root, "src")}
