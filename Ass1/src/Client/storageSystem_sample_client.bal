import ballerina/io;
public function main(string... args) {

    storageSystemBlockingClient blockingEp = new ("http://localhost:9090");

    clientRqRecord album = {

        date: "22/22/22",
        art: [
                {name: "Beetles", member: "Yes"}
            ],
        band: "Maximum & Companies",
        son: [
                {title: "Memories", genre: "rap"}
            ]

    };
io:println("------------------ADD/INSERT--------------------------");
    var answer = blockingEp->addRecord(album);
    io:println(answer);

    RecUpdate update = {
        hashkey: "9d736f43f4e8d38f616ae114b4aefede",
        ver: "1.1",
        Uprecord: {
            date: "11/05/20",
            art: [
                    {name: "abc", member: "YES"}
                ],
            band: "mino & Companies",
            son: [
                    {title: "Lost", genre: "Pop"}
                ]
        }

    };
    io:println("-----------------UPDATE---------------------------");
    var answerUpdate = blockingEp->updateRecord(update);
    io:println(answerUpdate);

    RecReadKey reading = {
        hashkey: "9d736f43f4e8d38f616ae114b4aefede"
        };
io:println("------------------READ--------------------------");
    var answerreading = blockingEp->readRecord(reading);
    io:println(answerreading);  
    io:println("--------------------------------------------");
}


