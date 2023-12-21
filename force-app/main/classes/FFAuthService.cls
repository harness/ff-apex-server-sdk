public interface FFAuthService {
    FFModels.AuthInfo authenticate(Boolean force);
    FFModels.LastAuthTime getLastAuthTime();
    
} 