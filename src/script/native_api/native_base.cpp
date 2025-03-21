#pragma once
#include "native_base.h"
#include "profiler.h"

void NativeModApiBase::n_deprecated_function(const u64 start_time, const u64 end_time, Profiler& profiler) {
	profiler.avg("l_deprecated_function", end_time - start_time);
}