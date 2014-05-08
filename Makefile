# Builds gtest.a and gtest_main.a.# Usually you shouldn't tweak such internal variables, indicated by a# trailing _.GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.c $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)# For simplicity and to avoid depending on Google Test's# implementation details, the dependencies specified below are# conservative and not optimized.  This is fine as Google Test# compiles fast and for ordinary users its source rarely changes.gtest-all.o : $(GTEST_SRCS_)    $(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \            $(GTEST_DIR)/src/gtest-all.ccgtest_main.o : $(GTEST_SRCS_)    $(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \            $(GTEST_DIR)/src/gtest_main.ccminIni.o : $(GTEST_SRCS_)    $(CC) -I$(GTEST_DIR)/include/gtest -c $(GTEST_DIR)/src/minIni.cgtest.a : gtest-all.o    $(AR) $(ARFLAGS) $@ $^gtest_main.a : gtest-all.o gtest_main.o minIni.o    $(AR) $(ARFLAGS) $@ $^# Builds a sample test.  A test should link with either gtest.a or# gtest_main.a, depending on whether it defines its own main()# function.#test.o : $(USER_DIR)/test.cpp $(GTEST_HEADERS)#   $(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/test.cpp$(TEST_OBJ):%.o:%.cpp     $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@$(TESTS) : $(TEST_OBJ) $(COMM_OBJ) gtest_main.a    $(CXX) $(CXXFLAGS) $(CPPFLAGS) -lpthread $^ -o $@ $(LDFLAGS)    $(hide) mkdir -p $(IPC_TEST_APP_PATH)/source    cp -a $(SOURCE_DIR)/* $(IPC_TEST_APP_PATH)/source/;     cp -a $(TESTS) $(IPC_TEST_APP_PATH);     rm -f $(TESTS) gtest.a gtest_main.a *.o    rm -f $(COMM_OBJ)