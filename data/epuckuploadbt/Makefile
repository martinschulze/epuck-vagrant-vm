epuckuploadbt: epuckuploadbt.o
	${CXX} $< -lbluetooth -o $@

install: epuckuploadbt
	cp epuckuploadbt /usr/bin/epuckuploadbt

clean:
	rm -f epuckuploadbt epuckuploadbt.o *~
