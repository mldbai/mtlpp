/*
 * Copyright 2016-2017 Nikolay Aleksiev. All rights reserved.
 * License: https://github.com/naleksiev/mtlpp/blob/master/LICENSE
 */

#include "capture.hpp"
#include <Metal/MTLCaptureManager.h>
#include <Metal/MTLCaptureScope.h>
#include <Metal/MTLDevice.h>

namespace mtlpp
{

    void CaptureDescriptor::SetCaptureObject(const ns::Object & obj)
    {
        Validate();
        //[(__bridge MTLCaptureDescriptor *)m_ptr setCaptureObject:(__bridge NSObject*)obj.GetPtr()];
        [(__bridge MTLCaptureDescriptor *)m_ptr setCaptureObject:(__bridge id<NSObject>)obj.GetPtr()];
    }

    void CaptureDescriptor::SetCaptureDevice(const Device & device)
    {
        Validate();
        [(__bridge MTLCaptureDescriptor *)m_ptr setCaptureObject:(__bridge id<MTLDevice>)device.GetPtr()];
    }

    void CaptureDescriptor::SetCaptureCommandQueue(const CommandQueue & commandQueue)
    {
        Validate();
        [(__bridge MTLCaptureDescriptor *)m_ptr setCaptureObject:(__bridge id<MTLCommandQueue>)commandQueue.GetPtr()];
    }

    void CaptureDescriptor::SetCaptureScope(const CaptureScope & captureScope)
    {
        Validate();
        [(__bridge MTLCaptureDescriptor *)m_ptr setCaptureObject:(__bridge id<MTLCaptureScope>)captureScope.GetPtr()];
    }

    void CaptureDescriptor::SetDestination(CaptureDestination dest)
    {
        Validate();
        [(__bridge MTLCaptureDescriptor *)m_ptr setDestination:(MTLCaptureDestination)dest];
    }

    void CaptureDescriptor::SetOutputURL(const ns::URL & url)
    {
        Validate();
        [(__bridge MTLCaptureDescriptor *)m_ptr setOutputURL:(__bridge NSURL*)url.GetPtr()];
    }

    void CaptureScope::Begin()
    {
        Validate();
        [(__bridge id<MTLCaptureScope>)m_ptr beginScope];
    }

    void CaptureScope::End()
    {
        Validate();
        [(__bridge id<MTLCaptureScope>)m_ptr endScope];
    }

    Device CaptureScope::GetDevice() const
    {
        Validate();
        return ns::Handle{ (__bridge void*)[(__bridge id<MTLCaptureScope>)m_ptr device] };
    }

    CommandQueue CaptureScope::GetCommandQueue() const
    {
        Validate();
        return ns::Handle{ (__bridge void*)[(__bridge id<MTLCaptureScope>)m_ptr commandQueue] };
    }

    void CaptureScope::SetLabel(const ns::String& label)
    {
        Validate();
        [(__bridge id<MTLCaptureScope>)m_ptr setLabel:(__bridge NSString*)label.GetPtr()];
    }

    CaptureManager CaptureManager::GetShared()
    {
        return ns::Handle{ (__bridge void*)[MTLCaptureManager sharedCaptureManager] };
    }

    bool CaptureManager::SupportsDestination(CaptureDestination dest)
    {
        Validate();
        return [(__bridge MTLCaptureManager *)m_ptr supportsDestination:(MTLCaptureDestination)dest];
    }

    CaptureScope CaptureManager::MakeCaptureScope(const Device & device)
    {
        Validate();
        return ns::Handle{  (__bridge void*)[(__bridge MTLCaptureManager *)m_ptr newCaptureScopeWithDevice:(__bridge id<MTLDevice>)device.GetPtr()] };
    }

    CaptureScope CaptureManager::MakeCaptureScope(const CommandQueue & commandQueue)
    {
        Validate();
        return ns::Handle{  (__bridge void*)[(__bridge MTLCaptureManager *)m_ptr newCaptureScopeWithCommandQueue:(__bridge id<MTLCommandQueue>)commandQueue.GetPtr()] };
    }

    CaptureScope CaptureManager::GetDefaultCaptureScope() const
    {
        Validate();
        return ns::Handle{  (__bridge void*)[(__bridge MTLCaptureManager *)m_ptr defaultCaptureScope] };
    }

    void CaptureManager::SetDefaultCaptureScope(const CaptureScope & captureScope)
    {
        Validate();
        [(__bridge MTLCaptureManager *)m_ptr setDefaultCaptureScope:(__bridge id<MTLCaptureScope>)captureScope.GetPtr()];
    }

    bool CaptureManager::StartCapture(const CaptureDescriptor & descriptor, ns::Error * error)
    {
        Validate();

        // Error
        __autoreleasing NSError* nsError = nullptr;
        NSError * __autoreleasing * nsErrorPtr = error ? &nsError : nullptr;

        bool res = [(__bridge MTLCaptureManager *)m_ptr startCaptureWithDescriptor:(__bridge MTLCaptureDescriptor *)descriptor.GetPtr() error:nsErrorPtr];
        
        // Error update
        if (error && nsError){
            *error = ns::Handle{ (__bridge void*)nsError };
        }  

        return res;
    }

    void CaptureManager::StartCapture(const Device & device)
    {
        Validate();
        [(__bridge MTLCaptureManager *)m_ptr startCaptureWithDevice:(__bridge id<MTLDevice>)device.GetPtr()];
    }

    void CaptureManager::StopCapture()
    {
        Validate();
        [(__bridge MTLCaptureManager *)m_ptr stopCapture];
    }

    bool CaptureManager::IsCapturing() const
    {
        Validate();
        return [(__bridge MTLCaptureManager *)m_ptr isCapturing];
    }
}