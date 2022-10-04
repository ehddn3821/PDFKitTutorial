//
//  Cocktail.swift
//  PDFKitTutorial
//
//  Created by 앱지 Appg on 2022/10/04.
//

import Foundation

class Menu: Codable {
    var drinks: [Cocktail]?
    
    init(drinks: [Cocktail]? = nil) {
        self.drinks = drinks
    }
}

class Cocktail: Codable {
    var idDrink, strDrink: String?
    var strCategory, strAlcoholic: String?
    var strGlass, strInstructions: String?
    var strIngredient1, strIngredient2, strIngredient3, strIngredient4: String?
    var strMeasure1, strMeasure2, strMeasure3, strMeasure4: String?
    
    init(idDrink: String? = nil, strDrink: String? = nil, strCategory: String? = nil, strAlcoholic: String? = nil, strGlass: String? = nil, strInstructions: String? = nil, strIngredient1: String? = nil, strIngredient2: String? = nil, strIngredient3: String? = nil, strIngredient4: String? = nil, strMeasure1: String? = nil, strMeasure2: String? = nil, strMeasure3: String? = nil, strMeasure4: String? = nil) {
        self.idDrink = idDrink
        self.strDrink = strDrink
        self.strCategory = strCategory
        self.strAlcoholic = strAlcoholic
        self.strGlass = strGlass
        self.strInstructions = strInstructions
        self.strIngredient1 = strIngredient1
        self.strIngredient2 = strIngredient2
        self.strIngredient3 = strIngredient3
        self.strIngredient4 = strIngredient4
        self.strMeasure1 = strMeasure1
        self.strMeasure2 = strMeasure2
        self.strMeasure3 = strMeasure3
        self.strMeasure4 = strMeasure4
    }
}
