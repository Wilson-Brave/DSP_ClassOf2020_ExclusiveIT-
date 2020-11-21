import ballerina/crypto;
import ballerina/grpc;
import ballerina/io;
import ballerina/log;
// import ballerina/java.arrays;

listener grpc:Listener EndPoint = new (9090);

//Function declaration Start 

//Closes Readable Character Channel
function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream", err = result);
    }
}

// Closes Writable Character Channel
function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
            err = result);
    }
}

// Writes to JSON Database
function writeToDatabase(json content, string path) returns @tainted error? {
io:println("Writting Has Begun");
    io:WritableByteChannel wbc = check io:openWritableFile(path);
    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    closeWc(wch);
    io:println("Writting Has Concluded");
    return result;
}

//Reads From JSON Database
function readFromDatabase(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var  result = rch.readJson();
    closeRc(rch);
    return result;
}

//Function declaration Ends 

//Default Record For Testing Purposes
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
// json[] MusicCollection4rmDB = [];

boolean firstTime = true;

boolean NotFound = true;

// string DataBaseFileLocation = ".\\src\\Database\\MusicCollection.json";

service CaliBasedSongsStorageSystem on EndPoint {

    resource function Insert(grpc:Caller caller, Record value) {
        NotFound = true;
        string currentHASH = "N/A";

        if (firstTime) {
            // Default Object For Testing Purposes

            io:println("Enter FirstTime Loop [!]");

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

            map<json>|error DefaultRecord = map<json>.constructFrom(firstRecord);

            if (DefaultRecord is error) {

                io:println("Error Encountered Ref: Insert Method =>" + DefaultRecord.toString());

            } else {
                io:println("Defaut Hashing Has Begun [!]");
                string DefaultRecord_hashString = DefaultRecord.toString();

                byte[] DefaultRecord_hashByte = DefaultRecord_hashString.toBytes();

                byte[] DefaultRecord_actualHAsh = crypto:hashMd5(DefaultRecord_hashByte);

                DefaultRecord["Key"] = DefaultRecord_actualHAsh.toBase16();

                MusicCollection.push(DefaultRecord);

            }

        // Default Object For Testing Purposes Ends

        }

        //Ensure Default record only runs once
        firstTime = false;

        //Record Coming From Server
        map<json>|error InsertedRecord = map<json>.constructFrom(value);

        if (InsertedRecord is error) {
            io:println("Error Encountered Ref: Insert Method =>" + InsertedRecord.toString());

        } else {

            io:println("Hashing Has Begun [!]");
            string hashString = value.toString();
            byte[] hashByte = hashString.toBytes();
            byte[] actualHAsh = crypto:hashMd5(hashByte);
            InsertedRecord["Key"] = actualHAsh.toBase16();
            int index = 0;
            // MusicCollection.push(InsertedRecord);

            // json|error Data = readFromDatabase(DataBaseFileLocation);
            
            // MusicCollection4rmDB = <json> Data;

            int collectionLength = MusicCollection.length();

            while (true) {

                boolean isDuplicate = true;

                while (index <= collectionLength && NotFound) {

                    if (index == collectionLength) {
                      break;
                    }

                    io:println("collectionLength =>", collectionLength);
                    io:println("index =>", index);
                    json TempRecord = MusicCollection[index];
                    string currentHASH = <string>TempRecord.Key;                    // Error Occors here...
                    io:println("currentHASH =>", currentHASH);

                    if (currentHASH == InsertedRecord["Key"]) {

                        grpc:Error? result = caller->send({Key: InsertedRecord["Key"]});
                        result = caller->sendError(404, "Error Record Already Exisits.");
                        result = caller->complete();
                        isDuplicate = true;
                        NotFound = false;

                        break;

                    } else {

                        io:print(isDuplicate);
                        isDuplicate = false;
                        
                        io:print(isDuplicate);
                    }

                    index += index + 1;

                }


                //    io:println("Loop Has Exited Without Error");

                if (!isDuplicate) { 
                    string hashKey =<string> InsertedRecord.Key;
                    int RecVersion = <int> InsertedRecord.Version;
                    savedResponse SR = {RecordKey: hashKey , RecordVersion: RecVersion };
                    grpc:Error? result = caller->send(SR);
                    if (result is grpc:Error) {
                        result = caller->sendError(404, "Bad Response.\nRecord Not Added [!]");
                    }
                    MusicCollection.push(InsertedRecord);
                    result = caller->complete();
                    io:println("Success New Record Created [!]\n"); 

                }

            }

        }
    }

    resource function Update(grpc:Caller caller, updatedRecord value) {

    }



    resource function Delete(grpc:Caller caller, readKey value) {

    }


    resource function RecordRead(grpc:Caller caller, readKey currentHASH) {
            var collectionLength = MusicCollection.length();
            boolean found = false;
            var index = 0;

foreach var album in MusicCollection {
     io:println("************************************************************");
     io:println(album);
     io:println("************************************************************");
}


                while (index <= collectionLength && !found) {

                    json searchedRecord = MusicCollection[index];

                    // string HASH = <string>currentHASH.Key;

                    io:println("Search Query = >",currentHASH.recordKey);
                    io:println("Searched against = >",searchedRecord.Key);

                    if (currentHASH.recordKey == searchedRecord.Key) {
                        io:println("Record Found [ !]");
                        grpc:Error? result = caller->send(searchedRecord);
                        result = caller->complete();
                        found = true;
                        index = collectionLength;
                        break;
                             } else {
                                 io:println("Record Not Found [ !]");
                        index += index + 1;
                    }
                }


                //    io:println("Loop Has Exited Without Error");

                if (!found) {

                 grpc:Error?  result = caller->sendError(404,"Error Record Not Found.");
                 result = caller->complete();
                   
                    if (result is grpc:Error) {

                        result = caller->sendError(404, "Bad Response [!]");
                    }

                    
                }

            }


    resource function KeyVersionRead(grpc:Caller caller, savedResponse value) {



    }
    @grpc:ResourceConfig {streaming: true}
    resource function ReadByCriteria(grpc:Caller caller, criteria value) {

        var Title = value.Title ;
        var artistName = value.Title ;
        var bandName = value.Title ; 

        if (Title != "" && artistName != "" && bandName != "") {
            
        }

    }
}

public type Record record {|
    string RecordName = "";
    string RecordDate = "";
    string RecordBand = "";
    Song[] songList = [];
    Artist[] artistList = [];
    string Key = "";
    int 'Version = 0;

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

