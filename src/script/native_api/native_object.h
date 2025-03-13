#include "native_base.h"
#include "../lua_api/l_object.h"
class NativeObjectRef : public NativeModApiBase {
public:
	static void n_native_remove(const ObjectRef* ref);
};