public interface FFAuthService {
    FFModels.AuthInfo authenticate(Boolean force);
    Long getLastAuthTime();
} 