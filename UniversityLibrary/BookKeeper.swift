//
//  BookKeeper.swift
//  UniversityLibrary
//
//  Created by Huy Vo on 11/19/17.
//  Copyright © 2017 Huy Vo. All rights reserved.
//

import Foundation

protocol BookKeeper: class {
    func checkout(book: Book)
    func waiting(book: Book)
}
