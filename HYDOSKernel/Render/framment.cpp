#include"framment.hyd"
#include"../Log/Log.h"
__attribute__((used, section(".limine_requests")))
static volatile limine_framebuffer_request framebuffer_request = {
    LIMINE_FRAMEBUFFER_REQUEST_ID,
    0,
    nullptr
};

fb::fb()
{
    if(!Init())
    {
        DebugPrint("获取失败");
    }
    DebugPrint("okok");
    DebugPutChar('\n');
    DebugPrintUInt(width);
    DebugPutChar('\n');
    DebugPrintUInt(height);
    DebugPutChar('\n');
    DebugPrintUInt(pitch);
    DebugPutChar('\n');
    DebugPrintUInt(bpp);
}
bool fb::Init()
{
    if(framebuffer_request.response==nullptr)
    {
        return false;
    }
    {
        address  = framebuffer_request.response->framebuffers[0]->address;
        width    = framebuffer_request.response->framebuffers[0]->width;
        height   = framebuffer_request.response->framebuffers[0]->height;
        pitch    = framebuffer_request.response->framebuffers[0]->pitch;
        bpp      = framebuffer_request.response->framebuffers[0]->bpp;
        
        return true;
    }

}

void putpixel(fb &fb1,uint64_t x, uint64_t y, uint32_t color)
{
        if (x >= fb1.width || y >= fb1.height)
        return;

    uint8_t* base = (uint8_t*)fb1.address;

    uint32_t* pixel =
        (uint32_t*)(base
        + y * fb1.pitch
        + x * (fb1.bpp / 8));

    *pixel = color;
}

void clear(fb& fb1,uint32_t color)
{
    for(uint64_t y = 0; y < fb1.height; ++y)
    {
        for(uint64_t x = 0; x < fb1.width; ++x)
        {
            putpixel(fb1,x, y, color);
        }
    }
}

void Drawrect(fb& fb1,uint64_t x,uint64_t y,uint64_t w,uint64_t h,uint32_t color)
{
    for(uint64_t i=0;i<w;++i)
    {
        for(uint64_t j=0;j<h;++j)
        {
            putpixel(fb1,x+i,y+j,color);
        }
    }
}

