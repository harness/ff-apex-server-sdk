public interface FFAuthenticator {
    FFModels.AuthenticationResponse authenticate(Map<String, Object> params);
}