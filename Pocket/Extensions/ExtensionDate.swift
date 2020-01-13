import UIKit

extension Date
{
    
    public enum DateTimeInterval {
        case Day, Week, Month, Year
    }
    
    public enum TimeZones : String{
        case UTC, LocalZone
    }
    
    // Get number of days in a month
    public static func getNumberOfDaysInMonth(date: Date) -> Int {
        
        let calendar = Calendar.current
        // Calculate start and end of the current month
        let interval = calendar.dateInterval(of: .month, for: date)!
        // Compute difference in days:
        let numDays = calendar.dateComponents([.day], from: interval.start, to: interval.end).day!
        
        return numDays
    }
    
    /// Converts date to string
    /// - parameters date: current date
    public static func formatDateAndTimezoneString(date: Date, dateFormat: String, timeZone: TimeZones) -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: timeZone.rawValue)

        return dateFormatter.string(from: date)
    }
    
/// Returning current date
    public static func formatDateAndTimezone(date: Date, dateFormat: String, timeZone: TimeZones) -> Date {
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = dateFormat
//        dateFormatter.timeZone = TimeZone(identifier: timeZone.rawValue)
//        dateFormatter.defaultDate = date
//
//        return Date()
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: date))
        return Date(timeInterval: seconds, since: date)
    }
    
    // Convert local time to UTC (or GMT)
//    func toGlobalTime() -> Date {
//        let timezone = TimeZone.current
//        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
//        return Date(timeInterval: seconds, since: self)
//    }
    
    /// Get start end dates  in UTC time
    /// Currently filtering by CURRENT, day, week, month, year (NOT from a chosen date)
    public static func getStartEndDates(timeInterval: DateTimeInterval) -> (String, String) {
        
        var dateComponentDayWeek = DateComponents() // Used for Day and Week
        let dateComponentMonthYear: DateComponents? // Used for Month and Year
        
        var startDate = Calendar.current.startOfDay(for: Date())
        var endDate: Date?
        
        switch timeInterval {
        
        case .Day:
            dateComponentDayWeek.day = 1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Week: // Week start is Sunday
            let gregorian = Calendar(identifier: .gregorian)
            startDate = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            dateComponentDayWeek.day = 7
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Month:
            dateComponentMonthYear = Calendar.current.dateComponents([.year, .month], from: Date())
            startDate = Calendar.current.date(from: dateComponentMonthYear!)!
            dateComponentDayWeek.month = 1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
            
        case .Year:
            dateComponentMonthYear = Calendar.current.dateComponents([.year], from: Date())
            startDate = Calendar.current.date(from: dateComponentMonthYear!)!
            dateComponentDayWeek.year = 1
            endDate = Calendar.current.date(byAdding: dateComponentDayWeek, to: startDate)
        }
        
        let startDateString =  formatDateAndTimezoneString(date: startDate, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC)
        
        return (
           startDateString,
           formatDateAndTimezoneString(date: endDate!, dateFormat: DatabaseEnum.Date.dataFormat.rawValue, timeZone: .UTC))
    }
}
