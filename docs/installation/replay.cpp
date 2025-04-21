#include <Windows.h>
#include <iostream>
#include <string>
#include <filesystem>

#define BUF_SIZE 0x2000

char* payload = NULL;
char* output = NULL;
DWORD byteRead = NULL;

uint32_t u32(unsigned char* data) {
    return (uint32_t)data[0] | ((uint32_t)data[1] << 8) | ((uint32_t)data[2] << 16) | ((uint32_t)data[3] << 24);
}
//12 34 56 00

int wmain(int argc, wchar_t* argv[]) {
    if (argc != 3) {
        wprintf(L"Usage: %s [SymLink] [payload]\n", argv[0]);
        return 0;
    }

    HANDLE hDriver = CreateFileW(argv[1], GENERIC_READ | GENERIC_WRITE, 0, NULL, OPEN_EXISTING, 0, NULL);

    if (hDriver == INVALID_HANDLE_VALUE) {
        printf("Handle open error..\n");
        return 0;
    }  

    HANDLE hFile = CreateFileW(argv[2], GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE) {
        printf("Payload open error..\n");
        return 0;
    }

    LARGE_INTEGER fileSize;
    if (!GetFileSizeEx(hFile, &fileSize) || fileSize.QuadPart <= 0) {
        printf("Get file size fail..\n");
        return 0;
    }
    DWORD dFileSize = fileSize.LowPart;

    payload = (char*)VirtualAlloc(NULL, ((dFileSize + 0x1000 - 1) / 0x1000) * 0x1000, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    output = (char*)VirtualAlloc(NULL, BUF_SIZE, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);

    if (!ReadFile(hFile, payload, (DWORD)fileSize.QuadPart, &byteRead, NULL) || byteRead != fileSize.QuadPart) {
        printf("File read fail..\n");
        return 0;
    }

    size_t start = 0;

    while (dFileSize - start >= 16) {
        uint32_t magic = u32((unsigned char *)&payload[start]);
        uint32_t ioctl_code = u32((unsigned char*)&payload[start + 4]);
        uint32_t inbuffer_length = u32((unsigned char*)&payload[start + 8]);
        uint32_t outbuffer_length = u32((unsigned char*)&payload[start + 12]);

        if (magic != 0x4f494f49) {
            printf("Magic Error..\n");
            return -1;
        }

        if (dFileSize - start < 16 + inbuffer_length) {
            break;
        }

        char* input = &payload[start + 16];

        NTSTATUS res = DeviceIoControl(hDriver, ioctl_code, input, inbuffer_length, output, outbuffer_length, &byteRead, 0);
        printf("IOCTL: %lx, inputLen: %lx, outputLen: %lx success: %d\n", ioctl_code & 0xffffffff, inbuffer_length & 0xffffffff, outbuffer_length & 0xffffffff, res);

        start = start + inbuffer_length + 16;
        memset(output, 0, BUF_SIZE);
    }
    
    system("pause");
    return 0;
}