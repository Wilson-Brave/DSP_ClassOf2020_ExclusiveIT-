import ballerina/grpc;
import ballerina/io;
import ballerina/crypto;
import ballerina/log;
import ballerina/lang.'float;


listener grpc:Listener ep = new (9090);
// int Count = 0;

function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",err = result);
    }
}

function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}
function write(json content, string path) returns @tainted error? {

    io:WritableByteChannel wbc = check io:openWritableFile(path);

    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    closeWc(wch);
    return result;
}


function read(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    closeRc(rch);
    return result;
}

string filePath = "C:/Users/ACER/Desktop/DSP_ASSIGNMENT1/DSPASS1/src/Database.json";

service storageSystem on ep {

    resource function addRecord(grpc:Caller caller, clientRqRecord value) {
      
        // the path for the json file
        string filePath = "C:/Users/ACER/Desktop/DSP_ASSIGNMENT1/DSPASS1/src/Database.json";
        //this is the hash function
        string stringvalue = value.toString();
        byte [] bytevalue = stringvalue.toBytes();
        byte [] cryptovalue = crypto:hashMd5(bytevalue);
        value.hashkey = cryptovalue.toBase16();
        value.ver = "1.1";
    //we converted the clientRecord value into a json map 
        map<json>|error recordStore=map<json>.constructFrom(value);
   // in this following line we storing the key and version into the recordRes
        RecordRes keyver = {hashkey : value.hashkey,ver :value.ver };
    
    //in this this following line we are respondig the key and version to the client 
        var result1122 = caller->send(keyver);
    
    //we are attempting to create a json file here
        json filefinal= <json> recordStore;
         var wResult = write(filefinal,filePath);
                if (wResult is error) {
                    log:printError("Error occurred while writing json: ", wResult);
                } else {
                    io:println("Preparing to read the content written");

                }
    }

    resource function updateRecord(grpc:Caller caller, RecUpdate value) {
        // Implementation goes here.
        string stringvalue = value.toString();
        byte [] bytevalue = stringvalue.toBytes();
        byte [] cryptovalue = crypto:hashMd5(bytevalue);
        value.hashkey = cryptovalue.toBase16();
        value.ver = "1.1";
        //to convert string values to numeric values
        float|error resultfloat = 'float:fromString(value.ver);
        resultfloat =+ 1;

    //this conversion needed to be done inorder to store the modified copy(update) in the file 
         map<json>|error recordStore=map<json>.constructFrom(value);
            json modifiedCopy= <json> recordStore;

                   var readfile = read(filePath);
                   json filefinal= <json>readfile;

         if (value.hashkey != filefinal.hashkey || value.ver != filefinal.ver){

              io:println("Record does not exist!");

            } else{
                    var writeToFile = write(modifiedCopy, filePath);
            
            }
            //we got lost we dont know how to go about printing
     UpdateResponse keyver = {hashkey : value.hashkey,ver :value.ver };
        var resultfin= caller->send(keyver);
    }
    resource function readRecord(grpc:Caller caller, RecReadKey value) {
        // Implementation goes here.
           
        // You should return a ReadResponse
    }
}

public type Artists record {|
    string name = "";
    string member = "";
    
|};

public type Songs record {|
    string title = "";
    string genre = "";
    
|};

public type clientRqRecord record {|
    string date = "";
    Artists[] art = [];
    string band = "";
    Songs[] son = [];
    string hashkey = "";
    string ver = "";
    
|};

public type RecordRes record {|
    string hashkey = "";
    string ver = "";
    
|};

public type RecUpdate record {|
    string hashkey = "";
    string ver = "";
    clientRqRecord? Uprecord = ();
    
|};

public type UpdateResponse record {|
    string hashkey = "";
    string ver = "";
    
|};

public type RecReadKey record {|
    string hashkey = "";
    
|};

public type RecReadKeyandVer record {|
    string hashkey = "";
    string ver = "";
    
|};

public type ReadResponse record {|
    string recordReceive = "";
    
|};



const string ROOT_DESCRIPTOR = "0A0A746869732E70726F746F22350A074172746973747312120A046E616D6518012001280952046E616D6512160A066D656D62657218022001280952066D656D62657222330A05536F6E677312140A057469746C6518012001280952057469746C6512140A0567656E7265180220012809520567656E7265229A010A0E636C69656E7452715265636F726412120A0464617465180120012809520464617465121A0A0361727418022003280B32082E41727469737473520361727412120A0462616E64180320012809520462616E6412180A03736F6E18042003280B32062E536F6E67735203736F6E12180A07686173686B65791805200128095207686173686B657912100A03766572180620012809520376657222370A095265636F726452657312180A07686173686B65791801200128095207686173686B657912100A03766572180220012809520376657222640A0952656355706461746512180A07686173686B65791801200128095207686173686B657912100A037665721802200128095203766572122B0A0855707265636F726418032001280B320F2E636C69656E7452715265636F7264520855707265636F7264223C0A0E557064617465526573706F6E736512180A07686173686B65791801200128095207686173686B657912100A03766572180220012809520376657222260A0A526563526561644B657912180A07686173686B65791801200128095207686173686B6579223E0A10526563526561644B6579616E6456657212180A07686173686B65791801200128095207686173686B657912100A03766572180220012809520376657222340A0C52656164526573706F6E736512240A0D7265636F726452656365697665180120012809520D7265636F7264526563656976653290010A0D73746F7261676553797374656D12280A096164645265636F7264120F2E636C69656E7452715265636F72641A0A2E5265636F7264526573122B0A0C7570646174655265636F7264120A2E5265635570646174651A0F2E557064617465526573706F6E736512280A0A726561645265636F7264120B2E526563526561644B65791A0D2E52656164526573706F6E7365620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "this.proto":"0A0A746869732E70726F746F22350A074172746973747312120A046E616D6518012001280952046E616D6512160A066D656D62657218022001280952066D656D62657222330A05536F6E677312140A057469746C6518012001280952057469746C6512140A0567656E7265180220012809520567656E7265229A010A0E636C69656E7452715265636F726412120A0464617465180120012809520464617465121A0A0361727418022003280B32082E41727469737473520361727412120A0462616E64180320012809520462616E6412180A03736F6E18042003280B32062E536F6E67735203736F6E12180A07686173686B65791805200128095207686173686B657912100A03766572180620012809520376657222370A095265636F726452657312180A07686173686B65791801200128095207686173686B657912100A03766572180220012809520376657222640A0952656355706461746512180A07686173686B65791801200128095207686173686B657912100A037665721802200128095203766572122B0A0855707265636F726418032001280B320F2E636C69656E7452715265636F7264520855707265636F7264223C0A0E557064617465526573706F6E736512180A07686173686B65791801200128095207686173686B657912100A03766572180220012809520376657222260A0A526563526561644B657912180A07686173686B65791801200128095207686173686B6579223E0A10526563526561644B6579616E6456657212180A07686173686B65791801200128095207686173686B657912100A03766572180220012809520376657222340A0C52656164526573706F6E736512240A0D7265636F726452656365697665180120012809520D7265636F7264526563656976653290010A0D73746F7261676553797374656D12280A096164645265636F7264120F2E636C69656E7452715265636F72641A0A2E5265636F7264526573122B0A0C7570646174655265636F7264120A2E5265635570646174651A0F2E557064617465526573706F6E736512280A0A726561645265636F7264120B2E526563526561644B65791A0D2E52656164526573706F6E7365620670726F746F33"
        
    };
}




