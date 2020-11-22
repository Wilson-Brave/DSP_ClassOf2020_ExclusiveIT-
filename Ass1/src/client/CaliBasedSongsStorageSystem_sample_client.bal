import ballerina/grpc;
import ballerina/io;


// This Prototy  Uses a built in Array of values in order to interact with the database in place of user input
AlbumEntries[] MyMusic = [];

public function main(string... args) {
    CaliBasedSongsStorageSystemBlockingClient blockingEp = new ("http://localhost:9090");


    //Writting a new records to the server -- Done.

    Record TheDedication = {

        RecordName: "Dedication",
        RecordDate: "12/13/2005",
        RecordBand: "Young Money",

        songList:
            [
                {

                    Title: "Dedication Intro",
                    Genre: "Rap",
                    SongPlatform: "Deezer"

                },
                {

                    Title: "Motivation",
                    Genre: "Rap",
                    SongPlatform: "Deezer"

                }

            ],

        artistList:
            [
                {artistName: "Lil Wayne", isMember: true},
                {artistName: "Mack Maine", isMember: true},
                {artistName: "Will Wonker", isMember: false}
            ],

        Key: "",
        Version: 1

    };

    Record theCarterV = {

        RecordName: "The Carter V",
        RecordDate: "06/24/2020",
        RecordBand: "Young Money",

        songList:
            [
                {

                    Title: "Don't Cry",
                    Genre: "Rap/hip Hop",
                    SongPlatform: "Deezer"

                },
                {

                    Title: "Mona Lisa",
                    Genre: "Rap",
                    SongPlatform: "Deezer"

                }

            ],

        artistList:
            [
                {artistName: "Lil Wayne", isMember: true},
                {artistName: "Kendrick Lamar", isMember: false},
                {artistName: "XXXTentacion", isMember: false}
            ],

        Key: "",
        Version: 1

    };

    // Adding Duplicate record To test Database Intagrity

    Record firstRecord = {

        RecordName: "RockSoul",
        RecordDate: "22/10/2020",
        RecordBand: "Mumford & Sons",

        songList:
            [
                {

                    Title: "There will be time",
                    Genre: "folk rock",
                    SongPlatform: "Deezer"

                },
                {

                    Title: "There will be Space",
                    Genre: "folk water",
                    SongPlatform: "Deezer"

                }
            ],

        artistList:
            [
                {artistName: "Winston Marshall", isMember: true},
                {artistName: "Ben Lovett", isMember: true},
                {artistName: "Baaba Maal", isMember: false}
            ],

        Key: "",
        Version: 1

    };

    // addNewRecord(firstRecord); // Returns Error, Record Already Exisits.

    Record DSP2020 =
    {
        RecordName: "I hate Ballerina",
        RecordDate: "24/06/2020",
        RecordBand: "Memes for Nust",
        songList: [
                {
                    Title: "Ballerina Sucks",
                    Genre: "Rock Metal",
                    SongPlatform: "Spotify"
                },
                {
                    Title: "Where's The Documentaion",
                    Genre: "Nightcore",
                    SongPlatform: "Spotify"
                },
                {
                    Title: "I Miss My Indians",
                    Genre: "Afrikaans Alternative",
                    SongPlatform: "Spotify"
                }
            ],

        artistList: [
                {artistName: "Willy Wonker", isMember: true},
                {artistName: "Wonker", isMember: true},
                {artistName: "Groupie", isMember: true}
            ],

        Key: "",
        Version: 1
    };


    TheDedication = addNewRecord(TheDedication);
    theCarterV = addNewRecord(theCarterV);
    DSP2020 = addNewRecord(DSP2020);


    //print Playlist of songs added to server
    printPlaylist(MyMusic);


    //Reading a Record From the Server => Key -- Done
    displayRecordSearched(theCarterV.RecordName, theCarterV.Key);

    //Reading a Record From the server -- N/A

    //Read By Band Name and Record Name
    criteria SearchCriteria = {Title: TheDedication.RecordName, bandName: TheDedication.RecordBand};
    printRecordsByCriteria(SearchCriteria);


//Updating a Record in the server -- N/A


}


function addNewRecord(Record newRecord) returns Record {

    CaliBasedSongsStorageSystemBlockingClient blockingEp = new ("http://localhost:9090");

    var result = blockingEp->Insert(newRecord);

    if (result is grpc:Error) {

        io:println("An Error [!] => ", result.toString());

        return newRecord;

    } else {

        savedResponse response = result[0];

        AlbumEntries e = {BandName: newRecord["RecordBand"], AlbumName: newRecord["RecordName"], HASHKey: response.RecordKey};
        MyMusic.push(e);

        newRecord.Key = response.RecordKey;
        io:println(newRecord.Key);
        return newRecord;

    }
}

function printRecordsByCriteria(criteria cr) {

    CaliBasedSongsStorageSystemBlockingClient blockingEp = new ("http://localhost:9090");

    var result = blockingEp->ReadByCriteria(cr);

    if (result is grpc:Error) {

        io:println("An Error [!] => ", result.toString());

    } else {
        if (cr.Title != "" && cr.bandName != "") {
            RecordList mySearch = result[0];
            Record[] playlist = mySearch.ListOfRecords;

            io:println("***********************SEARCH Criteria***********************************");
            io:println("Band Name         : ", cr.bandName);
            io:println("Record Title      : ", cr.Title);
            io:println("***********************SEARCH RESULT*************************************");
            foreach Record album in playlist {
                io:println("************************************************************");
                io:println("Searched Record Name : ", album.RecordBand);
                io:println("Searched Record Title : ", album.RecordName);
                io:println("Release Date : ", album.RecordDate);

                io:println("\nArtist :");
                Artist[]? artistList = album["artistList"];
                if (artistList is Artist[]) {
                    io:println("*********Artist List*********");
                    foreach Artist singer in artistList {
                        io:println("Singer Name      : ", singer.artistName);
                        io:println("Is a Mamember    : ", singer.artistName);

                    }
                }else {io:print("No Artist List Found[!]");}
                io:println("*************************************");
                io:println("\nSongs :");
                Song[]? songList = album["songList"];
                if (songList is Song[]) {
                    io:println("*********Song List*********");
                    foreach Song singer in songList {
                        io:println("Song Title         : ", singer.Title);
                        io:println("Song Genre           : ", singer.Genre);
                        io:println("Song SongPlatform    : ", singer.SongPlatform);
                    }
                } else {io:print("No TrackList Found[!]");}
                io:println("*************************************");


                io:println("***********************SEARCH RESULT End[!]***********************");


            }

        }

    }





}

function displayRecordSearched(string recordName, string RecordKey) {

    readKey recordToReadKey = {recordKey: RecordKey};

    Record|grpc:Error? albumChoice = readRecord(recordName, recordToReadKey);

    if (albumChoice is grpc:Error) {

        io:println("Error Encountered while Printing Record. [!]");

    } else {
        
        io:println("****************************Start****************************");
        io:println("************************************************************");
        io:println("Searched Record Name : ", recordName);
        io:println("Searched Record Key : ", RecordKey);
        io:println("***********************SEARCH RESULT***********************");
        io:println("\nRecord Name\t: ", albumChoice["RecordName"]);
        io:println("Date Of Release\t: ", albumChoice["RecordDate"]);
        io:println("Played By\t: ", albumChoice["RecordBand"]);
        io:println("Record Key\t: ", albumChoice["Key"]);
        io:println("Record Version\t: ", albumChoice["Version"]);

        io:println("\nArtist :");
        Artist[]? artistList = albumChoice["artistList"];
        if (artistList is Artist[]) {
        io:println("**********Artist List**********");
            foreach Artist singer in artistList {
                io:println("Singer Name      : ", singer.artistName);
                io:println("Is a Mamember    : ", singer.isMember);

            }
        }
        io:println("********************************");
        io:println("\nSongs :");
        Song[]? songList = albumChoice["songList"];
        if (songList is Song[]) {
        io:println("***********Song List************");
            foreach Song song in songList {
                io:println("Song Title         : ", song.Title);
                io:println("Song Genre           : ", song.Genre);
                io:println("Song SongPlatform    : ", song.SongPlatform);
            }
        }
        io:println("********************************");
        io:println();
        io:println("*****************************END****************************");
        io:println("************************************************************");

    }
}

function readRecord(string name, readKey value) returns grpc:Error|Record {

    CaliBasedSongsStorageSystemBlockingClient blockingEp = new ("http://localhost:9090");

    var result = blockingEp->RecordRead(value);

    if (result is grpc:Error) {

        io:println("An Error [!] => ", result.toString());

        return result;

    } else {

        Record response = result[0];
        return response;

    }
}

function printPlaylist(AlbumEntries[] playList) {
    int index = 0;
    int index2 = 0;
    foreach var album in playList {

        io:println("**************New Record*****************");
        io:println("Index = ", index);
        io:println("Record Name : ", album.AlbumName);
        io:println("Band Name : ", album.BandName);
        io:println("HASH Key : ", album.HASHKey);
        io:println("***********Created Successfully*********");
        index = index2 + 1;
        index2 = index;
        io:println();

    }

}

function recordToString(Record value) {

}

public type AlbumEntries record {

    string BandName = "";
    string AlbumName = "";
    string HASHKey = "";

};
