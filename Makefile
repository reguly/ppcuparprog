.PHONY: build run clean tbuild test bbuild benchmark valgrind testAll

build:
	cmake -E make_directory $(CURDIR)/release
	cmake -S $(CURDIR) -B $(CURDIR)/release -DCMAKE_BUILD_TYPE=Release -DUSE_WARNINGS=ON -DENABLE_TESTING=OFF -DENABLE_BENCHMARK=OFF
	cmake --build $(CURDIR)/release --parallel

run: build
	./release/acm 128 2000

clean:
	$(MAKE) -C release clean
	$(MAKE) -C debug clean
	$(MAKE) -C build clean

tbuild:
	cmake -E make_directory $(CURDIR)/debug
	cmake -S $(CURDIR) -B $(CURDIR)/debug -DCMAKE_BUILD_TYPE=Debug -DUSE_WARNINGS=ON -DENABLE_TESTING=ON
	cmake --build $(CURDIR)/debug --parallel

test: tbuild
	ctest -V --test-dir debug

bbuild:
	cmake -E make_directory $(CURDIR)/release
	cmake -S $(CURDIR) -B $(CURDIR)/release -DCMAKE_BUILD_TYPE=Release -DUSE_WARNINGS=ON -DENABLE_TESTING=OFF -DENABLE_BENCHMARK=ON
	cmake --build $(CURDIR)/release --parallel

benchmark: bbuild
	./release/benchmark/benchacm --benchmark_filter=BM_solveV*

valgrind: tbuild
	valgrind -s debug/acm 16

testAll: test valgrind