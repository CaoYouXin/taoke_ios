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
