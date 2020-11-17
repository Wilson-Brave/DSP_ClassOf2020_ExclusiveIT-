import ballerina/grpc;
import ballerina/io;

public function main(string... args) {

    CaliBasedSongsStorageSystemBlockingClient blockingEp = new ("http://localhost:9090");

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

        io:print("This is An Error [!] => ");
        io:println("Your Error is => ", result.reason());

    } else {

        io:println(result);

    }
}


