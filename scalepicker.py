import random, time, sys

keys = ["A", "B", "C", "D", "E", "F", "G"]
accidentals, qualities = ["A♭", "B♭", "D♭",
                          "E♭", "G♭", "C♯"], ["major", "minor"]
#qualities = ["major", "minor"]
keys.extend(accidentals)

# motivational quotes for happy practicing :)
motivation = [
    "You can do this!", "Live, laugh, love.", "Your teacher will be proud.",
    "Good luck!", "Nothing is impossible.", "No, this is Patrick!"
]

# colors
blue, red, fadegray, fadeblue, magenta, reset = "\033[0;94m", "\033[0;31m", "\033[2m", "\033[2;94m", "\033[0;35m", "\033[0m"


def intro():
    print(fadeblue + "░██████╗░█████╗░░█████╗░██╗░░░░░███████╗  ░██████╗░███████╗███╗░░██╗███████╗██████╗░░█████╗░████████╗░█████╗░██████╗░")
    print("██╔════╝██╔══██╗██╔══██╗██║░░░░░██╔════╝  ██╔════╝░██╔════╝████╗░██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗")
    print("╚█████╗░██║░░╚═╝███████║██║░░░░░█████╗░░  ██║░░██╗░█████╗░░██╔██╗██║█████╗░░██████╔╝███████║░░░██║░░░██║░░██║██████╔╝")
    print("░╚═══██╗██║░░██╗██╔══██║██║░░░░░██╔══╝░░  ██║░░╚██╗██╔══╝░░██║╚████║██╔══╝░░██╔══██╗██╔══██║░░░██║░░░██║░░██║██╔══██╗")
    print("██████╔╝╚█████╔╝██║░░██║███████╗███████╗  ╚██████╔╝███████╗██║░╚███║███████╗██║░░██║██║░░██║░░░██║░░░╚█████╔╝██║░░██║")
    print("╚═════╝░░╚════╝░╚═╝░░╚═╝╚══════╝╚══════╝  ░╚═════╝░╚══════╝╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝" + reset)
    # add some space
    print()
    print()


def clr(n):
    for _ in range(n):
        sys.stdout.write("\x1b[1A")
        sys.stdout.write("\x1b[2K")


lastq = motivation[0]  # to prevent the same quote generated twice in a row


def motivate():
    global lastq
    motivator = motivation[random.randint(0, (len(motivation) - 1))]
    while motivator == lastq:
        motivator = motivation[random.randint(0, (len(motivation) - 1))]
    return motivator


def scalegen():
    scale = keys[random.randint(0, (len(keys) - 1))] + " " + \
        qualities[random.randint(0, (len(qualities) - 1))]  # key + quality
    print(reset + "Your scale is " + blue + scale + ".")

    global lastq
    quote = motivate()
    lastq = quote
    print(magenta + quote + reset)


intro()
time.sleep(0.3)
scalegen()

ans = ""
while ans.lower() != "n":
    ans = input(fadegray + "Would you like to generate a new scale? [y/n]: ")
    if ans.lower() == "y":
        clr(3)
        scalegen()
    elif ans.lower() != "n":
        clr(1)
# after N or n is chosen
print()
print(red + "Go practice. :)")
time.sleep(1)
