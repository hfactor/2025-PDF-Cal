// A3 One Line Per Day Calendar for 2025
// A simple, clean calendar with one line for each day of the year - A3 version

// ============================================================================
// CONFIGURATION VARIABLES
// ============================================================================

// Basic Settings
#let year = 2025
#let font-family = "Helvetica"
#let font-size-date = 6pt  // Smaller font for more space
#let font-size-month = 7pt  // Smaller font for more space
#let font-size-year = 14pt  // Smaller font for more space

// A3 dimensions - use full page
#let page-width = 297mm  // A3 width
#let page-height = 420mm // A3 height
#let margin = 0mm  // No margins at all
#let content-width = page-width
#let content-height = page-height

// Column layout - 3 columns like A4
#let num-columns = 3  // 3 columns like A4
#let column-width = content-width / num-columns
#let lines-per-column = 122  // 365 / 3 = 121.67, so 122 lines per column

// Calculate optimal line height to fill A3 page completely
// A3 height: 420mm, title space: ~10mm, remaining: 410mm
// 122 lines per column, so: 410mm / 122 = ~3.39mm per line
#let line-height = 3.39mm  // Increased to eliminate remaining bottom space

// Colors - using RGB(43,40,120) theme
#let date-color = rgb(43, 40, 120)  // Dark blue text
#let month-color = rgb(43, 40, 120)
#let weekend-color = rgb(80, 75, 140)  // Lighter blue for weekends
#let year-color = rgb(43, 40, 120)
#let weekend-bg-color = rgb(220, 225, 245)  // Light blue background for weekends
#let border-color = rgb("#cccccc")  // Light grey border
#let border-thickness = 0.5pt
#let footer-color = rgb(100, 95, 160)  // Medium blue for attribution

// Set page to A3 with no margins
#set page(
  paper: "a3",
  margin: 0mm
)

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

// Get month names
#let month-name(month) = (
  ("January", "February", "March", "April", "May", "June",
   "July", "August", "September", "October", "November", "December").at(month - 1)
)

// Get day names
#let day-name(day) = (
  ("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday").at(day - 1)
)

// Check if a date is weekend (Saturday = 6, Sunday = 7)
#let is-weekend(day-of-week) = day-of-week == 6 or day-of-week == 7

// Format date with leading zeros
#let format-day(day) = (
  if day < 10 { "0" + str(day) } else { str(day) }
)

// Format month with leading zeros
#let format-month(month) = (
  if month < 10 { "0" + str(month) } else { str(month) }
)

// ============================================================================
// CALENDAR GENERATION
// ============================================================================

// Generate all days of 2025
#let generate-2025-days() = {
  let days = ()
  let current_month = 1
  let current_day = 1
  
  // Days in each month for 2025 (not a leap year)
  let days_in_month = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  
  // January 1, 2025 is a Wednesday (day 3 in our system: Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6, Sun=7)
  let day_of_week = 3
  
  for month in range(1, 13) {
    let days_in_current_month = days_in_month.at(month - 1)
    
    for day in range(1, days_in_current_month + 1) {
      let is_first_day_of_month = day == 1
      let is_weekend = is-weekend(day_of_week)
      
      days.push((
        month: month,
        day: day,
        day_of_week: day_of_week,
        is_first_day_of_month: is_first_day_of_month,
        is_weekend: is_weekend,
        date_string: format-month(month) + "/" + format-day(day) + "/" + str(year),
        day_name: day-name(day_of_week)
      ))
      
      // Move to next day of week
      day_of_week = if day_of_week == 7 { 1 } else { day_of_week + 1 }
    }
  }
  
  days
}

// ============================================================================
// CALENDAR LAYOUT
// ============================================================================

// Create a single day line - format: 01 on left, January on right
#let create-day-line(day-data) = {
  // Always format day as double digits
  let day_num = if day-data.day < 10 { "0" + str(day-data.day) } else { str(day-data.day) }
  
  let content = if day-data.is_first_day_of_month {
    // Show day on left, month name on right side of cell
    let month_name = month-name(day-data.month)
    
    // Create a grid with day on left, month on right
    grid(
      columns: 2,
      column-gutter: 0pt,
      row-gutter: 0pt,
      align: (left, center),
      text(
        day_num,
        font: font-family,
        size: font-size-date,
        fill: if day-data.is_weekend { weekend-color } else { date-color },
        weight: "bold"
      ),
      align(right, text(
        month_name,
        font: font-family,
        size: font-size-date,
        fill: if day-data.is_weekend { weekend-color } else { date-color }
      ))
    )
  } else {
    // Show just day number for other days
    text(
      day_num,
      font: font-family,
      size: font-size-date,
      fill: if day-data.is_weekend { weekend-color } else { date-color }
    )
  }
  
  // Create the actual line with border and weekend background
  rect(
    width: column-width,
    height: line-height,
    stroke: (paint: border-color, thickness: border-thickness),
    fill: if day-data.is_weekend { weekend-bg-color } else { none },
    align(left + horizon, content)
  )
}

// ============================================================================
// MAIN CALENDAR
// ============================================================================

// Create the complete calendar with columns
#let a3-calendar() = {
  let days = generate-2025-days()
  let year_title = text(
    str(year),
    font: font-family,
    size: font-size-year,
    fill: year-color,
    weight: "bold"
  )
  
  let attribution = text(
    "https://hiran.in | CC BY-SA 4.0",
    font: font-family,
    size: 5pt,
    fill: footer-color
  )
  
  let title_row = stack(
    dir: ltr,
    spacing: 0pt,
    year_title,
    align(right, attribution)
  )
  
  // Split days into 3 columns like A4
  let column1_days = days.slice(0, lines-per-column)
  let column2_days = days.slice(lines-per-column, 2 * lines-per-column)
  let column3_days = days.slice(2 * lines-per-column, 365)
  
  // Create day lines for each column
  let column1_lines = ()
  for day in column1_days {
    column1_lines.push(create-day-line(day))
  }
  
  let column2_lines = ()
  for day in column2_days {
    column2_lines.push(create-day-line(day))
  }
  
  let column3_lines = ()
  for day in column3_days {
    column3_lines.push(create-day-line(day))
  }
  
  // Create the three columns with NO spacing between rows
  let column1 = stack(..column1_lines, dir: ttb, spacing: 0pt)
  let column2 = stack(..column2_lines, dir: ttb, spacing: 0pt)
  let column3 = stack(..column3_lines, dir: ttb, spacing: 0pt)
  
  // Combine everything: title + three columns
  stack(
    dir: ttb,
    spacing: 2pt,  // Minimal spacing between title and columns
    title_row,
    stack(
      dir: ltr,
      spacing: 0pt,  // NO spacing between columns
      column1,
      column2,
      column3
    )
  )
}

// Export the calendar
#a3-calendar()
