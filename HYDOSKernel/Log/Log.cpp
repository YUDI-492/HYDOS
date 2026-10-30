#include"Log.h"
void DebugPutChar(char c)
{
    asm volatile(
        "outb %0, %1"
        :
        : "a"(c), "Nd"((uint16_t)0xE9)
    );
}

void DebugPrint(const char* str)
{
    while (*str)
    {
        DebugPutChar(*str++);
    }
}

void DebugPrintUInt(uint64_t value)
{
    char buffer[32];
    int index = 0;

    if (value == 0)
    {
        DebugPutChar('0');
        return;
    }

    while (value > 0)
    {
        buffer[index++] = '0' + (value % 10);
        value /= 10;
    }

    while (index > 0)
    {
        DebugPutChar(buffer[--index]);
    }
}