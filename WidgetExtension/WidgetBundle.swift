// The MIT License (MIT)
//
// Copyright (c) 2020-Present Paweł Wiszenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI
import WidgetKit

@main
struct WidgetExamplesWidgetBundle: WidgetBundle {
    var body: some Widget {
        WidgetBundle1().body
        WidgetBundle2().body
        WidgetBundle3().body
    }
}

struct WidgetBundle1: WidgetBundle {
    var body: some Widget {
        AppGroupWidget()
        ClockWidget()
        CoreDataWidget()
        CountdownWidget()
        DeepLinkWidget()
    }
}

struct WidgetBundle2: WidgetBundle {
    var body: some Widget {
        EnvironmentWidget()
        NetworkWidget()
        PreviewWidget()
        TimerWidget()
        URLImageWidget()
    }
}

struct WidgetBundle3: WidgetBundle {
    var body: some Widget {
        URLCachedImageWidget()
        IntentWidget()
        DynamicIntentWidget()
        LockScreenWidget()
    }
}
