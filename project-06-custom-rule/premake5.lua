local Root = path.getabsolute(".")

if (_ACTION == nil) then
	return
end

local LocationDir = path.join(Root, "solution", _ACTION)

rule "myrule"
	display "My custom rule"
	fileextension ".in"

	propertydefinition {
		name = "copy",
		display = "Copy from shell",
		description = "Select copy executable from shell",
		values = { [0] = "cmd", [1] = "posix"},
		switch = { [0] = "copy", [1] = "cp"}, -- cannot use space so no 'copy /B /Y'
		value = 1
  }

	buildmessage 'custom rule %{file.relpath} %{file.reldirectory}/%{file.basename}'
	--buildinputs { "%{file.relpath}" }
	buildoutputs { "%{file.reldirectory}/%{file.basename}" }
	buildcommands { "%{copy} %{file.relpath} %{file.reldirectory}%{file.basename}" } -- msvc action dislikes /

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
	filter "action:vs*"
		myruleVars { copy = "cmd"}
	filter "action:not vs*"
		myruleVars { copy = "posix"}
	filter {}

	files {path.join(Root, "src", "main.cpp"), path.join(Root, "src", "main.h.in")}
	includedirs {path.join(Root, "src")}
