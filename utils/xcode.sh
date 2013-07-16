#!/bin/bash

OSMAND_TARGET_TOOLCHAIN="-DCMAKE_TOOLCHAIN_FILE=targets/$OSMAND_TARGET.cmake"
if [ ! -n "$OSMAND_TARGET" ]
then
   OSMAND_TARGET="unknown"
   OSMAND_TARGET_TOOLCHAIN=""
fi

CMAKE_BUILD_TYPE=""
BUILD_TYPE_SUFFIX=""
if [ -n "$1" ]
then
	case "$1" in
		debug)		CMAKE_BUILD_TYPE="Debug"
					BUILD_TYPE_SUFFIX="debug"
					;;
		release)	CMAKE_BUILD_TYPE="Release"
					BUILD_TYPE_SUFFIX="release"
					;;
		safemode)	CMAKE_BUILD_TYPE="safemode"
					BUILD_TYPE_SUFFIX="safemode"
					;;
	esac
fi
if [ -n "$CMAKE_BUILD_TYPE" ]
then
	echo "Building in $CMAKE_BUILD_TYPE mode"
	CMAKE_BUILD_TYPE="-DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE"
	BUILD_TYPE_SUFFIX="-$BUILD_TYPE_SUFFIX"
fi

OSMAND_CPU_SPECIFIC_DEFINE=""
CPU_SPECIFIC_SUFFIX=""
if [ -n "$OSMAND_SPECIFIC_CPU_NAME" ]
then
	echo "Building for CPU : $OSMAND_SPECIFIC_CPU_NAME"
	OSMAND_CPU_SPECIFIC_DEFINE="-DCMAKE_SPECIFIC_CPU_NAME:STRING=$OSMAND_SPECIFIC_CPU_NAME"
	CPU_SPECIFIC_SUFFIX="-$OSMAND_SPECIFIC_CPU_NAME"
fi

TARGET_PREFIX=""
if [ -n "$OSMAND_TARGET_PREFIX" ]
then
	TARGET_PREFIX="$OSMAND_TARGET_PREFIX-"
fi

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORK_ROOT=$SCRIPT_LOCATION/..
BAKED_DIR=$SCRIPT_LOCATION/../../baked/$TARGET_PREFIX$OSMAND_TARGET$CPU_SPECIFIC_SUFFIX$BUILD_TYPE_SUFFIX.xcode
rm -rf "$BAKED_DIR"
mkdir -p "$BAKED_DIR"
(cd "$BAKED_DIR" && cmake -G "Xcode" $OSMAND_TARGET_TOOLCHAIN $CMAKE_BUILD_TYPE $OSMAND_CPU_SPECIFIC_DEFINE "$WORK_ROOT")
