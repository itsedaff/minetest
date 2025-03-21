#pragma once
#include "profiler.h"
#include "server.h"
#include "../common/c_internal.h"
#include "porting.h"

class NativeModApiBase
{
public:
	static void n_deprecated_function(const u64 start_time, const u64 end_time, Profiler &profiler);
};