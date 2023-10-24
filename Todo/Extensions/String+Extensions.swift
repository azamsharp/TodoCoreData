//
//  String+Extensions.swift
//  Todo
//
//  Created by Mohammad Azam on 10/23/23.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool
    {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
