public abstract class FFModels {

    public class AuthenticationRequest {
        public String apiKey { get; set; }
        public Map<String, String> target { get; set; }
    }

    public class AuthenticationResponse {
        public String authToken { get; set; }
    }

    public class AuthInfo {
        public final String authToken { get; set; }
        public final String environmentUUID { get; set; }
        public final String cluster { get; set; }
        public AuthInfo(String authToken, String environmentUUID, String cluster) {
           this.authToken = authToken;
           this.environmentUUID = environmentUUID;
           this.cluster = cluster;
        }
    }

    public class JWTClaims {
        public String environment {get;set;}
        public String clusterIdentifier {get;set;}
    }

}