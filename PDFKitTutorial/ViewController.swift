//
//  ViewController.swift
//  PDFKitTutorial
//
//  Created by 앱지 Appg on 2022/10/04.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    var pdfData: Data?

    @IBOutlet var queryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
    }

    @IBAction func tappedGeneratePDF(_ sender: Any) {
        NetworkManager.shared.getCocktails(searchQuery: queryTextField.text ?? "") { menu in
            if let drinks = menu.drinks {
                DispatchQueue.main.async {
                    let pdfData = self.generatePDFData(drinks: drinks)
                    self.pdfData = pdfData
                    self.performSegue(withIdentifier: "toPDFPreview", sender: self)
                }
            }
            else {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: nil, message: "No search result.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                    self.present(ac, animated: true)
                }
            }
        } failure: { error in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PDFPreviewViewController {
            vc.documentData = pdfData
        }
    }
    
    func generateDrinkText(drink: Cocktail, context: UIGraphicsPDFRendererContext, cursorY: CGFloat, pdfSize: CGSize) -> CGFloat {
        var cursor = cursorY
        let leftMargin: CGFloat = 74
        
        if let drinkName = drink.strDrink {
            cursor = context.addSingleLineText(fontSize: 14, weight: .bold, text:  drinkName, indent: leftMargin, cursor: cursor, pdfSize: pdfSize, annotation: .underline, annotationColor: .black)
            cursor+=6
            
            cursor = context.addSingleLineText(fontSize: 12, weight: .thin, text: "\(drink.strCategory ?? "Cocktail") | \(drink.strAlcoholic ?? "Might Contain Alcohol")", indent: leftMargin, cursor: cursor, pdfSize: pdfSize, annotation: nil, annotationColor: nil)
            cursor+=2
            
            cursor = addDrinkIngredients(drink: drink, context: context, cursorY: cursor, pdfSize: pdfSize)

            if let instructions = drink.strInstructions {
                cursor = context.addMultiLineText(fontSize: 9, weight: .regular, text: instructions, indent: leftMargin, cursor: cursor, pdfSize: pdfSize)
                cursor+=8
            }
            
            cursor+=8
        }
        return cursor
    }

    func addDrinkIngredients(drink: Cocktail, context: UIGraphicsPDFRendererContext, cursorY: CGFloat, pdfSize: CGSize) -> CGFloat {
        let ingredients = [drink.strIngredient1, drink.strIngredient2, drink.strIngredient3, drink.strIngredient4]
        let measures = [drink.strMeasure1, drink.strMeasure2, drink.strMeasure3, drink.strMeasure4]
        var cursor = cursorY
        let leftMargin: CGFloat = 74
        
        for i in 0..<ingredients.count {
            if let ingredient = ingredients[i], let measure = measures[i] {
                cursor = context.addSingleLineText(fontSize: 12, weight: .thin, text: " • \(ingredient) (\(measure))", indent: leftMargin, cursor: cursor, pdfSize: pdfSize, annotation: nil, annotationColor: nil)
                cursor+=2
            }
        }
        
        cursor+=8
        
        return cursor
    }
    
    func generatePDFData(drinks: [Cocktail]) -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "thecocktaildb",
            kCGPDFContextAuthor: "dwKang",
            kCGPDFContextTitle: "Cocktails Menu"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 10, y: 10, width: 595.2, height: 841.8)  // Page size is set A4
        let graphicsRenderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = graphicsRenderer.pdfData { context in
            context.beginPage()
            
            let initialCursor: CGFloat = 32
            
            var cursor = context.addCenteredText(fontSize: 32, weight: .bold, text: "Cocktail Menu 🍹", cursor: initialCursor, pdfSize: pageRect.size)
            
            cursor += 42  // Add white space after the Title
            
            for drink in drinks {
                cursor = generateDrinkText(drink: drink, context: context, cursorY: cursor, pdfSize: pageRect.size)
            }
        }
        return data
    }
}

