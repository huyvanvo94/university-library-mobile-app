//
//  EmailConfirmationEvent.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/21/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

class EmailConformationEvent: AbstractEvent{
    let patron: Patron
    
    var state: EmailConformationState?
    
    weak var delegate: EmailConformationDelegate?{
        didSet{
            self.async_ProcessEvent()
        }
    }
    
    init(patron: Patron) {
        self.patron = patron
    }
    
    func async_ProcessEvent() {
        guard let delegate = self.delegate else{
            return
        } 
    }
}

protocol EmailConformationDelegate: AbstractEventDelegate {
    
}

enum EmailConformationState{
    case error
    case success
}
