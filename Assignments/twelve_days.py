days = [
    "First", "Second", "Third", "Fourth",
    "Fifth", "Sixth", "Seventh", "Eighth",
    "Ninth", "Tenth", "Eleventh", "Twelfth"
]

gifts = [
    "A Partridge in a Pear Tree",
    "Two Turtle Doves",
    "Three French Hens",
    "Four Colly Birds",
    "Five Gold Rings",
    "Six Geese-a-Laying",
    "Seven Swans-a-Swimming",
    "Eight Maids-a-Milking",
    "Nine Ldaies Dancing",
    "Ten Lords-a-Leaping",
    "Eleven Pipers Piping",
    "Twelve Drummers Drumming"
]

for day in range(12):
    print(
        f"On the {days[day]} day of Christmas "
        "my true love gave to me:"
    )

    for gift in range(day, -1, -1):
        if gift == 0 and day > 0:
            print(gifts[gift] + (", and" if gift == 1 else ""))
        else:
            print(gifts[gift] + (", and" if gift == 1 else ""))

    if day < 11:
        print()
