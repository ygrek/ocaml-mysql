
GEN=index.html
WEB=ygrek@ocaml-mysql.forge.ocamlcore.org:/home/groups/ocaml-mysql/htdocs

html: $(GEN)

%.html: %.brtx
	brtx -html -doc -i $< -o $@

upload: index.html
	scp $< $(WEB)/
	make -C .. htdoc
	rsync -avz ../doc/mysql/html/ $(WEB)/doc/

clean:
	rm -f $(GEN)

