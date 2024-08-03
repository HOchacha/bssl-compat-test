#include <stdio.h>
#include <openssl/sha.h>

int main() {
    const char *data = "Hello, boringSSL!";
    unsigned char hash[SHA256_DIGEST_LENGTH];
    
    SHA256_CTX sha256;
    SHA256_Init(&sha256);
    SHA256_Update(&sha256, data, strlen(data));
    SHA256_Final(hash, &sha256);
    
    printf("SHA-256 해시: ");
    for(int i = 0; i < SHA256_DIGEST_LENGTH; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n");
    
    return 0;
}
