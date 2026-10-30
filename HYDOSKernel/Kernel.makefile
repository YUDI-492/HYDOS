HYD_cpp:=clang++
HYD_Link:=ld.lld

TARGET_ARCH := x86_64-unknown-none-elf
BUILD_DIR := build
HYD_KERNEL := $(BUILD_DIR)/kernel.elf

HYD_CPPFLAGS:=\
	--target=x86_64-unknown-none-elf \
	-ffreestanding \
	-fno-stack-protector \
	-fno-exceptions \
	-fno-rtti \
	-fno-pic \
	-fno-pie \
	-mno-red-zone \
	-mcmodel=kernel \
	-mno-mmx \
	-mno-sse\
	 -MMD \
	-MP

HYD_LinkFLAG:=\
	-T ../linker.ld \
	-z max-page-size=0x1000 
	
HYD_SOURCES := kernel.cpp Log/Log.cpp Render/framment.cpp
HYD_OBJECTS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(HYD_SOURCES))
HYD_DEPS := $(HYD_OBJECTS:.o=.d)

all: $(HYD_KERNEL)
$(HYD_KERNEL):$(HYD_OBJECTS) ../linker.ld
	@mkdir -p $(dir $@)
	$(HYD_Link) $(HYD_LinkFLAG) -o $@ $(HYD_OBJECTS)
	
$(BUILD_DIR)/%.o:%.cpp 
	@mkdir -p $(dir $@)
	$(HYD_cpp) $(HYD_CPPFLAGS) -c $< -o $@ 

-include $(HYD_DEPS)
clean:
	rm -rf $(BUILD_DIR)
rebuild: clean all
%.o: %.cpp