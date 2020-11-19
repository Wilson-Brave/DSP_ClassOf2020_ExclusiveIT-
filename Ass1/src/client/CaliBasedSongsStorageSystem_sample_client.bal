import ballerina/grpc;
import ballerina/io;

public function main(string... args) {

    CaliBasedSongsStorageSystemBlockingClient blockingEp = new ("http://localhost:9090");


    //Writting a new record to the server -- Done.
    var result = blockingEp->Insert({

        RecordName: "I hate Ballerina",
        RecordDate: "24/06/2020",
        RecordBand: "Flames By Nust",

        songList: [
                {
                    Title: "Willys Tunes",
                    Genre: "Rock Metal",
                    SongPlatform: "Spotify"
                },
                {
                    Title: "Wonkers Tunes",
                    Genre: "Nightcore",
                    SongPlatform: "Spotify"
                },
                {
                    Title: "Goupies Tunes",
                    Genre: "Afrikaans Alternative",
                    SongPlatform: "Spotify"
                }
            ],

        artistList: [
                {artistName: "Willy", isMember: true},
                {artistName: "Wonker", isMember: true},
                {artistName: "Groupie", isMember: true}
            ],

        Key: "",
        Version: 1

    });

    if (result is grpc:Error) {

        io:println("An Error [!] => ");
        io:println("Your Error is => ", result);

    } else {

        io:println(result);

    }

//Updating a Record in the server -- N/A


//Reading a Record From the server -- N/A


//Reading a Record From the server -- N/A




}


