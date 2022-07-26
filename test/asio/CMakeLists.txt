# Copyright (c) 2022 Haofan Zheng
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

cmake_minimum_required(VERSION 3.14)

simpleboost_enable_sublib(asio)

set(SOURCES main.cpp
			networking.cpp)

add_executable(SimpleBoost_asio_test ${SOURCES})

target_compile_options(SimpleBoost_asio_test
	PRIVATE $<$<CONFIG:>:${DEBUG_OPTIONS}>
			$<$<CONFIG:Debug>:${DEBUG_OPTIONS}>
			$<$<CONFIG:Release>:${RELEASE_OPTIONS}>)
target_link_libraries(SimpleBoost_asio_test gtest Boost::asio)

add_test(NAME SimpleBoost_asio_test
	COMMAND SimpleBoost_asio_test)

set_property(TARGET SimpleBoost_asio_test
	PROPERTY CXX_STANDARD ${SIMPLEBOOST_TEST_CXX_STANDARD})
