//: Playground - noun: a place where people can play

import UIKit
import ReactiveCocoa
import Result
import ReactiveSwift

// MARK:  Signal 部分
public func scopedExample(_ exampleDescription: String, _ action: () -> Void) {
    print("\n--- \(exampleDescription) ---\n")
    action()
}

public enum PlaygroundError: Error {
    case example(String)
}

// 我们通过Siganl.pipe()创建了一个信号和一个观察者。
// signal init方法有多种，下面会介绍
scopedExample("signal") {
    let (signal, observer) = Signal<Int, NoError>.pipe()
    
    signal.observe({ (signal) in
        print(signal)
    })
    
    observer.send(value: 1)
//    observer.sendCompleted()
    
    // 在Siwft中，通过pipe创建的信号是个热信号 类似与OC中的RACSubject系列，在RACSubject继承自RACSiganl又继承自RACStream，RACStream是一个Monad,它可以代表数据和数据的一系列的操作如map,flattenMap,bind
    // RACSubject又遵守了RACSubscriber协议，这个协议定义了可以发送数据的操作。
    // 所以RACSubject即是一个信号，又是一个观察者。
    
    // 直接通过生产者创建
    let signal1 = Signal<String, NoError>({ (observer) -> Disposable? in
        observer.send(value: "ash")
        print("sendCompleted")
        observer.sendCompleted()
        return AnyDisposable()
    })
    
    signal1.observe({ (signal) in
        print(signal)
    })
    
    let signal2 = Signal<String, PlaygroundError>.empty
    
    let observer2 = Signal<String, PlaygroundError>.Observer({ (event) in
        print(event)
        switch event {
        case .value(let value):
            print(value)
            break
        case .interrupted:
            print(event)
            break
        case .failed(let error):
            print(error)
            break
        case .completed:
            break
        }
    })
    
    signal2.observe(observer2)
    
    observer2.send(value: "233")
    
    let signal3 = Signal<String, PlaygroundError>.never
    
    signal3.observe(Signal<String, PlaygroundError>.Observer.init(value: { (str) in
        print(str)
    }, failed: { (error) in
        
    }, completed: {
        
    }, interrupted: {
        
    }))
    
    
    signal.observeCompleted {
        print("signal observeCompleted")
    }
    signal.observeValues({ (index) in
        print("signal observeValues value === \(index)")
    })
    signal.observeInterrupted {
        print("signal observeInterrupted")
    }
    
    observer.send(value: 3)
//    observer.sendInterrupted()
    observer.sendCompleted()
    
    signal.producer.startWithCompleted {
        print("signalProducer observeCompleted")
    }
    
}

scopedExample("SignalProducer") {
    
    var observer_s = Signal<String, PlaygroundError>.Observer()
    
    let producer = SignalProducer<String, PlaygroundError>({ (observer, _) in
        observer_s = observer
        print("New subscription, starting operation")
        observer.send(value: "ash")
        observer.send(value: "test2")
    })
    
    producer.start(Signal<String, PlaygroundError>.Observer.init({ (event) in
        print("observer1", event)
    }))
    
    producer.start({ (event) in
        print("observer2", event)
    })
    
    print("23333")
    
    producer.start({ (event) in
        print("observer3", event)
    })
    observer_s.send(value: "3333")
}

scopedExample("Property") {
    
    let label = UILabel()
    
    /// 两种写法其实是等效的
    let producer = label.reactive.producer(forKeyPath: "text").take(during: label.reactive.lifetime)
    
    let dynamicProperty = DynamicProperty<String>(object: label, keyPath: "text")
    
    producer.start({ (event) in
        print("producer", event)
    })
    
    dynamicProperty.producer.start({ (event) in
        print("dynamicProperty", event)
    })
    
    label.text = "2222"
    
    label.text = "3333"
    
    
    let property = MutableProperty("ash")
    
    let textFieldProperty = ValidatingProperty<String?, NoError>("") { input in
        return .valid
    }
    
    let textField = UITextField()
    
    textFieldProperty <~ textField.reactive.textValues
    
    label.reactive.text <~ property
    
    textFieldProperty.result.signal.observeValues({ (result) in
        print("result === ", result)
    })
    
    textField.text = "2333"
    
    textField.text = "45555"
    
    
}


