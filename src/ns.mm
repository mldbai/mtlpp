/*
 * Copyright 2016-2017 Nikolay Aleksiev. All rights reserved.
 * License: https://github.com/naleksiev/mtlpp/blob/master/LICENSE
 */

#include "ns.hpp"
#include <CoreFoundation/CFBase.h>
#include <Foundation/NSString.h>
#include <Foundation/NSError.h>
#include <Foundation/NSArray.h>
#include <Foundation/NSURL.h>
#include <Foundation/NSGarbageCollector.h>
#include <cstring>
#include <iostream>

//#define CFRetain(x)
//#define CFRelease(x)

namespace ns
{
    const void * HandleHolder::retain(const void * ptr)
    {
        if (ptr)
            CFRetain(ptr);
        return ptr;
    }

    Object::Object() :
        m_ptr(nullptr)
    {
    }

    Object::Object(const RetainedHandle& handle) :
        m_ptr(handle.ptr)
    {
        //using namespace std;
        //cerr << "Construct " << typeName << " from handle " << handle.ptr << endl;
        //if (m_ptr) {
        //    cerr << "  constructed with count " << CFGetRetainCount(m_ptr) << endl;
        //}
    }

    Object::Object(const Object& rhs) :
        m_ptr(rhs.m_ptr)
    {
        //using namespace std;
        //cerr << "Copy construct " << typeName << " from rhs " << typeid(rhs).name() << endl;
        if (m_ptr) {
            //cerr << "  before retain: count " << CFGetRetainCount(m_ptr) << endl;
            CFRetain(m_ptr);
            //cerr << "  after retain: count " << CFGetRetainCount(m_ptr) << endl;
        }
    }

#if MTLPP_CONFIG_RVALUE_REFERENCES
    Object::Object(Object&& rhs) :
        m_ptr(rhs.m_ptr)
    {
        //using namespace std;
        //cerr << "Move construct " << typeName << " from rhs " << typeid(rhs).name() << endl;
        rhs.m_ptr = nullptr;
    }
#endif

    Object::~Object()
    {
        using namespace std;
        //cerr << "Destroy " << typeName << endl;

        if (m_ptr) {
            //cerr << "  before release: count " << CFGetRetainCount(m_ptr) << endl;
            //if (CFGetRetainCount(m_ptr) == 1)
            //    cerr << "  *** releasing object from assign operator" << endl;
            CFRelease(m_ptr);
            GarbageCollectExhaustively();
            //cerr << "  after release: count " << CFGetRetainCount(m_ptr) << endl;
        }
    }

    Object& Object::operator=(const Object& rhs)
    {
        using namespace std;
        //cerr << "Assign " << this << " from rhs " << &rhs << endl;

        if (rhs.m_ptr == m_ptr)
            return *this;
        if (rhs.m_ptr) {
            //cerr << "  rhs had " << CFGetRetainCount(rhs.m_ptr);
            CFRetain(rhs.m_ptr);
            //cerr << "  rhs now has  " << CFGetRetainCount(rhs.m_ptr);
        }
        if (m_ptr) {
            if (CFGetRetainCount(m_ptr) == 1)
                cerr << "  *** releasing object from assign operator" << endl;

            //cerr << "  lhs had " << CFGetRetainCount(m_ptr);
            CFRelease(m_ptr);
            //cerr << "  lhs now has  " << CFGetRetainCount(m_ptr);
        }
        m_ptr = rhs.m_ptr;
        return *this;
    }

#if MTLPP_CONFIG_RVALUE_REFERENCES
    Object& Object::operator=(Object&& rhs)
    {
        using namespace std;
        //cerr << "Move assign " << this << " from rhs " << &rhs << endl;
        if (rhs.m_ptr == m_ptr)
            return *this;
        if (m_ptr) {
            if (CFGetRetainCount(m_ptr) == 1)
                cerr << "  *** releasing object from move assign operator" << endl;
            CFRelease(m_ptr);
        }
        m_ptr = rhs.m_ptr;
        rhs.m_ptr = nullptr;
        return *this;
    }
#endif

    int Object::GetRetainCount() const
    {
        if (!m_ptr)
            return -1;
        return CFGetRetainCount(m_ptr);
    }

    uint32_t ArrayBase::GetSize() const
    {
        Validate();
        return uint32_t([(__bridge NSArray*)m_ptr count]);
    }

    void* ArrayBase::GetItem(uint32_t index) const
    {
        Validate();
        return (__bridge void*)[(__bridge NSArray*)m_ptr objectAtIndexedSubscript:index];
    }

    String::String(const char* cstr) :
        Object(Handle{ (__bridge void*)[NSString stringWithUTF8String:cstr] })
    {
    }

    const char* String::GetCStr() const
    {
        Validate();
        return [(__bridge NSString*)m_ptr cStringUsingEncoding:NSUTF8StringEncoding];
    }

    uint32_t String::GetLength() const
    {
        Validate();
        return uint32_t([(__bridge NSString*)m_ptr length]);
    }

    URL::URL(const char * cstr) :
        Object(Handle{ (__bridge void*)[NSURL fileURLWithPath:[NSString stringWithUTF8String:cstr]] })
    {
    }

    //const char* URL::GetCStr() const
    //{
    //    Validate();
    //    return [(__bridge NSURL*)m_ptr cStringUsingEncoding:NSUTF8StringEncoding];
    //}

    Error::Error() :
        Object(Handle{ (__bridge void*)[[NSError alloc] init] })
    {

    }

    String Error::GetDomain() const
    {
        Validate();
        return Handle{ (__bridge void*)[(__bridge NSError*)m_ptr domain] };
    }

    uint32_t Error::GetCode() const
    {
        Validate();
        return uint32_t([(__bridge NSError*)m_ptr code]);
    }

    //@property (readonly, copy) NSDictionary *userInfo;

    String Error::GetLocalizedDescription() const
    {
        Validate();
        return Handle{ (__bridge void*)[(__bridge NSError*)m_ptr localizedDescription] };
    }

    String Error::GetLocalizedFailureReason() const
    {
        Validate();
        return Handle{ (__bridge void*)[(__bridge NSError*)m_ptr localizedFailureReason] };
    }

    String Error::GetLocalizedRecoverySuggestion() const
    {
        Validate();
        return Handle{ (__bridge void*)[(__bridge NSError*)m_ptr localizedRecoverySuggestion] };
    }

    String Error::GetLocalizedRecoveryOptions() const
    {
        Validate();
        return Handle{ (__bridge void*)[(__bridge NSError*)m_ptr localizedRecoveryOptions] };
    }

    //@property (nullable, readonly, strong) id recoveryAttempter;

    String Error::GetHelpAnchor() const
    {
        Validate();
        return Handle{ (__bridge void*)[(__bridge NSError*)m_ptr helpAnchor] };
    }

    void GarbageCollectExhaustively()
    {
#if 0
        [[NSGarbageCollector defaultCollector] collectExhaustively];
#endif
    }
}
