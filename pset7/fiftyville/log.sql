-- Keep a log of any SQL queries you execute as you solve the mystery.
--All you know is that the theft took place on July 28, 2020 and that it took place on Chamberlin Street.
SELECT description
FROM crime_scene_reports
WHERE year = 2020 AND month = 7 AND day = 28
AND street = "Chamberlin Street";

-- description
-- Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse. 
-- Interviews were conducted today with three witnesses who were present at the time 
-- — each of their interview transcripts mentions the courthouse.

SELECT transcript
FROM interviews
WHERE year = 2020 AND month = 7
AND day = 28;

-- Sometime within ten minutes of the theft,
-- I saw the thief get into a car in the courthouse parking lot and drive away.
-- If you have security footage from the courthouse parking lot,
-- you might want to look for cars that left the parking lot in that time frame.
SELECT * FROM courthouse_security_logs
WHERE year = 2020 AND month = 7
AND day = 28 AND hour = 10
AND minute > 15 AND minute < 25;

-- I don't know the thief's name, but it was someone I recognized.
-- Earlier this morning, before I arrived at the courthouse,
-- I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.
SELECT * FROM atm_transactions
WHERE year = 2020 AND month = 7 AND day = 28
AND transaction_type = "withdraw"
AND atm_location = "Fifer Street";

-- Suspects from atm_transactions
246 | 28500762 | 2020 | 7 | 28 | Fifer Street | withdraw | 48
267 | 49610011 | 2020 | 7 | 28 | Fifer Street | withdraw | 50

-- As the thief was leaving the courthouse, they called someone who talked to them for less than a minute.
SELECT * FROM phone_calls WHERE duration < 60
AND year = 2020 AND month = 7 AND day = 28;

-- Suspects from phone_calls
id | caller | receiver | year | month | day | duration
221 | (130) 555-0289 | (996) 555-8899 | 2020 | 7 | 28 | 51
224 | (499) 555-9472 | (892) 555-8872 | 2020 | 7 | 28 | 36
233 | (367) 555-5533 | (375) 555-8161 | 2020 | 7 | 28 | 45
251 | (499) 555-9472 | (717) 555-1342 | 2020 | 7 | 28 | 50
254 | (286) 555-6063 | (676) 555-6554 | 2020 | 7 | 28 | 43
255 | (770) 555-1861 | (725) 555-3243 | 2020 | 7 | 28 | 49
261 | (031) 555-6622 | (910) 555-3251 | 2020 | 7 | 28 | 38
279 | (826) 555-1652 | (066) 555-9701 | 2020 | 7 | 28 | 55
281 | (338) 555-6650 | (704) 555-2131 | 2020 | 7 | 28 | 54

-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.
SELECT * FROM flights
WHERE year = 2020 AND month = 7 AND day = 29
ORDER BY hour;

-- Suspects from flights.
id | origin_airport_id | destination_airport_id | year | month | day | hour | minute
36 | 8 | 4 | 2020 | 7 | 29 | 8 | 20 -- this is the earliest flight purchased by the thief.
43 | 8 | 1 | 2020 | 7 | 29 | 9 | 30
23 | 8 | 11 | 2020 | 7 | 29 | 12 | 15
53 | 8 | 9 | 2020 | 7 | 29 | 15 | 20
18 | 8 | 6 | 2020 | 7 | 29 | 16 | 0


-- SUSPECTS from courthouse_security_logs
260 | 2020 | 7 | 28 | 10 | 16 | exit | 5P2BI95
261 | 2020 | 7 | 28 | 10 | 18 | exit | 94KL13X
262 | 2020 | 7 | 28 | 10 | 18 | exit | 6P58WS2
263 | 2020 | 7 | 28 | 10 | 19 | exit | 4328GD8
264 | 2020 | 7 | 28 | 10 | 20 | exit | G412CB7
265 | 2020 | 7 | 28 | 10 | 21 | exit | L93JTIZ
266 | 2020 | 7 | 28 | 10 | 23 | exit | 322W7JE
267 | 2020 | 7 | 28 | 10 | 23 | exit | 0NTHK55

-- I guess I found the thief's flights
-- I'll get his/her passport number from table passengers.
SELECT * FROM people JOIN passengers ON people.passport_number = passengers.passport_number
JOIN courthouse_security_logs ON courthouse_security_logs.license_plate = people.license_plate
WHERE year = 2020 AND month = 7
AND day = 28 AND hour = 10
AND minute > 15 AND minute < 25
AND flight_id = 36;

id | name | phone_number | passport_number | license_plate | flight_id | passport_number | seat | id | year | month | day | hour | minute | activity | license_plate
398010 | Roger | (130) 555-0289 | 1695452385 | G412CB7 | 36 | 1695452385 | 3B | 264 | 2020 | 7 | 28 | 10 | 20 | exit | G412CB7
686048 | Ernest | (367) 555-5533 | 5773159633 | 94KL13X | 36 | 5773159633 | 4A | 261 | 2020 | 7 | 28 | 10 | 18 | exit | 94KL13X
560886 | Evelyn | (499) 555-9472 | 8294398571 | 0NTHK55 | 36 | 8294398571 | 6C | 267 | 2020 | 7 | 28 | 10 | 23 | exit | 0NTHK55
467400 | Danielle | (389) 555-5198 | 8496433585 | 4328GD8 | 36 | 8496433585 | 7B | 263 | 2020 | 7 | 28 | 10 | 19 | exit | 4328GD8

--SUSPECTS
name
Roger
Ernest
Evelyn
Danielle

-- check bank_accounts
-- I found only 2 bank accounts, so 2 suspectives is left.

SELECT * FROM phone_calls WHERE duration < 60
AND year = 2020 AND month = 7 AND day = 28;

-- Ernest is the thief
SELECT name FROM people JOIN phone_calls ON people.phone_number = phone_calls.caller
WHERE people.id IN
(SELECT person_id FROM bank_accounts WHERE person_id IN
(SELECT people.id FROM people JOIN passengers ON people.passport_number = passengers.passport_number
JOIN courthouse_security_logs ON courthouse_security_logs.license_plate = people.license_plate
WHERE year = 2020 AND month = 7
AND day = 28 AND hour = 10
AND minute > 15 AND minute < 25
AND flight_id = 36))
AND duration < 60
AND year = 2020 AND month = 7 AND day = 28;

-- Let's find What city the thief escaped to
SELECT city FROM airports JOIN flights
ON airports.id = flights.destination_airport_id
WHERE year = 2020 AND month = 7 AND day = 29
ORDER BY hour LIMIT 1;

-- Let's find the accomplice
SELECT name FROM people JOIN phone_calls
ON people.phone_number = phone_calls.receiver
WHERE caller = "(367) 555-5533"
AND duration < 60
AND year = 2020 AND month = 7 AND day = 28;

-- this is the accomplice
(375) 555-8161

phone_number
(389) 555-5198
(367) 555-5533 -- this is the thief

account_number | person_id | creation_year
49610011 | 686048 | 2010
28500762 | 467400 | 2014

-- Instead of using nested queries,
-- we can also use join tables strategy to find the thief.
SELECT people.name FROM people JOIN phone_calls ON people.phone_number = phone_calls.caller
JOIN bank_accounts ON person_id = people.id
JOIN passengers ON people.passport_number = passengers.passport_number
JOIN courthouse_security_logs ON courthouse_security_logs.license_plate = people.license_plate
WHERE courthouse_security_logs.year = 2020 AND courthouse_security_logs.month = 7
AND courthouse_security_logs.day = 28 AND hour = 10 AND minute > 15 AND minute < 25
AND flight_id = 36
AND duration < 60
AND phone_calls.year = 2020 AND phone_calls.month = 7 AND phone_calls.day = 28;