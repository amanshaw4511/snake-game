
publish:
	rm -rf build/web
	mkdir -p ./build/web
	godot --headless --export-release Web ./build/web/index.htm
	zip -r snake.zip ./build/web
	scp snake.zip aman@racknerd:~/snake
	rm snake.zip
	
