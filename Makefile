all: static shared

build/_deps/jinja2cpp:
	mkdir -p build/_deps
	cd build/_deps && git clone git@github.com:jinja2cpp/Jinja2Cpp.git jinja2cpp
	cd build/_deps/jinja2cpp && git checkout 1.3.2


build/libjinja2cpp.a: build/_deps/jinja2cpp
	cd build/_deps/jinja2cpp && cmake -B build -DJINJA2CPP_STRICT_WARNINGS=OFF -DJINJA2CPP_BUILD_TESTS=OFF
	cd build/_deps/jinja2cpp && cmake  --build build --config Release -j8
	cp build/_deps/jinja2cpp/build/libjinja2cpp.a build/
	cp build/_deps/jinja2cpp/build/_deps/fmt-build/libfmt.a build/


static: build/libjinja2cpp.a
	c++ -std=c++14  -c \
		-Ibuild/_deps/jinja2cpp/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/variant-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/optional-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/string-view-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/expected-lite-src/include  \
		src/basic_interface.cpp -o build/basic_interface.o
	c++ -std=c++14  -c \
		-Ibuild/_deps/jinja2cpp/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/variant-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/optional-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/string-view-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/expected-lite-src/include  \
		src/advanced_interface.cpp -o build/advanced_interface.o
	c++ -std=c++14  -c \
		-Ibuild/_deps/jinja2cpp/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/variant-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/optional-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/string-view-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/expected-lite-src/include  \
		src/shared_internal.cpp -o build/shared_internal.o
	cd build && ar rcsv libjinja2cpp.a basic_interface.o advanced_interface.o shared_internal.o
	clang -c  \
		src/basic_main.c \
		-o build/basic_main.o
	c++ -std=c++14 \
		build/basic_main.o \
		build/libjinja2cpp.a \
		build/libfmt.a \
		-o build/basic_main_static
	clang -c  \
		src/advanced_main.c \
		-o build/advanced_main.o
	c++ -std=c++14 \
		build/advanced_main.o \
		build/libjinja2cpp.a \
		build/libfmt.a \
		-o build/advanced_main_static
	@echo "Done"


build/libjinja2cpp.dylib: build/_deps/jinja2cpp
	cd build/_deps/jinja2cpp && cmake -B build -DJINJA2CPP_STRICT_WARNINGS=OFF -DJINJA2CPP_BUILD_SHARED=ON
	cd build/_deps/jinja2cpp && cmake  --build build --config Release -j8
	cp build/_deps/jinja2cpp/build/libjinja2cpp*.dylib build/


shared: build/libjinja2cpp.dylib 
	c++ -std=c++14  \
		-Ibuild/_deps/jinja2cpp/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/variant-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/optional-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/string-view-lite-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp/build/_deps/expected-lite-src/include \
		-Lbuild -ljinja2cpp \
		-dynamiclib \
		src/basic_interface.cpp src/advanced_interface.cpp src/shared_internal.cpp \
		-o build/libjinja2c.dylib
	clang -c  \
		src/basic_main.c \
		-o build/basic_main.o
	c++ -std=c++14 \
		build/basic_main.o \
		-Lbuild -ljinja2c -rpath build \
		-o build/basic_main_shared
	clang -c  \
		src/advanced_main.c \
		-o build/advanced_main.o
	c++ -std=c++14 \
		build/advanced_main.o \
		-Lbuild -ljinja2c -rpath build \
		-o build/advanced_main_shared
	@echo "Done"


build/_deps/ios.toolchain.cmake:
	wget https://raw.githubusercontent.com/leetal/ios-cmake/master/ios.toolchain.cmake -O build/_deps/ios.toolchain.cmake

build/_deps/jinja2cpp_ios:
	mkdir -p build/_deps
	cd build/_deps && git clone git@github.com:jinja2cpp/Jinja2Cpp.git jinja2cpp_ios
	cd build/_deps/jinja2cpp_ios && git checkout 1.3.2


build/libjinja2cpp_ios_tmp.a: build/_deps/jinja2cpp_ios build/_deps/ios.toolchain.cmake
	cd build/_deps/jinja2cpp_ios && cmake -B build -G Xcode -DCMAKE_TOOLCHAIN_FILE=../ios.toolchain.cmake -DPLATFORM=OS64 -DJINJA2CPP_STRICT_WARNINGS=OFF -DJINJA2CPP_BUILD_TESTS=OFF
	cd build/_deps/jinja2cpp_ios && cmake  --build build --config Release -j8
	cp build/_deps/jinja2cpp_ios/build/Release-iphoneos/libjinja2cpp.a build/libjinja2cpp_ios_tmp.a

build/libfmt_ios.a: build/libjinja2cpp_ios.a
	cp build/_deps/jinja2cpp_ios/build/_deps/fmt-build/Release-iphoneos/libfmt.a build/libfmt_ios.a

IOS_CPP=$(shell xcrun -sdk iphoneos -find clang++)
IOS_CPPFLAGS=-target arm64-apple-ios13.0 '-stdlib=libc++' '-std=gnu++14' -isysroot ${IOS_SDK}
IOS_AR=$(shell xcrun -sdk iphoneos -find ar)
IOS_SDK=$(shell xcrun --sdk iphoneos --show-sdk-path)
ios: build/libjinja2cpp_ios_tmp.a build/libfmt_ios.a
	${IOS_CPP} ${IOS_CPPFLAGS} \
		-Ibuild/_deps/jinja2cpp_ios/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/variant-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/optional-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/string-view-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/expected-lite-src/include  \
		-c src/basic_interface.cpp -o build/basic_interface.o

	${IOS_CPP} ${IOS_CPPFLAGS} \
		-Ibuild/_deps/jinja2cpp_ios/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/variant-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/optional-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/string-view-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/expected-lite-src/include  \
		-c src/advanced_interface.cpp -o build/advanced_interface.o

	${IOS_CPP}  ${IOS_CPPFLAGS}\
		-Ibuild/_deps/jinja2cpp_ios/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/variant-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/optional-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/string-view-lite-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/rapidjson-src/include \
		-Ibuild/_deps/jinja2cpp_ios/build/_deps/expected-lite-src/include  \
		-c src/shared_internal.cpp -o build/shared_internal.o

	cd build && ${IOS_AR} -x libjinja2cpp_ios_tmp.a
	cd build && ${IOS_AR} -x libfmt_ios.a
	cd build && ${IOS_AR} rcsv libjinja2cpp_ios_tmp.a *.o
	mv build/libjinja2cpp_ios_tmp.a build/libjinja2cpp_ios.a
	rm build/libfmt_ios.a build/*.o
	@echo "Done"
	

clean:
	rm -rf build
	@echo "Done"
