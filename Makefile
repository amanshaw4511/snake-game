

build:
	mkdir -p ./build/web
	godot --headless --export-release Web ./build/web/index.htm


publish:
	zip -r snake.zip ./build/web
	scp snake.zip aman@racknerd:~/snake
	rm snake.zip


clean-publish: clean build publish

	
clean:
	rm -rf build

clean-build: clean build
