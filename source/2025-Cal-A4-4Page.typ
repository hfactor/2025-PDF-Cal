// A4 4-Page Calendar for 2025 - 3 months per page, 3 columns
// Same style and design as the original calendar

// ============================================================================
// CONFIGURATION VARIABLES
// ============================================================================

// Basic Settings
#let year = 2025
#let font-family = "Helvetica"
#let font-size-date = 6pt
#let font-size-month = 7pt
#let font-size-year = 12pt

// A4 dimensions
#let page-width = 210mm
#let page-height = 297mm
#let margin = 0mm
#let content-width = page-width
#let content-height = page-height

// 4-page layout: 3 months per page, 3 columns
#let months-per-page = 3
#let num-columns = 3
#let column-width = content-width / num-columns

// Calculate optimal line height for A4 page
// A4 height: 297mm, title space: ~12mm, remaining: 285mm
// Max days in a month: 31, so: 285mm / 31 = ~9.44mm per line
#let line-height = 9.44mm  // Adjusted to fit in 4 pages

// Colors - using RGB(43,40,120) theme
#let date-color = rgb(43, 40, 120)  // Dark blue text
#let month-color = rgb(43, 40, 120)
#let weekend-color = rgb(80, 75, 140)  // Lighter blue for weekends
#let year-color = rgb(43, 40, 120)
#let weekend-bg-color = rgb(220, 225, 245)  // Light blue background for weekends
#let border-color = rgb("#cccccc")
#let border-thickness = 0.5pt
#let footer-color = rgb(100, 95, 160)  // Medium blue for attribution

// Set page to A4
#set page(
  paper: "a4",
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

// Check if a date is weekend (Saturday = 6, Sunday = 7)
#let is-weekend(day-of-week) = day-of-week == 6 or day-of-week == 7

// ============================================================================
// CALENDAR GENERATION
// ============================================================================

// Generate days for a specific month
#let generate-month-days(month) = {
  let days = ()
  let days_in_month = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  let days_in_current_month = days_in_month.at(month - 1)
  
  // Calculate starting day of week for the month
  let day_of_week = 3  // Jan 1, 2025 is Wednesday
  for m in range(1, month) {
    let days_in_prev_month = days_in_month.at(m - 1)
    for d in range(1, days_in_prev_month + 1) {
      day_of_week = if day_of_week == 7 { 1 } else { day_of_week + 1 }
    }
  }
  
  for day in range(1, days_in_current_month + 1) {
    let is_first_day_of_month = day == 1
    let is_weekend = is-weekend(day_of_week)
    
    days.push((
      month: month,
      day: day,
      day_of_week: day_of_week,
      is_first_day_of_month: is_first_day_of_month,
      is_weekend: is_weekend
    ))
    
    day_of_week = if day_of_week == 7 { 1 } else { day_of_week + 1 }
  }
  
  days
}

// ============================================================================
// CALENDAR LAYOUT
// ============================================================================

// Create a single day line - same format as original
#let create-day-line(day-data) = {
  let day_num = if day-data.day < 10 { "0" + str(day-data.day) } else { str(day-data.day) }
  
  let content = if day-data.is_first_day_of_month {
    let month_name = month-name(day-data.month)
    
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
    text(
      day_num,
      font: font-family,
      size: font-size-date,
      fill: if day-data.is_weekend { weekend-color } else { date-color }
    )
  }
  
  rect(
    width: column-width,
    height: line-height,
    stroke: (paint: border-color, thickness: border-thickness),
    fill: if day-data.is_weekend { weekend-bg-color } else { none },
    align(left + horizon, content)
  )
}

// Create a month column
#let create-month-column(month) = {
  let days = generate-month-days(month)
  let month_lines = ()
  
  for day in days {
    month_lines.push(create-day-line(day))
  }
  
  stack(..month_lines, dir: ttb, spacing: 0pt)
}

// ============================================================================
// MAIN CALENDAR
// ============================================================================

// Page 1: January - March
#let page1() = {
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
  
  let jan_col = create-month-column(1)
  let feb_col = create-month-column(2)
  let mar_col = create-month-column(3)
  
  stack(
    dir: ttb,
    spacing: 2pt,
    title_row,
    stack(
      dir: ltr,
      spacing: 0pt,
      jan_col,
      feb_col,
      mar_col
    )
  )
}

// Page 2: April - June
#let page2() = {
  let apr_col = create-month-column(4)
  let may_col = create-month-column(5)
  let jun_col = create-month-column(6)
  
  stack(
    dir: ltr,
    spacing: 0pt,
    apr_col,
    may_col,
    jun_col
  )
}

// Page 3: July - September
#let page3() = {
  let jul_col = create-month-column(7)
  let aug_col = create-month-column(8)
  let sep_col = create-month-column(9)
  
  stack(
    dir: ltr,
    spacing: 0pt,
    jul_col,
    aug_col,
    sep_col
  )
}

// Page 4: October - December
#let page4() = {
  let oct_col = create-month-column(10)
  let nov_col = create-month-column(11)
  let dec_col = create-month-column(12)
  
  stack(
    dir: ltr,
    spacing: 0pt,
    oct_col,
    nov_col,
    dec_col
  )
}

// Export all four pages
#page1()
#pagebreak()
#page2()
#pagebreak()
#page3()
#pagebreak()
#page4()
