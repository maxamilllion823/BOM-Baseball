//
//  ContentView.swift
//  Book of Mormon Baseball
//
//  Created by Max Merrell on 12/4/23.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image("grass")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.45)

                VStack {
                    Spacer()
                    Text("⚾️  ⚾️  ⚾️  ⚾️  ⚾️").font(.system(size: 42))
                    Text("Book of Mormon").font(.system(size: 48))
                    Text("Baseball").font(.system(size: 48))
                    Text("⚾️  ⚾️  ⚾️  ⚾️  ⚾️").font(.system(size: 42))
                    Spacer()
                    NavigationLink(destination: InstructionsView(), label: {
                        Text("Instructions").font(.system(size: 28))
                    })
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    NavigationLink(destination: PlayView(), label: {
                        Text("Play").font(.system(size: 28))
                    })
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                    Spacer()
                }
            }
        }
    }
}

struct InstructionsView: View {
    var body: some View {
        VStack {
            Text("How To Play")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.center)
                .padding()
                .offset(y:-30)
            Text("Book of Mormon baseball is a simple game that will help the player gain more knowledge and familiarity with the Book of Mormon. \n\nA random verse from the Book of Mormon is shown and the player has three chances to correctly guess which book that verse is found in. Once the player has correctly guessed the book or used all three guesses, the player has three chances to guess which chapter that verse is found in. After a successful guess or the use of all three guesses, the correct book, chapter, and verse are shown. \n\nThe player then has the option to play again or click the “Read this verse in context“ button. This will take the player to the scripture in gospel library so that the context of the verse can be understood. Play ball!")
                .padding()
                .offset(y:-30)
        }
    }
}

struct PlayView: View {
        
    var data = parseCSV()
    @State var randNumber = Int.random(in: 0..<6604)
    @State var instructions = ""
    @State var instructions2 = "Guess the Book"
    @State var numStrikes = 0
    @State var strikeEmojis = ""
    @State var isChapter = true
    @State var isCorrect = false
    @State var buttonText = "Finalize Guess"
    
    @State private var bookSelection = "1 Ne."
    @State private var chapSelection = "0"
    
    @State var numbers = [""]
    let books = ["1 Ne.", "2 Ne.", "Jacob", "Enos", "Jarom", "Omni", "W o M", "Mosiah", "Alma", "Hel.", "3 Ne.", "4 Ne.", "Morm.", "Ether", "Moro."]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Strikes: \(numStrikes)")
                .font(
                    .title
                    .weight(.bold)
                    )
            Text(strikeEmojis)
                .font(.title)
            Spacer()
            //Text(data[randNumber][0] + " " + data[randNumber][1])

            Text("**\(data[randNumber][2])**  \(data[randNumber][3])").padding()
            
            
            Spacer()
            Text(instructions)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            Text (instructions2)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            HStack {
                Spacer()
                if (isChapter) {
                    Picker("", selection: $bookSelection) {
                        ForEach(books, id: \.self) {
                            Text($0)
                        }
                        
                    }
                    .pickerStyle(.menu)
                } else if (!isCorrect){
                    //switch

                    let correctBook = String(data[randNumber][0])
                    let numbers = createArray(Book: correctBook)
                    
                    Picker("", selection: $chapSelection) {
                        ForEach(numbers, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)
                }


                Spacer()
                
            }

            Button(buttonText) {
                if (isChapter) {
                    if (bookSelection == data[randNumber][0]) {
                        numStrikes = 0
                        strikeEmojis = ""
                        instructions = "Correct!! The Book is \(data[randNumber][0])"
                        instructions2 = "Guess the Chapter"
                        isChapter = false
                        
                    } else {
                        instructions2 = "Incorrect. Guess again!"
                        numStrikes += 1
                        strikeEmojis += "❌"
                        if (numStrikes == 3) {
                            instructions = "Incorrect. The book is \(data[randNumber][0])"
                            instructions2 = "Guess the Chapter"
                            numStrikes = 0
                            strikeEmojis = ""
                            isChapter = false
                        }
                        
                    }
                } else if (!isCorrect) {
                    if (chapSelection == data[randNumber][1]) {
                        instructions = ""
                        instructions2 = "Correct!! The scripture is \(data[randNumber][0]) \(data[randNumber][1]):\(data[randNumber][2])"
                        numStrikes = 0
                        strikeEmojis = ""
                        isCorrect = true
                        buttonText = "Play Again!"
                    } else {
                        instructions = "The book is \(data[randNumber][0])"
                        instructions2 = "Incorrect. Guess again!"
                        numStrikes += 1
                        strikeEmojis += "❌"
                        if (numStrikes == 3) {
                            instructions = ""
                            instructions2 = "Incorrect. The correct scripture is \(data[randNumber][0]) \(data[randNumber][1]):\(data[randNumber][2])"
                            numStrikes = 0
                            strikeEmojis = ""
                            isCorrect = true
                            buttonText = "Play Again!"
                        }
                    }
                } else {
                    randNumber = Int.random(in: 0..<6604)
                    instructions = ""
                    instructions2 = "Guess the Book"
                    buttonText = "Finalize Guess"
                    isCorrect = false
                    isChapter = true
                    bookSelection = "1 Ne."
                    chapSelection = "1"
                }
            }.buttonStyle(.borderedProminent)
            Spacer()
            if (isCorrect) {
                let correctBook = String(data[randNumber][0])
                let correctChap = String(data[randNumber][1])
                let correctVerse = String(data[randNumber][2])
                let linkURL = createLink(Book: correctBook, Chapter: correctChap, Verse: correctVerse)
                Link(destination: URL(string: linkURL)!) {
                    Text("Read this verse in context")
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        
    }

}

func createLink(Book: String, Chapter: String, Verse: String) -> String {
    var bookurl = ""
    switch Book {
    case "1 Ne.":
        bookurl = "1-ne"
    case "2 Ne.":
        bookurl = "2-ne"
    case "Jacob.":
        bookurl = "jacob"
    case "Enos":
        bookurl = "enos"
    case "Jarom":
        bookurl = "jarom"
    case "Omni":
        bookurl = "omni"
    case "W o M":
        bookurl = "w-of-m"
    case "Mosiah":
        bookurl = "mosiah"
    case "Alma":
        bookurl = "alma"
    case "Hel.":
        bookurl = "hel"
    case "3 Ne.":
        bookurl = "3-ne"
    case "4 Ne.":
        bookurl = "4-ne"
    case "Morm.":
        bookurl = "morm"
    case "Ether":
        bookurl = "ether"
    case "Moro.":
        bookurl = "moro"
    default:
        bookurl = "1-ne"
    }
    
    let link = "https://www.churchofjesuschrist.org/study/scriptures/bofm/" + bookurl + "/" + Chapter + "?lang=eng&id=" + Verse
    
    return link
    
}

func createArray(Book: String) -> [String] {
    var totalChapters = 0
    switch Book {
    case "1 Ne.":
        totalChapters = 22
    case "2 Ne.":
        totalChapters = 33
    case "Jacob.":
        totalChapters = 7
    case "Enos":
        totalChapters = 1
    case "Jarom":
        totalChapters = 1
    case "Omni":
        totalChapters = 1
    case "W o M":
        totalChapters = 1
    case "Mosiah":
        totalChapters = 29
    case "Alma":
        totalChapters = 63
    case "Hel.":
        totalChapters = 16
    case "3 Ne.":
        totalChapters = 30
    case "4 Ne.":
        totalChapters = 1
    case "Morm.":
        totalChapters = 9
    case "Ether":
        totalChapters = 15
    case "Moro.":
        totalChapters = 10
    default:
        totalChapters = 2
    }
    let numbers = (1...totalChapters).map { "\($0)" }
    //let numbers = ["0", "1"]
    return numbers
}


#Preview {
    ContentView()
}

