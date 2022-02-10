/*
 * Copyright 2016-2017 Nikolay Aleksiev. All rights reserved.
 * License: https://github.com/naleksiev/mtlpp/blob/master/LICENSE
 */

#pragma once

#include "defines.hpp"
#include "ns.hpp"
#include "device.hpp"
#include "command_queue.hpp"

namespace mtlpp
{
    enum class CaptureDestination {
        DeveloperTools = 1,
        TraceDocument = 2,
    }
    MTLPP_AVAILABLE(11_0, 8_0);

    class CaptureScope : public ns::Object
    {
    public:
        CaptureScope() { }
        CaptureScope(const ns::RetainedHandle& handle) : ns::Object(handle) { }

        void Begin();
        void End();

        Device    GetDevice() const;
        CommandQueue GetCommandQueue() const;
        void SetLabel(const ns::String& label);
    }
    MTLPP_AVAILABLE(NA, 10_0);

    class CaptureDescriptor : public ns::Object
    {
    public:
        CaptureDescriptor() { }
        CaptureDescriptor(const ns::RetainedHandle& handle) : ns::Object(handle) { }

        void SetCaptureObject(const ns::Object & obj);
        void SetCaptureDevice(const Device & device);
        void SetCaptureCommandQueue(const CommandQueue & commandQueue);
        void SetCaptureScope(const CaptureScope & captureScope);
        void SetDestination(CaptureDestination dest);
        void SetOutputURL(const ns::URL & url);
    }
    MTLPP_AVAILABLE(NA, 10_0);

    class CaptureManager : public ns::Object
    {
    public:
        CaptureManager() { }
        CaptureManager(const ns::RetainedHandle& handle) : ns::Object(handle) { }

        static CaptureManager GetShared();

        bool SupportsDestination(CaptureDestination dest);

        CaptureScope MakeCaptureScope(const Device & device);
        CaptureScope MakeCaptureScope(const CommandQueue & commandQueue);

        CaptureScope GetDefaultCaptureScope() const;
        void SetDefaultCaptureScope(const CaptureScope & captureScope);

        bool StartCapture(const CaptureDescriptor & descriptor, ns::Error * error = nullptr);
        void StartCapture(const Device & device);
        void StopCapture();
        bool IsCapturing() const;
    }
    MTLPP_AVAILABLE(NA, 10_0);
}
