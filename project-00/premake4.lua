local Root = path.getabsolute(".")

if (_ACTION == nil) then
	return
end

local LocationDir = path.join(Root, "../solution/project-00/" .. _ACTION) -- premake4 doesn't support variadic join

solution "Project00"
  language "c++"
	location(LocationDir)
	configurations {"Release"}

	objdir(path.join(LocationDir, "obj")) -- premake adds $(configName)/$(AppName)
	targetdir(path.join(LocationDir, "bin"))
  targetname("app")
	
project "app"
	kind "ConsoleApp"

	files {path.join(Root, "src/main.cpp")}
