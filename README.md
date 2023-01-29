# Simple Boost Selector

Simple CMake scripts to help to fetch only boost sub-libraries that are needed.
This is still a work-in-progress, thus, no all sub-libraries are supported
(~90% sub-libraries are supported, and ~35% sub-libraries are partially tested).

## Code Status
- [![Unit Tests](https://github.com/zhenghaven/SimpleBoostSelector/actions/workflows/unit-tests.yaml/badge.svg?branch=main)](https://github.com/zhenghaven/SimpleBoostSelector/actions/workflows/unit-tests.yaml)
	- Testing environments
		- OS: `ubuntu-22.04`, `windows-latest`, `macos-latest`
		- C++ std: `11`, `20` (by setting CXX_STANDARD in CMake)
