# Copyright (c) 2022 Haofan Zheng
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

cmake_minimum_required(VERSION 3.14)

include_guard()

include(FetchContent)

FUNCTION(simpleboost_msg mod msg)
	message(${mod} "SimpleBoost: ${msg}")
ENDFUNCTION()

FUNCTION(simpleboost_msg_status msg)
	simpleboost_msg(STATUS ${msg})
ENDFUNCTION()

FUNCTION(simpleboost_msg_err msg)
	simpleboost_msg(FATAL_ERROR ${msg})
ENDFUNCTION()


FUNCTION(simpleboost_add_sublib)
	# if (${ARGC} LESS 31)
	# 	message(FATAL "Not enough arguments passed to simpleboost_add_sublib function")
	# endif()

	set(sublibName "${ARGV0}")

	set(options "")
	set(oneValueArgs TARGET_NAME GIT_ADDR_HTTPS GIT_ADDR_SSH)
	set(multiValueArgs DEPENDS DEPENDS_WIN32)

	cmake_parse_arguments(
		PARSE_ARGV 1
		_sublib_meta
		"${options}"
		"${oneValueArgs}"
		"${multiValueArgs}")

	set(SIMPLEBOOST_SUBLIB_${sublibName}_IS_ENABLED
		OFF
		CACHE INTERNAL
		"Internal - indicate if the fetch & enable proc is done on this sub-lib"
		FORCE)

	set(SIMPLEBOOST_SUBLIB_${sublibName}_TARGET_NAME
		${_sublib_meta_TARGET_NAME}
		CACHE STRING
		"The target name of the ${sublibName} sub-library"
		FORCE)

	set(SIMPLEBOOST_SUBLIB_${sublibName}_GIT_ADDR_HTTPS
		${_sublib_meta_GIT_ADDR_HTTPS}
		CACHE STRING
		"The git address (HTTPS) to ${sublibName} sub-library"
		FORCE)

	set(SIMPLEBOOST_SUBLIB_${sublibName}_GIT_ADDR_SSH
		${_sublib_meta_GIT_ADDR_SSH}
		CACHE STRING
		"The git address (SSH) to ${sublibName} sub-library"
		FORCE)

	if (WIN32)
		set(_sublib_meta_DEPENDS
			${_sublib_meta_DEPENDS}
			${_sublib_meta_DEPENDS_WIN32})
	endif()

	set(SIMPLEBOOST_SUBLIB_${sublibName}_DEPENDS
		${_sublib_meta_DEPENDS}
		CACHE STRING
		"The dependencies of ${sublibName} sub-library"
		FORCE)

	if (NOT DEFINED SIMPLEBOOST_SUBLIB_${sublibName}_GIT_TAG)
		if (NOT DEFINED SIMPLEBOOST_DEFAULT_VERSION_TAG)
			message(FATAL "The default version tag is not defined for boost sub-libraries")
		endif()

		set(SIMPLEBOOST_SUBLIB_${sublibName}_GIT_TAG
			${SIMPLEBOOST_DEFAULT_VERSION_TAG}
			CACHE STRING
			"The git tag of the version selected for ${sublibName} sub-library"
			FORCE)
	endif()

ENDFUNCTION()


FUNCTION(simpleboost_enable_sublib sublibName)
	# 1. check if sublib metadata is added
	if (NOT DEFINED SIMPLEBOOST_SUBLIB_${sublibName}_IS_ENABLED)
		simpleboost_msg_err(
			"The metadata of the sub-library named ${sublibName} is not given")
	endif()

	# 2. Check if sublib is already enabled
	if(${SIMPLEBOOST_SUBLIB_${sublibName}_IS_ENABLED})
		return()
	endif()

	# 3. Resolve dependencies
	foreach(dep IN LISTS SIMPLEBOOST_SUBLIB_${sublibName}_DEPENDS)
		simpleboost_enable_sublib(${dep})
	endforeach()

	# 4. fetch and enable the library
	simpleboost_msg_status("Enabling sub-library named ${sublibName}")

	FetchContent_Declare(
		git_boost_${sublibName}
		GIT_REPOSITORY ${SIMPLEBOOST_SUBLIB_${sublibName}_GIT_ADDR_HTTPS}
		GIT_TAG        ${SIMPLEBOOST_SUBLIB_${sublibName}_GIT_TAG}
	)
	FetchContent_MakeAvailable(git_boost_${sublibName})

	set(SIMPLEBOOST_SUBLIB_${sublibName}_IS_ENABLED
		ON
		CACHE INTERNAL
		"Internal - indicate if the fetch & enable proc is done on this sub-lib"
		FORCE)

ENDFUNCTION()