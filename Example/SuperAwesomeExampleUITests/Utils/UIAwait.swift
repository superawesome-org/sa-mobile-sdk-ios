//
//  UIAwait.swift
//  SuperAwesomeExampleUITests
//
//  Created by Myles Eynon on 31/03/2023.
//

import Foundation

func UIAwait(forSeconds seconds: Int) {
    sleep(UInt32(seconds))
}

func UIAwait(forMilliseconds useconds: Int) {
    usleep(UInt32(useconds))
}
