
GEN=index.html
WEB=ygrek@ocaml-mysql.forge.ocamlcore.org:/home/groups/ocaml-mysql/htdocs

html: $(GEN)

%.html: %.brtx
	brtx -html -doc -i $< -o $@

upload: index.html dbspeed.svg
	rsync -avihz $^ $(WEB)/
	make -C .. htdoc
	rsync -avihz ../doc/mysql/html/ $(WEB)/doc/

clean:
	rm -f $(GEN)

