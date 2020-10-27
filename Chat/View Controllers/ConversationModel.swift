//
//  ChatHelper.swift
//  Chat
//
//  Created by Maria Myamlina on 27.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ConversationModel {
    
    // MARK: - Friends
    
    static var friends: [ConversationTableViewCell.ConversationCellModel] = {
        let BenedictCumberbatch = ConversationTableViewCell.ConversationCellModel(name: "Benedict Cumberbatch", message: "Hello! I'm on the set of the new season of Sherlock, I'll call you later", date: Date(timeIntervalSinceNow: -10), isOnline: true, hasUnreadMessages: false)
        let JohnnyDepp = ConversationTableViewCell.ConversationCellModel(name: "Johnny Depp", message: "Tim Burton? Who is it?", date: Date(timeIntervalSinceNow: -1000), isOnline: true, hasUnreadMessages: false)
        let LeonardoDaVinci = ConversationTableViewCell.ConversationCellModel(name: "Leonardo DaVinci", message: "Where is Mona Lisa ???", date: Date(timeIntervalSinceNow: -2000), isOnline: true, hasUnreadMessages: true)
        let MonaLisa = ConversationTableViewCell.ConversationCellModel(name: "Mona Lisa", message: "I'm on a smoke break ... Tell DaVinci I'll be back soon", date: Date(timeIntervalSinceNow: -3000), isOnline: true, hasUnreadMessages: false)
        let CheshireCat = ConversationTableViewCell.ConversationCellModel(name: "Cheshire Cat", message: "Meeeeeeow", date: Date(timeIntervalSinceNow: -50000), isOnline: true, hasUnreadMessages: false)
        let PostmanPechkin = ConversationTableViewCell.ConversationCellModel(name: "Postman Pechkin", message: "I could not get to your house, I left mail on the doorstep. Your Pechkin", date: Date(timeIntervalSinceNow: -8000000), isOnline: true, hasUnreadMessages: true)
        let IvanGrozniy = ConversationTableViewCell.ConversationCellModel(name: "Ivan Grozniy", message: "I have an idea! How do you look at the introduction of the oprichnina ?!", date: Date(timeIntervalSinceNow: -9000000), isOnline: true, hasUnreadMessages: false)
        let AngelinaJolie = ConversationTableViewCell.ConversationCellModel(name: "Angelina Jolie", message: "", date: Date(timeIntervalSinceNow: -500), isOnline: true, hasUnreadMessages: false)
        let SpiderMan = ConversationTableViewCell.ConversationCellModel(name: "Spider Man", message: "", date: Date(timeIntervalSinceNow: -9500000), isOnline: true, hasUnreadMessages: false)
        let DanielRadcliffe = ConversationTableViewCell.ConversationCellModel(name: "Daniel Radcliffe", message: "", date: Date(timeIntervalSinceNow: -11000000), isOnline: true, hasUnreadMessages: false)
        let JenniferAniston = ConversationTableViewCell.ConversationCellModel(name: "Jennifer Aniston", message: "Your help is urgently needed!", date: Date(timeIntervalSinceNow: -20), isOnline: false, hasUnreadMessages: true)
        let VladimirPutin = ConversationTableViewCell.ConversationCellModel(name: "Vladimir Putin", message: "When will we introduce the second wave of coronavirus?", date: Date(timeIntervalSinceNow: -50), isOnline: false, hasUnreadMessages: false)
        let LordVoldemort = ConversationTableViewCell.ConversationCellModel(name: "Lord Voldemort", message: "It's just my nickname, actually my name is Tom Riddle. Nice to meet you", date: Date(timeIntervalSinceNow: -100), isOnline: false, hasUnreadMessages: true)
        let ParrotKesha = ConversationTableViewCell.ConversationCellModel(name: "Parrot Kesha", message: "Flew to Haiti. Kisses!", date: Date(timeIntervalSinceNow: -300), isOnline: false, hasUnreadMessages: false)
        let ArnoldSchwarzenegger = ConversationTableViewCell.ConversationCellModel(name: "Arnold Schwarzenegger", message: "I will be back... SOON", date: Date(timeIntervalSinceNow: -500), isOnline: false, hasUnreadMessages: false)
        let FedorDostoevskiy = ConversationTableViewCell.ConversationCellModel(name: "Fedor Dostoevskiy", message: "I was just attacked with an ax !!! What to do in such a situation?", date: Date(timeIntervalSinceNow: -2000), isOnline: false, hasUnreadMessages: true)
        let OlegTinkov = ConversationTableViewCell.ConversationCellModel(name: "Oleg Tinkov", message: "Busy now, negotiating with Yandex, I will answer later", date: Date(timeIntervalSinceNow: -10000), isOnline: false, hasUnreadMessages: true)
        let PeachGirl = ConversationTableViewCell.ConversationCellModel(name: "Peach Girl", message: "See you soon...", date: Date(timeIntervalSinceNow: -30000), isOnline: false, hasUnreadMessages: true)
        let GollumSmeagol = ConversationTableViewCell.ConversationCellModel(name: "Gollum Smeagol", message: "WHERE is my precious ?????", date: Date(timeIntervalSinceNow: -400000), isOnline: false, hasUnreadMessages: true)
        let MichelBuonarroti = ConversationTableViewCell.ConversationCellModel(name: "Michel Buonarroti", message: "When will you finish painting the Sistine Chapel?", date: Date(timeIntervalSinceNow: -1000000), isOnline: false, hasUnreadMessages: false)
        let JamesBond = ConversationTableViewCell.ConversationCellModel(name: "James Bond", message: "I'm on my way", date: Date(timeIntervalSinceNow: -2000000), isOnline: false, hasUnreadMessages: true)
        let AdolfHitler = ConversationTableViewCell.ConversationCellModel(name: "Adolf Hitler", message: "Hände hoch!", date: Date(timeIntervalSinceNow: -5000000), isOnline: false, hasUnreadMessages: false)
        let WinnieThePooh = ConversationTableViewCell.ConversationCellModel(name: "Winnie ThePooh", message: "", date: Date(timeIntervalSinceNow: -12000000), isOnline: false, hasUnreadMessages: false)
        
        var friends = [BenedictCumberbatch, JohnnyDepp, LeonardoDaVinci, MonaLisa, CheshireCat, PostmanPechkin, IvanGrozniy, AngelinaJolie, SpiderMan, DanielRadcliffe, JenniferAniston, VladimirPutin, LordVoldemort, ParrotKesha, ArnoldSchwarzenegger, FedorDostoevskiy, OlegTinkov, PeachGirl, GollumSmeagol, MichelBuonarroti, JamesBond, AdolfHitler, WinnieThePooh]
        

        friends.sort {
            if $0.isOnline && !$1.isOnline { return true }
            else if !$1.message.isEmpty && $1.message.isEmpty { return true }
            else { return false }
        }

        return friends
    }()
    
    
    // MARK: - Messages
    
    static var messages = {(person: String) -> [(MessageTableViewCell.MessageCellModel, UIColor, Date)] in
        var messages: [(MessageTableViewCell.MessageCellModel, UIColor, Date)] = []
        let currentTheme = Theme.current.themeOptions
        switch person {
        case "Benedict Cumberbatch":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi sweety"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -180)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How do you do?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -160)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm all good. There is no news, but another season will be filmed soon. I'm looking forward to it. There should be many interesting episodes in the new season, yesterday the first version of the text was sent. I miss you"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -140)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -110)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Do you have any news?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes, I met a cool girl the other day, she watches Sherlock! I look forward to introducing you"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -90)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Woooow, that's really cool!"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -80)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -50)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Helloooo"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -40)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Do you hear me?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -30)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Please, answer"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -25)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello! I'm on the set of the new season of Sherlock, I'll call you later"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -10)))
        case "Johnny Depp":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -7000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi there"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -6500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will you be here?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -6000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Sorry, I'm a little late: I got into a traffic jam near the Kremlin"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -5500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Now that I am back home I want to write straightaway and thank you for the present! How very kind of you to remember my birthday and what a lovely present!"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "You are welcome. Love you so much!"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -4500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -3500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Great, and you?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too. I have one question for you."), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -2000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Do you know Tim Burton?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Tim Burton? Who is it?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1000)))
        case "Leonardo DaVinci":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Sorry I haven't written to you for a long time. I have been very busy with my new project."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -9000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "That's okay, i have some work for you"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -8000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "A few months ago we wrote to you that we would like to have a young Christ, at the age of 12, written in your hand"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -7000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Let's meet in 5 minutes"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -6000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'll come to you"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Soon"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Waiting for you outside"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Where is Mona Lisa ???"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2000)))
        case "Mona Lisa":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello!"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -7800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi baby"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -7000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Let's meet today?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -6000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Unfortunately, I won't be able to do it today, I've already agreed to go on a date from Tinder. Let's meet tomorrow? I suggest going to the bar"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -5700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes, I agree"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -5400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Listen, I wanted to tell you for a long time that I recently cooked borscht, I liked it so much! I added a lot of different spices, and it turned out very tasty ... I am very sorry for you, too, to cook according to this recipe, I will tell you more when I meet"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -5300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "That's great"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -5200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'd like to try it too"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -5100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "It seem to be very tasty mmmmmmm"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm on a smoke break ... Tell DaVinci I'll be back soon"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -3000)))
        case "Cheshire Cat":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -54000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -53400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -53000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -52000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -51600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -51500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -51300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "What does it mean???"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -51000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey!?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -50600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -50000)))
        case "Postman Pechkin":
            messages.append((MessageTableViewCell.MessageCellModel(text: "You don't have to live like a cat and dog"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8012000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I can't talk to him. My tongue does not turn."), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -8010000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And let us write him a friendly letter."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8009000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "You have nothing to do, you write. I will not write him letters"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -8008000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "He can't even read. Letters must be delivered to him together with the postman"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8007000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Where are you?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8005000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Heeeey"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8004500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Youuu"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8003000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I am here"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8002000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And you???"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8000800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Anybody home?!"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8000600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Soooo that's a problem"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8000200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I could not get to your house, I left mail on the doorstep. Your Pechkin"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8000000)))
        case "Ivan Grozniy":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Our God is a Trinity, who formerly was He, now there is, the Father and the Son and the Holy Spirit, began to have below, below the end, we live and move about Him, and whose king reigns and the mighty write the truth; whoever was given the speed of the Only Begotten Word of God by Jesus Christ, our God, a victorious cherugu and an honorable cross"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -9008000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And nicholas is victorious, to the first in piety Tsar Konstyantin and all Orthodox tsar and maintainer of Orthodoxy, and even before the look of God's Word is everywhere fulfilled, to the Divine servants of God's Word all the universe, as if the eagles were flying swollen, even a spark of piety before the Russian kingdom:"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -9007000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "The autocracy of God by the will of the initiative from the great Rusky land by Holy Baptism, and the great Tsar Vladimir Manamaha, like the Greeks, will receive the most worthy honor, and the brave great Tsar Alexander Nevsky, who showed victory over the godless Germans, and the praises of the worthy great Tsar Dmitriy, like Don over the godless Hagarians"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -9006000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Even showed a great victory and to the avenger of untruths, our grandfather, the great sovereign Ivan, and in the sacred ancestors of the land of the acquirer, the blessed memory of our father, the great sovereign Vasily, even before us, the humble, the scepter of the Russian kingdom."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -9005000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I have an idea! How do you look at the introduction of the oprichnina ?!"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -9000000)))
        case "Angelina Jolie":
            return messages
        case "Spider Man":
            return messages
        case "Daniel Radcliffe":
            return messages
        case "Jennifer Aniston":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -3400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello darling"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "What's up?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -2000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm alright. At the weekend I was on the next shoot, I was very tired. I think I'll be sleeping all day next weekend. I also lost 5 kilograms"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And you?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Any news?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Everything is okay, thanks"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Jenni!!! I just wanted to say..."), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I was invited to an event, but I can't choose what to wear. There are clear regulations, and I need to pick up clothes in two days"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -150)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Please call me when you are free. We need to make an appointment and discuss everything"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Your help is urgently needed!"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -20)))
        case "Vladimir Putin":
            messages.append((MessageTableViewCell.MessageCellModel(text: "We see how the situation with the coronavirus epidemic in the world is developing sharply. In many countries, the number of cases continues to grow. The entire world economy was under attack, and its decline is already predicted"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Are you here?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yeah"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I am thinking..."), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Have a question for you"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will we introduce the second wave of coronavirus?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -50)))
        case "Lord Voldemort":
            messages.append((MessageTableViewCell.MessageCellModel(text: "My lord, if I could see any sign, a hint of your presence ..."), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "There were plenty of signs, my slippery friend, and there are even more hints!"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I hope you didn’t think I’ll keep my father’s fucking Muggle name. No. I chose a new name for myself, I knew: the day will come, and this name will be afraid to pronounce all the wizards, because I will become the greatest magician in the world."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Ohhhhh, nothing to say back."), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Greatness awakens envy, envy breeds anger, anger breeds lies. How do you like this quote? I want to tweet"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Pleeease answer"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello, Voldi"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "It's just my nickname, actually my name is Tom Riddle. Nice to meet you"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -100)))
        case "Parrot Kesha":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Kesha, how are you?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -9500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "It's me, your friend"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -8500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I live well, I swim in the pool, I drink juicy, orangeade ... Yes, yes - right without leaving the pool. I have many friends, a car, a personal chauffeur ... Sorry, old man, here Celentano came to me ..."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -7500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Wow, this is news"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -5500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -4500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -3500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Okay, and you?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Wonderful"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Miss you"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Miss you too"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Flew to Haiti. Kisses!"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -300)))
        case "Arnold Schwarzenegger":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -8500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -7500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -6500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Fine, you?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -5500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Too"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -4500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I just wanted to say that I will be late at work today and will come home very late. Microwave dinner if you can. The containers are in the refrigerator"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -3500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "See you"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Where are you?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I went to the mall to buy new clothes. I'll go to the grocery store at the same time, what should I buy?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Please buy meat, vegetables, bread, milk, eggs and cake"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "OK"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "No problem"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I will be back... SOON"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -500)))
        case "Fedor Dostoevskiy":
            messages.append((MessageTableViewCell.MessageCellModel(text: "I have a few smart thoughts, I want to share with you. One must love life more than the meaning of life. Freedom is not in not restraining yourself, but in being in control of yourself. In everything there is a line beyond which it is dangerous to cross; for once stepping over it is impossible to turn back. Happiness is not in happiness, but only in achieving it. No one will take the first step, because everyone thinks that it is not mutual. The people seem to enjoy their suffering for their Russians. Life goes breathless without an aim. To stop reading books is to stop thinking. There is no happiness in comfort; happiness is bought by suffering. In a truly loving heart, either jealousy kills love, or love kills jealousy."), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey!!!"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "What?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I have a problem"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I was just attacked with an ax !!! What to do in such a situation?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -2000)))
        case "Oleg Tinkov":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -41000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -40000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -39000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -38000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -37000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -36000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -35000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -34000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -33000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -32000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -31000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -30000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -29000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -28000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -27000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -26000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -25000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -24000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -23000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -22000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -21000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -20000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -19000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -18000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -17000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -16000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -15000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -14000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -13000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -12000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "AGAIN????? Come on! Let's talk"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -11000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now, negotiating with Yandex, I will answer later"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -10000)))
        case "Peach Girl":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Imagine, I recently met a guy: handsome, smart, wealthy, in short, there are one in a million. He invited me on a date, we went to the park at night, sat on a bench. So good! The moon shines so that you can read the newspaper! And do you know what this scoundrel did ?! He began to read the newspaper !!! I was completely disappointed in him, now I don't know what to do ... Any suggestions?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -39000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "This is really a problem. I have an idea! But it takes a very long time to write. I'm afraid I won't even fit in five messages, and I don't like recording voice messages"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -38000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Let's meet"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -37000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -36000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Tomorrow"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -33000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Excellent"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -32000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "See you soon..."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -30000)))
        case "Gollum Smeagol":
            messages.append((MessageTableViewCell.MessageCellModel(text: "The cold will penetrate to the heart Far from home - darkness and ice. Do not trust the traveler to anyone, When you walk through the darkness ... The path is not visible if the light disappeared, The moon does not shine, the sun does not ..."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -408000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "The fly buzzed, It got into the net, Do not cry and do not whine - Soon you will become food ..."), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -407000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -406000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -405000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -404000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -403000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -402000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -401500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -401000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -400500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -400100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -400000)))
        case "Michel Buonarroti":
            messages.append((MessageTableViewCell.MessageCellModel(text: "If pure love, if infinite respect, if a common destiny unites two loving hearts; if evil fate, pursuing one, hurts the other; if one mind, one will governs two hearts; if one soul in two bodily shells has achieved immortality and its wings are strong enough to lift both to heaven; if love with its golden arrow pierced at once and burns the chest of both; if one loves the other and neither of the two loves himself; if the highest happiness and joy for them is to strive for one goal; if all the love in the world does not constitute even a hundredth of that love, of that faith that binds them, can a moment of annoyance really destroy and untie such bonds?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1006000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When are you ready to start work?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1004000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Friday afternoon"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1002000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Okay, see you"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1001000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "See you on friday"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1000500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will you finish painting the Sistine Chapel?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1000000)))
        case "James Bond":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -2000000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1999900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How do you do?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1999800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Ok, you?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1999500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1999200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Any news?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1999000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "No"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1998700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "The same"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow:-1998500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will we meet?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1998000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Tomorrow?"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1997700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes!!!"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1997400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Bye"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1997000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Goodbye"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1996900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Did you buy that car?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1996800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "James?"), currentTheme.outputBubbleColor, Date(timeIntervalSinceNow: -1996500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm on my way"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -1996300)))
        case "Adolf Hitler":
            messages.append((MessageTableViewCell.MessageCellModel(text: "During the formation of the second troops away from the eyes and aviation, as well as in connection with the recent operations in the Balkans, a large number of my troops, about 80 divisions, accumulated "), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -5300000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hände hoch!"), currentTheme.inputBubbleColor, Date(timeIntervalSinceNow: -5000000)))
        default:
            break
        }
        
        return messages
    }
}
