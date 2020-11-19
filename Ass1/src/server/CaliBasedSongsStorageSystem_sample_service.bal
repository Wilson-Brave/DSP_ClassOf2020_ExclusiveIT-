import ballerina/crypto;
import ballerina/grpc;
import ballerina/io;
// import ballerina/java.arrays;

listener grpc:Listener EndPoint = new (9090);


Record firsrRecord = {

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
        ]




};

json[] MusicCollection = [];
boolean firstTime = true;
boolean NotFound = true;
service CaliBasedSongsStorageSystem on EndPoint {

    resource function Insert(grpc:Caller caller, Record value) {
        NotFound = true;
        string currentHASH = "";
        if (firstTime) {

            // Default Object For Testing Purposes

            io:println("Enter FirstTime Loop [!]");

            Record firsrRecord = {

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

            map<json>|error DefaultRecord = map<json>.constructFrom(firsrRecord);

            if (DefaultRecord is error) {

                io:println("Error Encountered Ref: Insert Method =>" + DefaultRecord.toString());

            } else {

                // io:println("Defaut Hashing Has Begun [!]");
                string DefaultRecord_hashString = DefaultRecord.toString();

                byte[] DefaultRecord_hashByte = DefaultRecord_hashString.toBytes();

                byte[] DefaultRecord_actualHAsh = crypto:hashMd5(DefaultRecord_hashByte);

                DefaultRecord["Key"] = DefaultRecord_actualHAsh.toBase16();
                MusicCollection.push(DefaultRecord);
            }

        // Default Object For Testing Purposes Ends
        }

        //Ensure Deafult record only runs once
        firstTime = false;

        //Record Coming From The Server
        map<json>|error InsertedRecord = map<json>.constructFrom(value);

        if (InsertedRecord is error) {
            io:println("Error Encountered Ref: Insert Method =>" + InsertedRecord.toString());

        } else {

            // io:println("Hashing Has Begun [!]");
            string hashString = value.toString();
            byte[] hashByte = hashString.toBytes();
            byte[] actualHAsh = crypto:hashMd5(hashByte);
            InsertedRecord["Key"] = actualHAsh.toBase16();
            int index = 0;

            // MusicCollection.push(InsertedRecord);
            int collectionLength = MusicCollection.length();

            while (true) {

                boolean isDuplicate = true;

                while (index <= collectionLength && NotFound) {

                    if (index == collectionLength) {
                        break;
                    }

                    json TempRecord = MusicCollection[index];

                    currentHASH = <string>TempRecord.Key;


                    if (currentHASH == InsertedRecord["Key"]) {
                        io:println("Error Record Already Exisits.");
                        isDuplicate = true;
                        NotFound = false;
                        break;

                    } else {
                        isDuplicate = false;

                    }

                    index += index + 1;

                }


                //    io:println("Loop Has Exited Without Error");

                if (!isDuplicate) {

                    MusicCollection.push(InsertedRecord);

                    grpc:Error? result = caller->send({Key: currentHASH, Version: 1});

                    if (result is grpc:Error) {

                        result = caller->sendError(404, "Bad Response [!]");

                    }

                    result = caller->complete();

                    foreach var rec in MusicCollection {

                        io:println(rec.toString());
                        io:println();

                    }

                    io:println("Success New Record Created [!]");

                }

            }





        }



    }

    resource function Update(grpc:Caller caller, updatedRecord value) {



    }
    resource function Delete(grpc:Caller caller, readKey value) {



    }
    resource function RecordRead(grpc:Caller caller, readKey value) {



    }
    resource function KeyVersionRead(grpc:Caller caller, savedResponse value) {



    }
    @grpc:ResourceConfig {streaming: true}
    resource function ReadByCriteria(grpc:Caller caller, criteria value) {



    }
}

public type Record record {|
    string RecordName = "";
    string RecordDate = "";
    string RecordBand = "";
    Song[] songList = [];
    Artist[] artistList = [];
    string Key = "";
    int Version = 0;

|};

public type Song record {|
    string Title = "";
    string Genre = "";
    string SongPlatform = "";

|};


public type Artist record {|
    string artistName = "";
    boolean isMember = false;

|};


public type Confirmation record {|
    boolean confirm = false;

|};

public type readKey record {|
    string recordKey = "";

|};

public type criteria record {|
    string Title = "";
    string artistName = "";
    string bandName = "";

|};

public type RecordList record {|
    Record[] ListOfRecords = [];

|};

public type savedResponse record {|
    string RecordKey = "";
    int RecordVersion = 0;

|};

public type updatedRecord record {|
    string recordKey = "";
    int recordVersion = 0;
    Record? song = ();

|};



const string ROOT_DESCRIPTOR = "0A1270726F746F636F6C46696C652E70726F746F228C030A065265636F7264121E0A0A5265636F72644E616D65180120012809520A5265636F72644E616D65121E0A0A5265636F726444617465180220012809520A5265636F726444617465121E0A0A5265636F726442616E64180320012809520A5265636F726442616E6412280A08736F6E674C69737418042003280B320C2E5265636F72642E536F6E675208736F6E674C697374122E0A0A6172746973744C69737418052003280B320E2E5265636F72642E417274697374520A6172746973744C69737412100A034B657918062001280952034B657912180A0756657273696F6E180720012805520756657273696F6E1A560A04536F6E6712140A055469746C6518012001280952055469746C6512140A0547656E7265180220012809520547656E726512220A0C536F6E67506C6174666F726D180320012809520C536F6E67506C6174666F726D1A440A06417274697374121E0A0A6172746973744E616D65180120012809520A6172746973744E616D65121A0A0869734D656D626572180220012808520869734D656D62657222280A0C436F6E6669726D6174696F6E12180A07636F6E6669726D1801200128085207636F6E6669726D22270A07726561644B6579121C0A097265636F72644B657918012001280952097265636F72644B6579225C0A08637269746572696112140A055469746C6518012001280952055469746C65121E0A0A6172746973744E616D65180220012809520A6172746973744E616D65121A0A0862616E644E616D65180320012809520862616E644E616D65223B0A0A5265636F72644C697374122D0A0D4C6973744F665265636F72647318012003280B32072E5265636F7264520D4C6973744F665265636F72647322530A0D7361766564526573706F6E7365121C0A095265636F72644B657918012001280952095265636F72644B657912240A0D5265636F726456657273696F6E180220012805520D5265636F726456657273696F6E226F0A0C7570646174655265636F7264121C0A097265636F72644B657918012001280952097265636F72644B657912240A0D7265636F726456657273696F6E180220012805520D7265636F726456657273696F6E121B0A04736F6E6718032001280B32072E5265636F72645204736F6E673283020A1B43616C694261736564536F6E677353746F7261676553797374656D12210A06496E7365727412072E5265636F72641A0E2E7361766564526573706F6E736512260A06557064617465120D2E7570646174655265636F72641A0D2E436F6E6669726D6174696F6E12210A0644656C65746512082E726561644B65791A0D2E436F6E6669726D6174696F6E121F0A0A5265636F72645265616412082E726561644B65791A072E5265636F726412290A0E4B657956657273696F6E52656164120E2E7361766564526573706F6E73651A072E5265636F7264122A0A0E526561644279437269746572696112092E63726974657269611A0B2E5265636F72644C6973743001620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "protocolFile.proto": "0A1270726F746F636F6C46696C652E70726F746F228C030A065265636F7264121E0A0A5265636F72644E616D65180120012809520A5265636F72644E616D65121E0A0A5265636F726444617465180220012809520A5265636F726444617465121E0A0A5265636F726442616E64180320012809520A5265636F726442616E6412280A08736F6E674C69737418042003280B320C2E5265636F72642E536F6E675208736F6E674C697374122E0A0A6172746973744C69737418052003280B320E2E5265636F72642E417274697374520A6172746973744C69737412100A034B657918062001280952034B657912180A0756657273696F6E180720012805520756657273696F6E1A560A04536F6E6712140A055469746C6518012001280952055469746C6512140A0547656E7265180220012809520547656E726512220A0C536F6E67506C6174666F726D180320012809520C536F6E67506C6174666F726D1A440A06417274697374121E0A0A6172746973744E616D65180120012809520A6172746973744E616D65121A0A0869734D656D626572180220012808520869734D656D62657222280A0C436F6E6669726D6174696F6E12180A07636F6E6669726D1801200128085207636F6E6669726D22270A07726561644B6579121C0A097265636F72644B657918012001280952097265636F72644B6579225C0A08637269746572696112140A055469746C6518012001280952055469746C65121E0A0A6172746973744E616D65180220012809520A6172746973744E616D65121A0A0862616E644E616D65180320012809520862616E644E616D65223B0A0A5265636F72644C697374122D0A0D4C6973744F665265636F72647318012003280B32072E5265636F7264520D4C6973744F665265636F72647322530A0D7361766564526573706F6E7365121C0A095265636F72644B657918012001280952095265636F72644B657912240A0D5265636F726456657273696F6E180220012805520D5265636F726456657273696F6E226F0A0C7570646174655265636F7264121C0A097265636F72644B657918012001280952097265636F72644B657912240A0D7265636F726456657273696F6E180220012805520D7265636F726456657273696F6E121B0A04736F6E6718032001280B32072E5265636F72645204736F6E673283020A1B43616C694261736564536F6E677353746F7261676553797374656D12210A06496E7365727412072E5265636F72641A0E2E7361766564526573706F6E736512260A06557064617465120D2E7570646174655265636F72641A0D2E436F6E6669726D6174696F6E12210A0644656C65746512082E726561644B65791A0D2E436F6E6669726D6174696F6E121F0A0A5265636F72645265616412082E726561644B65791A072E5265636F726412290A0E4B657956657273696F6E52656164120E2E7361766564526573706F6E73651A072E5265636F7264122A0A0E526561644279437269746572696112092E63726974657269611A0B2E5265636F72644C6973743001620670726F746F33"

    };
}

