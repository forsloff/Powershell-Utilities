function Get-NthDay {

    # Patch Tuesday

    # $dateTime = Get-Date -Month 6 -Year 2020
    # Get-NthDay -Ordinal 2 -Day Tuesday -Datetime $dateTime    
    # Tuesday, June 9, 2020 12:00:00 AM

    # Last Monday

    # $dateTime = Get-Date -Month 6 -Year 2020
    # Get-NthDay -Last -Day Tuesday -Datetime $dateTime
    # Tuesday, June 30, 2020 12:00:00 AM
    
    Param(
        
        [Int]$Ordinal,
        [Switch]$Last, 
        [ValidateSet("Monday", "Tuesday", "Wedensday", "Thursday", "Friday", "Saterday", "Sunday")]
        [String]$Day,
        [DateTime]$Datetime

    )

    if($null -eq $datetime) {
        $datetime = Get-Date
    }
    
    if($last) {

        $days_in_the_month = [DateTime]::DaysInMonth($datetime.Year, $dateTime.month)
        $last_day_of_the_month = Get-Date -Year $datetime.year -Month $datetime.month -Day $days_in_the_month -Hour 00 -Minute 00 -Second 00 -Millisecond 00
        $delta = ([DayOfWeek]::$day) - $last_day_of_the_month.DayOfWeek
        $last_variable_day_of_month = $last_day_of_the_month.AddDays($delta)
    
        if ($delta -gt 0) {
            $last_variable_day_of_month = $last_day_of_the_month.AddDays(-(7 - $delta))
        }
    
        return $last_variable_day_of_month
    
    } else {
        
        $date = Get-Date -Month $datetime.month -Year $datetime.year -Day 1 -Hour 00 -Minute 00 -Second 00 -Millisecond 00
        
        while ($date.DayofWeek -ne $day ) { 
            $date = $date.AddDays(1) 
        }

        return $date.AddDays(7 * ($ordinal - 1))
    
    }
}

$datetime = Get-Date -Day 14
$patch_tuesday = Get-NthDay -Ordinal 2 -Day Tuesday

$patch_tuesday_plus_two_days = $patch_tuesday.AddDays(2)

if(-not($datetime -ge $patch_tuesday_plus_two_days)){
    $datetime = (Get-date).AddMonths(-1)
}

$datetime