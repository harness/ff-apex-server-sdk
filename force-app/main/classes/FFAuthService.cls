public interface FFAuthService {
    FFModels.AuthInfo authenticate(Boolean force);
    String getLastAuthTime();
} 