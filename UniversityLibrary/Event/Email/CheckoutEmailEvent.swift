//
// Created by Huy Vo on 12/6/17.
// Copyright (c) 2017 Huy Vo. All rights reserved.
//

import Foundation

class CheckoutEmailEvent: AbstractEvent{

    var transaction: String?

    let checkBookInfo: CheckoutBookInfo

    var delegate: AbstractEventDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }

    init(checkoutBookInfo: CheckoutBookInfo){
        
        self.checkBookInfo = checkoutBookInfo
    }


    deinit {

    }

    func async_ProcessEvent() {

        guard let delegate = self.delegate else {
            return
        }

        DataService.shared.confirmCheckout(
                bookInfo: self.checkBookInfo.bookInfo,
                email: self.checkBookInfo.email,
                transactionTime: self.checkBookInfo.transactionTime,
                dueDate: self.checkBookInfo.dueDate, completion: {(success) in

                    if success{

                        print("success")

                    }else{
                        print("error")

                    }




                })
    }
}
