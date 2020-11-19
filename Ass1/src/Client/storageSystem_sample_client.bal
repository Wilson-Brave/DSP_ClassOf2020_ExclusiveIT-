import ballerina/io;
public function main(string... args) {

    storageSystemBlockingClient blockingEp = new ("http://localhost:9090");

    clientRqRecord album = {

        date: "11/05/21",
        art: [
                {name: "abc", member: "YES"}
            ],
        band: "mino & Companies",
        son: [
                {title: "Memory", genre: "rap"}
            ]

    };

    var answer = blockingEp->addRecord(album);
    io:println(answer);

    RecUpdate update = {
        hashkey: "1234",
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
    var answerUpdate = blockingEp->updateRecord(update);
    io:println(answerUpdate);

}


