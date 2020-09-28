//
//  ChatHelper.swift
//  Chat
//
//  Created by Maria Myamlina on 27.09.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import UIKit

class ChatHelper {
    
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
        let DanielRadcliffe = ConversationTableViewCell.ConversationCellModel(name: "Daniel Radcliffe", message: "", date: Date(timeIntervalSinceNow: -7000000), isOnline: true, hasUnreadMessages: false)
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
        
        var friends = [BenedictCumberbatch, JohnnyDepp, LeonardoDaVinci, MonaLisa, CheshireCat, PostmanPechkin, IvanGrozniy, AngelinaJolie, SpiderMan, DanielRadcliffe, JenniferAniston, VladimirPutin, LordVoldemort, ParrotKesha, ArnoldSchwarzenegger, FedorDostoevskiy, OlegTinkov, PeachGirl, GollumSmeagol, MichelBuonarroti, JamesBond, AdolfHitler]
        
        friends.sort {
            if $0.isOnline && !$1.isOnline {
                return true
            } else {
                return false
            }
        }

        return friends
    }()
    
    
    // MARK: - Messages
    
    static var messages = {(person: String) -> [(MessageTableViewCell.MessageCellModel, UIColor, Date)] in
        var messages: [(MessageTableViewCell.MessageCellModel, UIColor, Date)] = []
        let greenColor = UIColor(red: 220/250, green: 247/250, blue: 197/250, alpha: 1)
        let greyColor = UIColor(red: 223/250, green: 223/250, blue: 223/250, alpha: 1)
        switch person {
        case "Benedict Cumberbatch":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey"), greenColor, Date(timeIntervalSinceNow: -200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi sweety"), greyColor, Date(timeIntervalSinceNow: -180)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How do you do?"), greenColor, Date(timeIntervalSinceNow: -160)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm all good. There is no news, but another season will be filmed soon. I'm looking forward to it. There should be many interesting episodes in the new season, yesterday the first version of the text was sent. I miss you"), greyColor, Date(timeIntervalSinceNow: -140)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too"), greenColor, Date(timeIntervalSinceNow: -110)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Do you have any news?"), greyColor, Date(timeIntervalSinceNow: -100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes, I met a cool girl the other day, she watches Sherlock! I look forward to introducing you"), greenColor, Date(timeIntervalSinceNow: -90)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Woooow, that's really cool!"), greyColor, Date(timeIntervalSinceNow: -80)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), greenColor, Date(timeIntervalSinceNow: -50)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Helloooo"), greenColor, Date(timeIntervalSinceNow: -40)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Do you hear me?"), greenColor, Date(timeIntervalSinceNow: -30)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Please, answer"), greenColor, Date(timeIntervalSinceNow: -25)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello! I'm on the set of the new season of Sherlock, I'll call you later"), greyColor, Date(timeIntervalSinceNow: -10)))
        case "Johnny Depp":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello"), greenColor, Date(timeIntervalSinceNow: -7000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi there"), greyColor, Date(timeIntervalSinceNow: -6500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will you be here?"), greenColor, Date(timeIntervalSinceNow: -6000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Sorry, I'm a little late: I got into a traffic jam near the Kremlin"), greyColor, Date(timeIntervalSinceNow: -5500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Now that I am back home I want to write straightaway and thank you for the present! How very kind of you to remember my birthday and what a lovely present!"), greenColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "You are welcome. Love you so much!"), greyColor, Date(timeIntervalSinceNow: -4500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello"), greenColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), greyColor, Date(timeIntervalSinceNow: -3500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), greenColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Great, and you?"), greyColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too. I have one question for you."), greenColor, Date(timeIntervalSinceNow: -2000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Do you know Tim Burton?"), greenColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Tim Burton? Who is it?"), greyColor, Date(timeIntervalSinceNow: -1000)))
        case "Leonardo DaVinci":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Sorry I haven't written to you for a long time. I have been very busy with my new project."), greyColor, Date(timeIntervalSinceNow: -9000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "That's okay, i have some work for you"), greenColor, Date(timeIntervalSinceNow: -8000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "A few months ago we wrote to you that we would like to have a young Christ, at the age of 12, written in your hand"), greenColor, Date(timeIntervalSinceNow: -7000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Let's meet in 5 minutes"), greyColor, Date(timeIntervalSinceNow: -6000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'll come to you"), greyColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Soon"), greyColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Waiting for you outside"), greenColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Where is Mona Lisa ???"), greyColor, Date(timeIntervalSinceNow: -2000)))
        case "Mona Lisa":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello!"), greenColor, Date(timeIntervalSinceNow: -7800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi baby"), greyColor, Date(timeIntervalSinceNow: -7000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Let's meet today?"), greenColor, Date(timeIntervalSinceNow: -6000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Unfortunately, I won't be able to do it today, I've already agreed to go on a date from Tinder. Let's meet tomorrow? I suggest going to the bar"), greyColor, Date(timeIntervalSinceNow: -5700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes, I agree"), greenColor, Date(timeIntervalSinceNow: -5400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Listen, I wanted to tell you for a long time that I recently cooked borscht, I liked it so much! I added a lot of different spices, and it turned out very tasty ... I am very sorry for you, too, to cook according to this recipe, I will tell you more when I meet"), greyColor, Date(timeIntervalSinceNow: -5300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "That's great"), greenColor, Date(timeIntervalSinceNow: -5200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'd like to try it too"), greenColor, Date(timeIntervalSinceNow: -5100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "It seem to be very tasty mmmmmmm"), greenColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm on a smoke break ... Tell DaVinci I'll be back soon"), greyColor, Date(timeIntervalSinceNow: -3000)))
        case "Cheshire Cat":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -54000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), greenColor, Date(timeIntervalSinceNow: -53400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -53000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), greenColor, Date(timeIntervalSinceNow: -52000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -51600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -51500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -51300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "What does it mean???"), greenColor, Date(timeIntervalSinceNow: -51000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey!?"), greenColor, Date(timeIntervalSinceNow: -50600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Meeeeeeow"), greyColor, Date(timeIntervalSinceNow: -50000)))
        case "Postman Pechkin":
            messages.append((MessageTableViewCell.MessageCellModel(text: "You don't have to live like a cat and dog"), greyColor, Date(timeIntervalSinceNow: -8012000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I can't talk to him. My tongue does not turn."), greenColor, Date(timeIntervalSinceNow: -8010000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And let us write him a friendly letter."), greyColor, Date(timeIntervalSinceNow: -8009000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "You have nothing to do, you write. I will not write him letters"), greenColor, Date(timeIntervalSinceNow: -8008000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "He can't even read. Letters must be delivered to him together with the postman"), greyColor, Date(timeIntervalSinceNow: -8007000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Where are you?"), greyColor, Date(timeIntervalSinceNow: -8005000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Heeeey"), greyColor, Date(timeIntervalSinceNow: -8004500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Youuu"), greyColor, Date(timeIntervalSinceNow: -8003000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I am here"), greyColor, Date(timeIntervalSinceNow: -8002000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And you???"), greyColor, Date(timeIntervalSinceNow: -8000800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Anybody home?!"), greyColor, Date(timeIntervalSinceNow: -8000600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Soooo that's a problem"), greyColor, Date(timeIntervalSinceNow: -8000200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I could not get to your house, I left mail on the doorstep. Your Pechkin"), greyColor, Date(timeIntervalSinceNow: -8000000)))
        case "Ivan Grozniy":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Our God is a Trinity, who formerly was He, now there is, the Father and the Son and the Holy Spirit, began to have below, below the end, we live and move about Him, and whose king reigns and the mighty write the truth; whoever was given the speed of the Only Begotten Word of God by Jesus Christ, our God, a victorious cherugu and an honorable cross"), greyColor, Date(timeIntervalSinceNow: -9008000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And nicholas is victorious, to the first in piety Tsar Konstyantin and all Orthodox tsar and maintainer of Orthodoxy, and even before the look of God's Word is everywhere fulfilled, to the Divine servants of God's Word all the universe, as if the eagles were flying swollen, even a spark of piety before the Russian kingdom:"), greyColor, Date(timeIntervalSinceNow: -9007000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "The autocracy of God by the will of the initiative from the great Rusky land by Holy Baptism, and the great Tsar Vladimir Manamaha, like the Greeks, will receive the most worthy honor, and the brave great Tsar Alexander Nevsky, who showed victory over the godless Germans, and the praises of the worthy great Tsar Dmitriy, like Don over the godless Hagarians"), greyColor, Date(timeIntervalSinceNow: -9006000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Even showed a great victory and to the avenger of untruths, our grandfather, the great sovereign Ivan, and in the sacred ancestors of the land of the acquirer, the blessed memory of our father, the great sovereign Vasily, even before us, the humble, the scepter of the Russian kingdom."), greyColor, Date(timeIntervalSinceNow: -9005000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I have an idea! How do you look at the introduction of the oprichnina ?!"), greenColor, Date(timeIntervalSinceNow: -9000000)))
        case "Angelina Jolie":
            return messages
        case "Spider Man":
            return messages
        case "Daniel Radcliffe":
            return messages
        case "Jennifer Aniston":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), greenColor, Date(timeIntervalSinceNow: -3400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello darling"), greyColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "What's up?"), greenColor, Date(timeIntervalSinceNow: -2000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm alright. At the weekend I was on the next shoot, I was very tired. I think I'll be sleeping all day next weekend. I also lost 5 kilograms"), greyColor, Date(timeIntervalSinceNow: -1000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "And you?"), greyColor, Date(timeIntervalSinceNow: -800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Any news?"), greyColor, Date(timeIntervalSinceNow: -700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Everything is okay, thanks"), greenColor, Date(timeIntervalSinceNow: -600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Jenni!!! I just wanted to say..."), greenColor, Date(timeIntervalSinceNow: -200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I was invited to an event, but I can't choose what to wear. There are clear regulations, and I need to pick up clothes in two days"), greenColor, Date(timeIntervalSinceNow: -150)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Please call me when you are free. We need to make an appointment and discuss everything"), greenColor, Date(timeIntervalSinceNow: -100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Your help is urgently needed!"), greenColor, Date(timeIntervalSinceNow: -20)))
        case "Vladimir Putin":
            messages.append((MessageTableViewCell.MessageCellModel(text: "We see how the situation with the coronavirus epidemic in the world is developing sharply. In many countries, the number of cases continues to grow. The entire world economy was under attack, and its decline is already predicted"), greyColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Are you here?"), greyColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yeah"), greenColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I am thinking..."), greenColor, Date(timeIntervalSinceNow: -1000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Have a question for you"), greenColor, Date(timeIntervalSinceNow: -100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will we introduce the second wave of coronavirus?"), greenColor, Date(timeIntervalSinceNow: -50)))
        case "Lord Voldemort":
            messages.append((MessageTableViewCell.MessageCellModel(text: "My lord, if I could see any sign, a hint of your presence ..."), greenColor, Date(timeIntervalSinceNow: -4000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "There were plenty of signs, my slippery friend, and there are even more hints!"), greyColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I hope you didn’t think I’ll keep my father’s fucking Muggle name. No. I chose a new name for myself, I knew: the day will come, and this name will be afraid to pronounce all the wizards, because I will become the greatest magician in the world."), greyColor, Date(timeIntervalSinceNow: -2000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Ohhhhh, nothing to say back."), greenColor, Date(timeIntervalSinceNow: -1000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Greatness awakens envy, envy breeds anger, anger breeds lies. How do you like this quote? I want to tweet"), greyColor, Date(timeIntervalSinceNow: -700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Pleeease answer"), greyColor, Date(timeIntervalSinceNow: -300)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello, Voldi"), greenColor, Date(timeIntervalSinceNow: -200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "It's just my nickname, actually my name is Tom Riddle. Nice to meet you"), greyColor, Date(timeIntervalSinceNow: -100)))
        case "Parrot Kesha":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Kesha, how are you?"), greenColor, Date(timeIntervalSinceNow: -9500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "It's me, your friend"), greenColor, Date(timeIntervalSinceNow: -8500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I live well, I swim in the pool, I drink juicy, orangeade ... Yes, yes - right without leaving the pool. I have many friends, a car, a personal chauffeur ... Sorry, old man, here Celentano came to me ..."), greyColor, Date(timeIntervalSinceNow: -7500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Wow, this is news"), greenColor, Date(timeIntervalSinceNow: -5500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey?"), greyColor, Date(timeIntervalSinceNow: -5000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes"), greenColor, Date(timeIntervalSinceNow: -4500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), greyColor, Date(timeIntervalSinceNow: -3500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Okay, and you?"), greenColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too"), greyColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Wonderful"), greenColor, Date(timeIntervalSinceNow: -600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Miss you"), greyColor, Date(timeIntervalSinceNow: -500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Miss you too"), greenColor, Date(timeIntervalSinceNow: -400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Flew to Haiti. Kisses!"), greyColor, Date(timeIntervalSinceNow: -300)))
        case "Arnold Schwarzenegger":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), greyColor, Date(timeIntervalSinceNow: -8500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hi"), greenColor, Date(timeIntervalSinceNow: -7500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How are you?"), greyColor, Date(timeIntervalSinceNow: -6500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Fine, you?"), greenColor, Date(timeIntervalSinceNow: -5500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Too"), greyColor, Date(timeIntervalSinceNow: -4500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I just wanted to say that I will be late at work today and will come home very late. Microwave dinner if you can. The containers are in the refrigerator"), greenColor, Date(timeIntervalSinceNow: -3500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "See you"), greenColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Where are you?"), greenColor, Date(timeIntervalSinceNow: -1500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I went to the mall to buy new clothes. I'll go to the grocery store at the same time, what should I buy?"), greyColor, Date(timeIntervalSinceNow: -900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Please buy meat, vegetables, bread, milk, eggs and cake"), greenColor, Date(timeIntervalSinceNow: -800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "OK"), greyColor, Date(timeIntervalSinceNow: -700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "No problem"), greyColor, Date(timeIntervalSinceNow: -600)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I will be back... SOON"), greyColor, Date(timeIntervalSinceNow: -500)))
        case "Fedor Dostoevskiy":
            messages.append((MessageTableViewCell.MessageCellModel(text: "I have a few smart thoughts, I want to share with you. One must love life more than the meaning of life. Freedom is not in not restraining yourself, but in being in control of yourself. In everything there is a line beyond which it is dangerous to cross; for once stepping over it is impossible to turn back. Happiness is not in happiness, but only in achieving it. No one will take the first step, because everyone thinks that it is not mutual. The people seem to enjoy their suffering for their Russians. Life goes breathless without an aim. To stop reading books is to stop thinking. There is no happiness in comfort; happiness is bought by suffering. In a truly loving heart, either jealousy kills love, or love kills jealousy."), greenColor, Date(timeIntervalSinceNow: -3000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey!!!"), greyColor, Date(timeIntervalSinceNow: -2700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "What?"), greenColor, Date(timeIntervalSinceNow: -2500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I have a problem"), greyColor, Date(timeIntervalSinceNow: -2100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I was just attacked with an ax !!! What to do in such a situation?"), greyColor, Date(timeIntervalSinceNow: -2000)))
        case "Oleg Tinkov":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -41000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -40000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -39000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -38000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -37000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -36000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -35000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -34000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -33000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -32000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -31000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -30000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -29000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -28000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -27000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -26000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -25000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -24000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -23000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -22000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -21000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -20000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -19000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -18000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -17000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -16000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -15000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -14000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Oleg?"), greenColor, Date(timeIntervalSinceNow: -13000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now"), greyColor, Date(timeIntervalSinceNow: -12000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "AGAIN????? Come on! Let's talk"), greenColor, Date(timeIntervalSinceNow: -11000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Busy now, negotiating with Yandex, I will answer later"), greyColor, Date(timeIntervalSinceNow: -10000)))
        case "Peach Girl":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Imagine, I recently met a guy: handsome, smart, wealthy, in short, there are one in a million. He invited me on a date, we went to the park at night, sat on a bench. So good! The moon shines so that you can read the newspaper! And do you know what this scoundrel did ?! He began to read the newspaper !!! I was completely disappointed in him, now I don't know what to do ... Any suggestions?"), greyColor, Date(timeIntervalSinceNow: -39000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "This is really a problem. I have an idea! But it takes a very long time to write. I'm afraid I won't even fit in five messages, and I don't like recording voice messages"), greenColor, Date(timeIntervalSinceNow: -38000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Let's meet"), greenColor, Date(timeIntervalSinceNow: -37000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When?"), greyColor, Date(timeIntervalSinceNow: -36000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Tomorrow"), greenColor, Date(timeIntervalSinceNow: -33000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Excellent"), greyColor, Date(timeIntervalSinceNow: -32000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "See you soon..."), greyColor, Date(timeIntervalSinceNow: -30000)))
        case "Gollum Smeagol":
            messages.append((MessageTableViewCell.MessageCellModel(text: "The cold will penetrate to the heart Far from home - darkness and ice. Do not trust the traveler to anyone, When you walk through the darkness ... The path is not visible if the light disappeared, The moon does not shine, the sun does not ..."), greyColor, Date(timeIntervalSinceNow: -408000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "The fly buzzed, It got into the net, Do not cry and do not whine - Soon you will become food ..."), greyColor, Date(timeIntervalSinceNow: -407000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -406000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -405000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -404000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -403000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -402000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -401500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -401000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -400500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -400100)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "WHERE is my precious ?????"), greyColor, Date(timeIntervalSinceNow: -400000)))
        case "Michel Buonarroti":
            messages.append((MessageTableViewCell.MessageCellModel(text: "If pure love, if infinite respect, if a common destiny unites two loving hearts; if evil fate, pursuing one, hurts the other; if one mind, one will governs two hearts; if one soul in two bodily shells has achieved immortality and its wings are strong enough to lift both to heaven; if love with its golden arrow pierced at once and burns the chest of both; if one loves the other and neither of the two loves himself; if the highest happiness and joy for them is to strive for one goal; if all the love in the world does not constitute even a hundredth of that love, of that faith that binds them, can a moment of annoyance really destroy and untie such bonds?"), greyColor, Date(timeIntervalSinceNow: -1006000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When are you ready to start work?"), greenColor, Date(timeIntervalSinceNow: -1004000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Friday afternoon"), greyColor, Date(timeIntervalSinceNow: -1002000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Okay, see you"), greenColor, Date(timeIntervalSinceNow: -1001000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "See you on friday"), greyColor, Date(timeIntervalSinceNow: -1000500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will you finish painting the Sistine Chapel?"), greenColor, Date(timeIntervalSinceNow: -1000000)))
        case "James Bond":
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hello"), greenColor, Date(timeIntervalSinceNow: -2000000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hey"), greyColor, Date(timeIntervalSinceNow: -1999900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "How do you do?"), greenColor, Date(timeIntervalSinceNow: -1999800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Ok, you?"), greyColor, Date(timeIntervalSinceNow: -1999500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Me too"), greenColor, Date(timeIntervalSinceNow: -1999200)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Any news?"), greyColor, Date(timeIntervalSinceNow: -1999000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "No"), greenColor, Date(timeIntervalSinceNow: -1998700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "The same"), greyColor, Date(timeIntervalSinceNow:-1998500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "When will we meet?"), greenColor, Date(timeIntervalSinceNow: -1998000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Tomorrow?"), greyColor, Date(timeIntervalSinceNow: -1997700)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Yes!!!"), greenColor, Date(timeIntervalSinceNow: -1997400)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Bye"), greenColor, Date(timeIntervalSinceNow: -1997000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Goodbye"), greyColor, Date(timeIntervalSinceNow: -1996900)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Did you buy that car?"), greenColor, Date(timeIntervalSinceNow: -1996800)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "James?"), greenColor, Date(timeIntervalSinceNow: -1996500)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "I'm on my way"), greyColor, Date(timeIntervalSinceNow: -1996300)))
        case "Adolf Hitler":
            messages.append((MessageTableViewCell.MessageCellModel(text: "During the formation of the second troops away from the eyes and aviation, as well as in connection with the recent operations in the Balkans, a large number of my troops, about 80 divisions, accumulated "), greyColor, Date(timeIntervalSinceNow: -5300000)))
            messages.append((MessageTableViewCell.MessageCellModel(text: "Hände hoch!"), greyColor, Date(timeIntervalSinceNow: -5000000)))
        default:
            break
        }
        
        return messages
    }
    
}

// MARK: - DateFormatter

func dateFormatter(date: Date, force onlyTime: Bool) -> String {
    
    let formatter = DateFormatter()
    if isToday(date: date) || onlyTime {
        formatter.dateFormat = "HH:mm"
    } else {
        formatter.dateFormat = "dd MMM"
    }
    return formatter.string(from: date)
}

func isToday(date: Date) -> Bool {
    let today = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date) == formatter.string(from: today)
}
