public class FFAuthResult {

    public final String authToken { get; set; }

    public final String environmentUUID { get; set; }

    public final String cluster { get; set; }

    public FFAuthResult(String authToken, String environmentUUID, String cluster) {
       this.authToken = authToken;
       this.environmentUUID = environmentUUID;
       this.cluster = cluster;
    }


}

