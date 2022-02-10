/*
 * Copyright 2016-2017 Nikolay Aleksiev. All rights reserved.
 * License: https://github.com/naleksiev/mtlpp/blob/master/LICENSE
 */

#pragma once

#include "defines.hpp"
#include "ns.hpp"
#include "resource.hpp"

namespace mtlpp
{
    constexpr uint64_t CounterErrorValue = ((uint64_t)-1);
    constexpr int CounterDontSample = -1;

    struct CommonCounter {
        static ns::String Timestamp() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String TessellationInputPatches() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String VertexInvocations() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String PostTessellationVertexInvocations() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String ClipperInvocations() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String ClipperPrimitivesOut() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String FragmentInvocations() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String FragmentsPassed() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String ComputeKernelInvocations() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String TotalCycles() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String VertexCycles() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String TessellationCycles() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String PostTessellationVertexCycles() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String FragmentCycles() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String RenderTargetWriteCycles() MTLPP_AVAILABLE(10_15, 14_0);
    };

    struct CommonCounterSet {
        static ns::String Timestamp() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String StageUtilization() MTLPP_AVAILABLE(10_15, 14_0);
        static ns::String Statistic() MTLPP_AVAILABLE(10_15, 14_0);
    };

    struct CounterResultTimestamp {
        uint64_t timestamp;
    } MTLPP_AVAILABLE(10_15, 14_0);

    struct CounterResultStageUtilization {
        uint64_t totalCycles;
        uint64_t vertexCycles;
        uint64_t tessellationCycles;
        uint64_t postTessellationVertexCycles;
        uint64_t fragmentCycles;
        uint64_t renderTargetCycles;
    } MTLPP_AVAILABLE(10_15, 14_0);

    struct CounterResultStatistic {
        uint64_t tessellationInputPatches;
        uint64_t vertexInvocations;
        uint64_t postTessellationVertexInvocations;
        uint64_t clipperInvocations;
        uint64_t clipperPrimitivesOut;
        uint64_t fragmentInvocations;
        uint64_t fragmentsPassed;
        uint64_t computeKernelInvocations;
    } MTLPP_AVAILABLE(10_15, 14_0);

    class Counter : public ns::Object
    {
    public:
        Counter() { }
        Counter(const ns::RetainedHandle& handle) : ns::Object(handle) { }

        ns::String Name() const;
    }
    MTLPP_AVAILABLE(10_15, 14_0);

    class CounterSet : public ns::Object
    {
    public:
        CounterSet() { }
        CounterSet(const ns::RetainedHandle& handle) : ns::Object(handle) { }

        ns::String Name() const;
        ns::Array<Counter> Counters() const;
    }
    MTLPP_AVAILABLE(10_15, 14_0);

    class CounterSampleBufferDescriptor : public ns::Object {
        CounterSet GetCounterSet() const MTLPP_AVAILABLE(10_15, 14_0);
        void SetCounterSet(CounterSet counterSet) MTLPP_AVAILABLE(10_15, 14_0);
        ns::String GetLabel() const MTLPP_AVAILABLE(10_15, 14_0);
        void SetLabel() MTLPP_AVAILABLE(10_15, 14_0);
        StorageMode storageMode() const MTLPP_AVAILABLE(10_15, 14_0);
        uint32_t GetSampleCount() const MTLPP_AVAILABLE(10_15, 14_0);
        void SetSampleCount(uint32_t sampleCount) MTLPP_AVAILABLE(10_15, 14_0);
    } MTLPP_AVAILABLE(10_15, 14_0);

    class CounterSampleBuffer : public ns::Object {
        Device Device() const MTLPP_AVAILABLE(10_15, 14_0);
        ns::String Label() const MTLPP_AVAILABLE(10_15, 14_0);
        uint32_t SampleCount() MTLPP_AVAILABLE(10_15, 14_0);
    } MTLPP_AVAILABLE(10_15, 14_0);

}
