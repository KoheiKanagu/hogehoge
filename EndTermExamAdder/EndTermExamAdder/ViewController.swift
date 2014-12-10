//
//  ViewController.swift
//  EndTermExamAdder
//
//  Created by Kohei on 2014/12/09.
//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.
//

import Cocoa
import EventKit

class ViewController: NSViewController {

    @IBOutlet var myTextField: NSTextField?
    @IBOutlet var myComboBox: NSComboBox?

    let eventStore = EKEventStore()
    var calEventList: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calEventList = eventStore.calendarsForEntityType(EKEntityTypeEvent)
        
        for var i=0; i<calEventList?.count; i++ {
            myComboBox?.insertItemWithObjectValue((calEventList![i] as EKCalendar).title, atIndex: (myComboBox?.numberOfItems)!)
        }
    }
    
    
    @IBAction func addButtonAction(sender: AnyObject) {
        if myComboBox?.indexOfSelectedItem == -1 {
            println("ComboBox未選択")
            return
        }
        let contents = loadHTML((myTextField?.stringValue)!)
        if contents == nil {
            println("HTMLが見つかりません")
            return
        }
        
        let year = (formalWithRule("<td align=\"right\" width=\"...\"><b>(.*)</b></td>", content: contents! as NSString)!)[0] as NSString
        let subjects = formalWithRule("<tr bgcolor=\"#FFFFFF\">\\n(.*\\n.*\\n.*\\n.*\\n.*\\n.*\\n.*\\n.*\\n).*\"center\">", content: contents!)!
        
        for string in subjects{
            let dateAndTimeRaw = formalWithRule("<td width=\"200\" align=\"center\">(.*)</td>", content: string as NSString)
            let dateAndTime = (dateAndTimeRaw![0] as NSString).componentsSeparatedByString("／")
            
            let date = dateAndTime[0] as NSString
            let time = dateAndTime[1] as NSString
            let name = (formalWithRule("<td name=\"rsunam_r\" width=\"286\">(.*)</td>", content: string as NSString)!)[0] as NSString
            let clas = (formalWithRule("<td name=\"clas\" align=\"center\" >(.*)</td>", content: string as NSString)!)[0] as NSString
            let teacher = (formalWithRule("<td name=\"kyoin\" width=\"162\">(.*)<br></td>", content: string as NSString)!)[0] as NSString
            
            let convertedDate = convertDate(rawYearString: year, rawDateString: date, rawTimeString: time)
            makeCalender(eventStore,
                title: name + clas,
                startDate: convertedDate.startTime,
                endDate: convertedDate.endTime,
                calendar: calEventList![myComboBox!.indexOfSelectedItem] as EKCalendar,
                 notes: teacher)
        }
    }
    
    func convertDate(#rawYearString: NSString, rawDateString: NSString, rawTimeString: NSString) -> (startTime: NSDate, endTime: NSDate) {
        let calender = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        
        let year = convertYear(rawYearString)
        components.year = year

        let array = rawDateString.componentsSeparatedByString("(")
        let array2 = (array[0] as NSString).componentsSeparatedByString("/")
        components.month = (array2[0] as NSString).integerValue
        components.day = (array2[1] as NSString).integerValue
        
        var convertedTime = convertTime(rawTimeString)
        components.hour = convertedTime.startTime!.hour
        components.minute = convertedTime.startTime!.minute
        let startTime = calender.dateFromComponents(components)
        
        components.hour = convertedTime.endTime!.hour
        components.minute = convertedTime.endTime!.minute
        let endTime = calender.dateFromComponents(components)
        
        return (startTime!, endTime!)
    }
    
    func convertYear(yearRawString: NSString) -> (Int) {
        let array = yearRawString.componentsSeparatedByString("&")
        var year: Int = ((array[0] as NSString).stringByReplacingOccurrencesOfString("年度", withString: "") as NSString).integerValue
        if (array[1] as NSString).hasSuffix("後期") {
            year++
        }
        return year
    }

    func convertTime(rawTimeString: NSString) -> (startTime: NSDateComponents?, endTime: NSDateComponents?) {
        switch rawTimeString {
        case "１時限":
            return (makeNSDateComponents(hour: 9, minute: 30), makeNSDateComponents(hour: 10, minute: 30))
        case "２時限":
            return (makeNSDateComponents(hour: 11, minute: 00), makeNSDateComponents(hour: 12, minute: 00))
        case "３時限":
            return (makeNSDateComponents(hour: 13, minute: 30), makeNSDateComponents(hour: 14, minute: 30))
        case "４時限":
            return (makeNSDateComponents(hour: 15, minute: 00), makeNSDateComponents(hour: 16, minute: 00))
        case "５時限":
            return (makeNSDateComponents(hour: 16, minute: 30), makeNSDateComponents(hour: 17, minute: 30))
        case "６時限":
            return (makeNSDateComponents(hour: 18, minute: 30), makeNSDateComponents(hour: 19, minute: 30))
        case "７時限":
            return (makeNSDateComponents(hour: 20, minute: 00), makeNSDateComponents(hour: 21, minute: 00))
        default:
            return (nil, nil)
        }
    }
    
    func makeNSDateComponents(#hour: Int, minute: Int) -> (NSDateComponents) {
        let components = NSDateComponents()
        components.hour = hour
        components.minute = minute
        return components
    }
    
    func loadHTML(pathString: NSString) -> (NSString?) {
        if pathString.length == 0 {
            return nil
        }
        
        let url: NSURL = NSURL(fileURLWithPath: pathString)!
        let contents = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil)
        return contents
    }
    
    
    func formalWithRule(rule:NSString, content:NSString) -> (NSArray?) {
        var resultArray = [NSString]()
        var error:NSError?
        
        let regex = NSRegularExpression(pattern: rule, options: NSRegularExpressionOptions.CaseInsensitive, error: &error);
        if error != nil {
            return nil
        }
        var matches = (regex?.matchesInString(content, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, content.length))) as Array<NSTextCheckingResult>
        for match:NSTextCheckingResult in matches {
            resultArray.append(content.substringWithRange(match.rangeAtIndex(1)))
        }
        return resultArray
    }
    
    func makeCalender(eventStore: EKEventStore, title: NSString, startDate: NSDate, endDate: NSDate, calendar: EKCalendar, notes: NSString) {
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted, error) -> Void in
            if !granted {
                println("カレンダーにアクセスできません")
                println("セキュリティとプライバシーからカレンダーへのアクセスを許可してください")
                return
            }
            
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.calendar = calendar
            event.notes = notes
            var error: NSErrorPointer = nil
            if eventStore.saveEvent(event, span: EKSpanThisEvent, commit: true, error: error) {
                NSLog("%@に%@を%@から%@までの予定として追加しました", calendar.title, title, startDate, endDate)
            }else{
                println("\(title)を追加できませんでした．")
            }
        })
    }
}

