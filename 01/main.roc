app "01"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.4.0/DI4lqn7LIZs8ZrCDUgLK-tHHpQmxGF1ZrlevRKq5LXk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ Task },
        pf.Path.{ Path },
        pf.File,
    ]
    provides [main] to pf

sumChunk = \chunk ->
    chunk
    |> Str.split "\n"
    |> List.map Str.trim
    |> List.walk 0 \state, elem ->
        when (Str.toNat elem) is
            Ok num -> state + num
            _ -> state

nMax = \list, n ->
    list
    |> List.sortDesc
    |> List.sublist { start: 0, len: n}

main =
    result <- File.readUtf8 (Path.fromStr "input.txt") |> Task.attempt
    fileContent = when result is 
        Ok content -> content
        _ -> ""
    
    chunks = fileContent 
        |> Str.split "\n\n" 
        |> List.map Str.trim

    sums = chunks |> List.map sumChunk

    nSum = sums |> nMax 3 |> List.sum

    nSum |> Num.toStr |> Stdout.line