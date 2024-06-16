# Uber Rides Cancellation Analysis

This project aims to analyze Uber ride cancellations, focusing on two pickup points: the airport and the city. The analysis covers different times of the day to identify patterns and provide actionable recommendations to reduce cancellations and improve service efficiency.


## Introduction

Uber rides cancellation is a critical issue affecting customer satisfaction and operational efficiency. This project analyzes cancellation data to understand the factors influencing cancellations and provides recommendations to mitigate these issues. The analysis includes:

- Demand-supply gap analysis
- Correlation analysis between different variables

## Data Description

The dataset includes information on Uber ride cancellations and instances where no cars were available, categorized by:

- Status: `Cancelled` or `No Cars Available`
- Pickup Point: `Airport` or `City`
- Request date & time
- Drop date & time

## Analysis

### Demand-Supply Gap Analysis

Identifies times and locations with the highest demand-supply gap by comparing the number of completed trips with cancellations and instances of "No Cars Available".

### Correlation Analysis

Measures the strength of relationships between variables such as time of day, day of the week, and cancellation rates using correlation coefficients.


## Results

The key findings from the analysis are:

- **City Cancellations:** High during early morning and morning times.
- **Airport Cancellations:** Lower compared to the city but noticeable during night and evening times.
- **No Cars Available:** Significantly higher at the airport during evening and night times.

## Recommendations

1. Optimize driver allocation and incentives by increasing driver availability during peak times (early morning and morning for the City, evening and night for the Airport) through dynamic scheduling and offering incentives.
2. Implement predictive analytics and real-time monitoring to develop and integrate predictive models that anticipate high-demand periods and potential cancellations, allowing for swift adjustments.
3. Enhance customer communication and experience by informing customers about high-demand times to encourage pre-booking, utilizing notifications and reminders to manage expectations, and collecting and analyzing customer feedback to continuously improve service quality.

