app "02"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.4.0/DI4lqn7LIZs8ZrCDUgLK-tHHpQmxGF1ZrlevRKq5LXk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.Path.{ Path },
        pf.File,
    ]
    provides [main] to pf

encoding = \str -> 
    when str is
        "A" | "X" -> Ok Rock
        "B" | "Y" -> Ok Paper
        "C" | "Z" -> Ok Scissors
        _ -> Err "Invalid encoding"

parseGame = \str ->
    str    
    |> Str.trim
    |> Str.split " "
    |> List.map encoding

singleScore = \choice ->
    when choice is
        Rock -> 1
        Paper -> 2
        Scissors -> 3

cycle = \choice -> 
    when choice is
        Rock -> Paper
        Paper -> Scissors
        Scissors -> Rock

matchScore = \a, b ->
    if a == b then 3
    else if a == cycle b then 0
    else 6

score = \{a, b} -> singleScore b + matchScore a b


encoding2 = \str -> 
    when str is
        "X" -> Ok Loss
        "Y" -> Ok Draw
        "Z" -> Ok Win
        _ -> Err "Invalid encoding"
    
transform = \a, b ->
    when b is
        Loss -> {a: a, b: cycle (cycle a)}
        Draw -> {a: a, b: a}
        Win  -> {a: a, b: cycle a}

parseGame2 = \str ->
    list = str |> Str.trim |> Str.split " "
    when list is
        [a, b] -> {a: encoding a, b: encoding2 b}
        _ -> {a: Err "Invalid encoding", b: Err "Invalid encoding"}

score2 = \{a, b} ->
    score (transform a b)

main =
    result <- File.readUtf8 (Path.fromStr "02/input.txt") |> Task.attempt
    fileContent = when result is 
        Ok content -> content
        _ -> ""
    
    games = fileContent 
        |> Str.split "\n" 
        |> List.map parseGame2

    socres = 
        game <- games |> List.map
        when game is
            {a: Ok a, b: Ok b} -> score2 {a, b}
            _ -> 0

    socres |> List.sum |> Num.toStr |> Stdout.line

    

    
