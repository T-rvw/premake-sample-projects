#!/bin/bash

if [ "$1" != "premake4" -a "$1" != "premake5" ]
then
  echo "first argument should be a premake4 or premake5"
  exit 1
fi

if [ "$2" == "" ]
then
  echo "second argument should be a premake action (gmake, codelite)"
  exit 1
fi
premake=$1
action=$2

function exec_unix
{
  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./bin ./bin/app
  return $?
}

function exec_windows
{
  ./bin/app.exe
  return $?
}

function run_cmake
{
  cmake . && make && exec_unix
  return $?
}

function run_codeblocks
{
  # require X11/graphical terminal :-/
  # xvfb might simulate one.
  codeblocks --no-splash-screen --target=Release --build Project.workspace && exec_unix
  # Project.workspace
  # app.cbp
  return $?
}

function run_codelite
{
  codelite-make --settings=../../../codelite/build_settings.xml --workspace=Project.workspace --project=app --config=Release --command=build --verbose --execute && exec_unix
  return $?
}

function run_gmake
{
  make && exec_unix
  return $?
}

function run_gmake2
{
  make && exec_unix
  return $?
}

function run_ninja
{
  cat build_app_Release.ninja
  ninja && exec_unix
  return $?
}

function run_vs2005
{
    msbuild.exe Project.sln && exec_windows
    return $?
}
function run_vs2008
{
    msbuild.exe Project.sln && exec_windows
    return $?
}
function run_vs2010
{
    msbuild.exe Project.sln && exec_windows
    return $?
}
function run_vs2012
{
    msbuild.exe Project.sln && exec_windows
    return $?
}
function run_vs2013
{
    msbuild.exe Project.sln && exec_windows
    return $?
}
function run_vs2015
{
    msbuild.exe Project.sln && exec_windows
    return $?
}
function run_vs2017
{
    msbuild.exe Project.sln && exec_windows
    return $?
}

function run_vs2019
{
    msbuild.exe Project.sln && exec_windows
    return $?
}

res=0
for project in project-*
do
  if [ ! -e $project/$premake.lua ]
  then
    echo $project" Skipped"
    continue
  fi
  echo $project
  $premake --file=$project/$premake.lua $action
  cd $project/solution/$action
  run_$action $project
  if [ $? == 0 ]
  then
    echo $project" OK"
  else
    echo $project" KO"
    res=1
  fi
  cd ../../..
done
exit $res
