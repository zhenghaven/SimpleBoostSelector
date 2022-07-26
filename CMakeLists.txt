# Copyright (c) 2022 Haofan Zheng
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

cmake_minimum_required(VERSION 3.14)

project(SimpleBoost VERSION 0.0.1 LANGUAGES CXX)

set(SIMPLEBOOST_BOOST_VER
	"1.70.0"
	CACHE STRING
	"The version number of the selected boost library")

option(SIMPLEBOOST_TEST
	"Option to build SimpleBoost test executable."
	OFF)

string(REGEX REPLACE
	"\\."
	"_"
	SIMPLEBOOST_BOOST_VER_US
	${SIMPLEBOOST_BOOST_VER})

set(SIMPLEBOOST_BOOST_VER_CMAKE_FILE_PATH
	./cmake/versions/boost_${SIMPLEBOOST_BOOST_VER_US}.cmake)

include(./cmake/functions.cmake)

simpleboost_msg_status("Boost version selected: ${SIMPLEBOOST_BOOST_VER}")
simpleboost_msg_status("Boost version file: ${SIMPLEBOOST_BOOST_VER_CMAKE_FILE_PATH}")

include(${SIMPLEBOOST_BOOST_VER_CMAKE_FILE_PATH})
include(./cmake/sub_lib_meta.cmake)

if(${SIMPLEBOOST_TEST})
	enable_testing()
	add_subdirectory(test)
endif(${SIMPLEBOOST_TEST})
