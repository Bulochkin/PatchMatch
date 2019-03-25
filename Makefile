#
# Makefile
# Jiayuan Mao, 2019-01-09 13:59
#

SRC_DIR = source
INC_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
TARGET = patchmatch

CXX = $(ENVIRONMENT_OPTIONS) g++

BIN_TARGET = $(BIN_DIR)/$(TARGET)
#PROF_FILE = $(BIN_TARGET).prof

INCLUDE_DIR = -I $(SRC_DIR) -I $(INC_DIR)

CXXFLAGS = -O2 -w

CXXFLAGS += -std=c++11
CXXFLAGS += $(INCLUDE_DIR)
# CXXFLAGS += -I /usr/local/Cellar/opencv@2/2.4.13.7_2/include
# CXXFLAGS += -L /usr/local/Cellar/opencv@2/2.4.13.7_2/lib -lopencv_calib3d -lopencv_contrib -lopencv_core -lopencv_features2d -lopencv_flann -lopencv_gpu -lopencv_highgui -lopencv_imgproc -lopencv_legacy -lopencv_ml -lopencv_nonfree -lopencv_objdetect -lopencv_ocl -lopencv_photo -lopencv_stitching -lopencv_superres -lopencv_ts -lopencv_video -lopencv_videostab
CXXFLAGS += $(shell pkg-config --cflags --libs opencv)


CXXSOURCES = $(shell find $(SRC_DIR)/ -name "*.cpp")
OBJS = $(addprefix $(OBJ_DIR)/,$(CXXSOURCES:.cpp=.o))
DEPFILES = $(OBJS:.o=.d)

.PHONY: all clean run rebuild gdb

all: $(BIN_TARGET)

$(OBJ_DIR)/%.o: %.cpp
	@echo "[CC] $< ..."
	@$(CXX) -c $< $(CXXFLAGS) -o $@

$(OBJ_DIR)/%.d: %.cpp
	@mkdir -pv $(dir $@)
	@echo "[dep] $< ..."
	@$(CXX) $(INCLUDE_DIR) $(CXXFLAGS) -MM -MT "$(OBJ_DIR)/$(<:.cpp=.o) $(OBJ_DIR)/$(<:.cpp=.d)" "$<" > "$@"

sinclude $(DEPFILES)

$(BIN_TARGET): $(OBJS)
	@echo "[link] $< ..."
	@mkdir -p $(BIN_DIR)
	@$(CXX) $(OBJS) -o $@ $(CXXFLAGS)
	@echo have a nice day!

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

run: $(BIN_TARGET)
	./$(BIN_TARGET)

rebuild:
	+@make clean
	+@make

# vim:ft=make
#
