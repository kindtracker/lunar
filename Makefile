CC = cc
CFLAGS = -O2 -Wall -Wextra -Werror
LIBS = -lm -llua -lSDL2 -lSDL2_ttf -lSDL2_image

ASSET = asset
SRC = src
BUILD = build
OUT = $(BUILD)/lunar

CSRC = $(shell find $(SRC) -type f -name '*.c')
COBJ = $(patsubst %.c,$(BUILD)/%.o,$(CSRC))

all: clean compile

clean:
	mkdir -p $(BUILD)
	rm -rf $(BUILD)/*

compile: $(OUT)
	cp -R $(ASSET) $(BUILD)/.

web:
	python3 -m http.server 8080

$(OUT): $(COBJ)
	$(CC) $(CFLAGS) -o $(OUT) $(COBJ) $(LIBS)

$(BUILD)/%.o : %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c -o $@ $<
