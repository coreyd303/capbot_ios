//
//  ViewController.swift
//  ChatBot
//
//  Created by Corey Davis on 8/3/17.
//  Copyright © 2017 Corey Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!

    @IBOutlet weak var submitQuestionButton: UIButton!

    @IBOutlet weak var speechBubble: UIImageView!
    @IBOutlet weak var answerTextArea: UILabel!

    let client: HTTPClient = HTTPClient.shared!

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func doSubmitQuestion(_ sender: Any) {
        let urlString: String = "http://localhost:5000/response"
        guard let questionText: String = questionTextField.text?.lowercased() else {
            return
        }

        client.makeRequest(to: urlString, with: questionText) { answer in
            var theAnswer: String = "I'm sorry, something went wrong! I wasn't able to get an answer for your question. Check your network and try again!"

            if let answer = answer {

                do {
                    let json = try JSONSerialization.jsonObject(with: answer, options: []) as? NSDictionary

                    guard let names = json?["names"] as? NSArray else {
                        return
                    }
                    var nameList: String = ""
                    for name in names {
                        if (names.index(of: name)) == (names.count - 1) {
                            nameList.append("and \(name).")
                        } else {
                            nameList.append("\(name), ")
                        }

                    }

                    var questionForAnswer: String = ""
                    guard let lastChar = questionText.characters.last else {
                        return
                    }

                    if lastChar != "?" {
                        questionForAnswer = "\(questionText)?"
                    }

                    theAnswer = "You asked \(questionForAnswer) I was able to find the following people at CapTech that can help; \(nameList)"

                } catch {
                    theAnswer = "Whoa! Something is wrong with my data! It must be confused or corrupted. Let's try that again!"
                }

            }

            DispatchQueue.main.async {
                self.answerTextArea.text = theAnswer
            }

        }


    }

}

