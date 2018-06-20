//
//  ObservableExtensionTests.swift
//  RxValidatorExampleTests
//
//  Created by 유금상 on 2018. 6. 20..
//  Copyright © 2018년 유금상. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
import RxCocoa
import RxValidator

class ObservableExtensionTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    func testObservableStringSuccess() {
        var result:String?
        
        let observable = PublishSubject<String>()
        
        observable
            .asObservable()
            .validate(StringIsAlwaysPass())
            .asObservable()
            .subscribe(onNext: { text in
                result = text
            })
            .disposed(by: disposeBag)
        
        let expectedString = "something string"
        observable.onNext(expectedString)
        expect(result).toEventually(equal(expectedString))
    }
    
    func testObservableStringFailure() {
        var result:RxValidatorResult = .valid
        
        let observable = PublishSubject<String>()
        
        observable
            .asObservable()
            .validate(StringIsShouldNotEmpty())
            .asObservable()
            .subscribe(onNext: { (text) in
                XCTFail()
            }, onError: { (error) in
                result = RxValidatorResult.determine(error: error)
            })
            .disposed(by: disposeBag)
        
        let expectedString = ""
        observable.onNext(expectedString)
        expect(result).toEventually(equal(RxValidatorResult.stringIsEmpty))
    }
}




//extension Observable where Element == Date {
//    func validate(_ validator: DateValidatorType) -> Observable<Element> {
//        do {
//            try validator.validate(Date(), granularity: Calendar.Component.nanosecond)
//        } catch {
//            return Observable.error(error)            
//        }
//        return self
//    }
//}
