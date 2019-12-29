A = [100, 200, 50]
T = [20, 10, 5, 2.5]
D = [20, 100, 200, 50]
P = [
    "Sami Barchid",
    "Anthony Beuchey",
    "Vérane Martin",
    "Loris Pace",
    "Eryne Martin",
    "Antony Slimani"
]

N = 5

function shuffle(array) {
    array.sort(() => Math.random() - 0.5);
}

const scenario = [];

console.log("Participant\tTechnique\tDistance\tTaille\tDensite\tDirection\tBloc\tTrial")
for (let p of P) {
    const participant = []
    let blockNum = 0

    for (let d of D) {
        for (let t of T) {
            for (let a of A) {
                for (let i = 0; i < N; i++) {
                    // Ajout du participant avec la technique du "Bubble cursor"
                    participant.push(
                        [
                            p,
                            "B",
                            a,
                            t,
                            d,
                            i % 2 == 0 ? "L" : "R",
                            blockNum * 3,
                            i
                        ]
                    )

                    // Ajout du participant avec la technique du "standard pointer"
                    participant.push(
                        [
                            p,
                            "S",
                            a,
                            t,
                            d,
                            i % 2 == 0 ? "L" : "R",
                            blockNum * 3 + 1,
                            i
                        ]
                    )

                    // Ajout du participant avec la technique du "Line cursor"
                    participant.push(
                        [
                            p,
                            "L",
                            a,
                            t,
                            d,
                            i % 2 == 0 ? "L" : "R",
                            blockNum * 3 + 2,
                            i
                        ]
                    )
                }
                blockNum++
            }
        }
    }
    shuffle(participant);
    for (const pp of participant) {
        console.log(
            pp[0] + "\t" +
            pp[1] + "\t" +
            pp[2] + "\t" +
            pp[3] + "\t" +
            pp[4] + "\t" +
            pp[5] + "\t" +
            pp[6] + "\t" +
            pp[7]
        )
    }
}