//
//  Events.swift
//  TaoKe
//
//  Created by jason tsang on 11/16/17.
//  Copyright © 2017 jason tsang. All rights reserved.
//
import RxBus

struct Events {
    struct ViewDidLoad: BusEvent {
    }
    struct WaterFallLayout: BusEvent {
    }
    struct Message: BusEvent {
        var count: Int = 0
    }
}
