public abstract class FFModels {

    public class Error {
        public String code { get; set; }
        public String message { get; set; }
        public Object details { get; set; }
    }

    public class AuthenticationRequest {
        public String apiKey { get; set; }
        public Map<String, String> target { get; set; }
    }

    public class AuthenticationRequestTarget {
        public String identifier { get; set; }
        public String name { get; set; }
        public Boolean anonymous { get; set; }
        public Object attributes { get; set; }
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
        public String environmentIdentifier {get;set;}
        public String project {get;set;}
        public String projectIdentifier {get;set;}
        public String accountID {get;set;}
        public String organization {get;set;}
        public String organizationIdentifier {get;set;}
        public String clusterIdentifier {get;set;}
        public String key_type {get;set;}
    }
    
    public class Pagination {
        public Integer version { get; set; }
        public Integer pageCount { get; set; }
        public Integer itemCount { get; set; }
        public Integer pageSize { get; set; }
        public Integer pageIndex { get; set; }
    }
    
}