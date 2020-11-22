import ballerina/grpc;

public type CaliBasedSongsStorageSystemBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function Insert(Record req, grpc:Headers? headers = ()) returns ([savedResponse, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("CaliBasedSongsStorageSystem/Insert", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<savedResponse>result, resHeaders];
        
    }

    public remote function Update(updatedRecord req, grpc:Headers? headers = ()) returns ([Confirmation, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("CaliBasedSongsStorageSystem/Update", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Confirmation>result, resHeaders];
        
    }

    public remote function Delete(readKey req, grpc:Headers? headers = ()) returns ([Confirmation, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("CaliBasedSongsStorageSystem/Delete", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Confirmation>result, resHeaders];
        
    }

    public remote function RecordRead(readKey req, grpc:Headers? headers = ()) returns ([Record, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("CaliBasedSongsStorageSystem/RecordRead", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Record>result, resHeaders];
        
    }

    public remote function KeyVersionRead(savedResponse req, grpc:Headers? headers = ()) returns ([Record, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("CaliBasedSongsStorageSystem/KeyVersionRead", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Record>result, resHeaders];
        
    }

    public remote function ReadByCriteria(criteria req, grpc:Headers? headers = ()) returns ([RecordList, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("CaliBasedSongsStorageSystem/ReadByCriteria", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<RecordList>result, resHeaders];
        
    }

};

public type CaliBasedSongsStorageSystemClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function Insert(Record req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("CaliBasedSongsStorageSystem/Insert", req, msgListener, headers);
    }

    public remote function Update(updatedRecord req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("CaliBasedSongsStorageSystem/Update", req, msgListener, headers);
    }

    public remote function Delete(readKey req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("CaliBasedSongsStorageSystem/Delete", req, msgListener, headers);
    }

    public remote function RecordRead(readKey req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("CaliBasedSongsStorageSystem/RecordRead", req, msgListener, headers);
    }

    public remote function KeyVersionRead(savedResponse req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("CaliBasedSongsStorageSystem/KeyVersionRead", req, msgListener, headers);
    }

    public remote function ReadByCriteria(criteria req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("CaliBasedSongsStorageSystem/ReadByCriteria", req, msgListener, headers);
    }

};

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



const string ROOT_DESCRIPTOR = "0A1270726F746F636F6C46696C652E70726F746F228C030A065265636F7264121E0A0A5265636F72644E616D65180120012809520A5265636F72644E616D65121E0A0A5265636F726444617465180220012809520A5265636F726444617465121E0A0A5265636F726442616E64180320012809520A5265636F726442616E6412280A08736F6E674C69737418042003280B320C2E5265636F72642E536F6E675208736F6E674C697374122E0A0A6172746973744C69737418052003280B320E2E5265636F72642E417274697374520A6172746973744C69737412100A034B657918062001280952034B657912180A0756657273696F6E180720012805520756657273696F6E1A560A04536F6E6712140A055469746C6518012001280952055469746C6512140A0547656E7265180220012809520547656E726512220A0C536F6E67506C6174666F726D180320012809520C536F6E67506C6174666F726D1A440A06417274697374121E0A0A6172746973744E616D65180120012809520A6172746973744E616D65121A0A0869734D656D626572180220012808520869734D656D62657222280A0C436F6E6669726D6174696F6E12180A07636F6E6669726D1801200128085207636F6E6669726D22270A07726561644B6579121C0A097265636F72644B657918012001280952097265636F72644B6579225C0A08637269746572696112140A055469746C6518012001280952055469746C65121E0A0A6172746973744E616D65180220012809520A6172746973744E616D65121A0A0862616E644E616D65180320012809520862616E644E616D65223B0A0A5265636F72644C697374122D0A0D4C6973744F665265636F72647318012003280B32072E5265636F7264520D4C6973744F665265636F72647322530A0D7361766564526573706F6E7365121C0A095265636F72644B657918012001280952095265636F72644B657912240A0D5265636F726456657273696F6E180220012805520D5265636F726456657273696F6E22700A0D757064617465645265636F7264121C0A097265636F72644B657918012001280952097265636F72644B657912240A0D7265636F726456657273696F6E180220012805520D7265636F726456657273696F6E121B0A04736F6E6718032001280B32072E5265636F72645204736F6E673282020A1B43616C694261736564536F6E677353746F7261676553797374656D12210A06496E7365727412072E5265636F72641A0E2E7361766564526573706F6E736512270A06557064617465120E2E757064617465645265636F72641A0D2E436F6E6669726D6174696F6E12210A0644656C65746512082E726561644B65791A0D2E436F6E6669726D6174696F6E121F0A0A5265636F72645265616412082E726561644B65791A072E5265636F726412290A0E4B657956657273696F6E52656164120E2E7361766564526573706F6E73651A072E5265636F726412280A0E526561644279437269746572696112092E63726974657269611A0B2E5265636F72644C697374620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "protocolFile.proto":"0A1270726F746F636F6C46696C652E70726F746F228C030A065265636F7264121E0A0A5265636F72644E616D65180120012809520A5265636F72644E616D65121E0A0A5265636F726444617465180220012809520A5265636F726444617465121E0A0A5265636F726442616E64180320012809520A5265636F726442616E6412280A08736F6E674C69737418042003280B320C2E5265636F72642E536F6E675208736F6E674C697374122E0A0A6172746973744C69737418052003280B320E2E5265636F72642E417274697374520A6172746973744C69737412100A034B657918062001280952034B657912180A0756657273696F6E180720012805520756657273696F6E1A560A04536F6E6712140A055469746C6518012001280952055469746C6512140A0547656E7265180220012809520547656E726512220A0C536F6E67506C6174666F726D180320012809520C536F6E67506C6174666F726D1A440A06417274697374121E0A0A6172746973744E616D65180120012809520A6172746973744E616D65121A0A0869734D656D626572180220012808520869734D656D62657222280A0C436F6E6669726D6174696F6E12180A07636F6E6669726D1801200128085207636F6E6669726D22270A07726561644B6579121C0A097265636F72644B657918012001280952097265636F72644B6579225C0A08637269746572696112140A055469746C6518012001280952055469746C65121E0A0A6172746973744E616D65180220012809520A6172746973744E616D65121A0A0862616E644E616D65180320012809520862616E644E616D65223B0A0A5265636F72644C697374122D0A0D4C6973744F665265636F72647318012003280B32072E5265636F7264520D4C6973744F665265636F72647322530A0D7361766564526573706F6E7365121C0A095265636F72644B657918012001280952095265636F72644B657912240A0D5265636F726456657273696F6E180220012805520D5265636F726456657273696F6E22700A0D757064617465645265636F7264121C0A097265636F72644B657918012001280952097265636F72644B657912240A0D7265636F726456657273696F6E180220012805520D7265636F726456657273696F6E121B0A04736F6E6718032001280B32072E5265636F72645204736F6E673282020A1B43616C694261736564536F6E677353746F7261676553797374656D12210A06496E7365727412072E5265636F72641A0E2E7361766564526573706F6E736512270A06557064617465120E2E757064617465645265636F72641A0D2E436F6E6669726D6174696F6E12210A0644656C65746512082E726561644B65791A0D2E436F6E6669726D6174696F6E121F0A0A5265636F72645265616412082E726561644B65791A072E5265636F726412290A0E4B657956657273696F6E52656164120E2E7361766564526573706F6E73651A072E5265636F726412280A0E526561644279437269746572696112092E63726974657269611A0B2E5265636F72644C697374620670726F746F33"
        
    };
}

