#ifndef HYDOS_LOG_H
#define HYDOS_LOG_H
#include <stdint.h>
void DebugPutChar(char c);
void DebugPrint(const char* str);
void DebugPrintUInt(uint64_t value);
#endif