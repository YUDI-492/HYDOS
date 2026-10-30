#include "Render/framment.hyd"
extern "C" [[noreturn]] void HYD_MyMainIove()
{
    fb fb1;
    clear(fb1, 0xFFFF69B4);

   
    Drawrect(fb1, 100, 100, 300, 200,  0xFF000000);

   
    Drawrect(fb1, 500, 200, 100, 100, 0xFFFFFFFF);
    
    while(1)
    {
        asm volatile ("hlt");
    }
}